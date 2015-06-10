package {
	import flash.utils.IDataOutput;
	import flash.geom.Rectangle;
	import mx.utils.StringUtil;

	public class MMLSong {
		protected var instrumentDefinitions:Vector.<String>;
		protected var mmlToUseInstrument:Vector.<String>;
		protected var noteDivisions:uint = 4;
		protected var bpm:uint = 120;
		protected var lengthOfPattern:uint = 16;
		protected var monophonicTracksForBoscaTrack:Vector.<Vector.<String>>;

		public function MMLSong() {
		}

		public function loadFromLiveBoscaCeoilModel():void {
			noteDivisions = control.barcount;
			bpm = control.bpm;
			lengthOfPattern = control.boxcount;

			var emptyBarMML:String = "\n// empty bar\n" + StringUtil.repeat("  r   ", lengthOfPattern) + "\n";
			var bar:uint;
			var patternNum:int;
			var numberOfPatterns:int = control.numboxes;

			instrumentDefinitions = new Vector.<String>();
			mmlToUseInstrument = new Vector.<String>();
			for (var i:uint = 0; i < control.numinstrument; i++) {
				var boscaInstrument:instrumentclass = control.instrument[i];
				if (boscaInstrument.type == 0) { //regular instrument, not a drumkit
					instrumentDefinitions[i] = _boscaInstrumentToMML(boscaInstrument, i);
					mmlToUseInstrument[i] = _boscaInstrumentToMMLUse(boscaInstrument, i);
				} else {
					instrumentDefinitions[i] = "#OPN@" + i + " { //drum kit placeholder\n" +
						"4,6,\n" +
						"31,15, 0, 9, 1, 0, 0,15, 0, 0\n" +
						"31,20, 5,14, 5, 3, 0, 4, 0, 0\n" +
						"31,10, 9, 9, 1, 0, 0,10, 0, 0\n" +
						"31,22, 5,14, 5, 0, 1, 7, 0, 0};\n";
					mmlToUseInstrument[i] = _boscaInstrumentToMMLUse(boscaInstrument, i);
				}
			}

			var monophonicTracksForBoscaPattern:Vector.<Vector.<String>> = new Vector.<Vector.<String>>(numberOfPatterns + 1);
			monophonicTracksForBoscaTrack = new Vector.<Vector.<String>>();
			for (var track:uint = 0; track < 8; track++) {
				var maxMonoTracksForBoscaTrack:uint = 0;
				for (bar = 0; bar < control.arrange.lastbar; bar++) {
					patternNum = control.arrange.bar[bar].channel[track];

					if (patternNum < 0) { continue; }
					var monoTracksForBar:Vector.<String> = _mmlTracksForBoscaPattern(patternNum, control.musicbox);
					maxMonoTracksForBoscaTrack = Math.max(maxMonoTracksForBoscaTrack, monoTracksForBar.length);

					monophonicTracksForBoscaPattern[patternNum] = monoTracksForBar;
				}

				var outTracks:Vector.<String> = new Vector.<String>();
				for(var monoTrackNo:uint = 0; monoTrackNo < maxMonoTracksForBoscaTrack; monoTrackNo++) {
					var outTrack:String = "\n";
					for (bar = 0; bar < control.arrange.lastbar; bar++) {
						patternNum = control.arrange.bar[bar].channel[track];
						if (patternNum < 0) {
							outTrack += emptyBarMML;
							continue;
						}

						monoTracksForBar = monophonicTracksForBoscaPattern[patternNum];
						if (monoTrackNo in monoTracksForBar) {
							outTrack += ("\n// pattern " + patternNum + "\n");
							outTrack += monoTracksForBar[monoTrackNo];
						} else {
							outTrack += emptyBarMML;
						}
					}
					outTracks.push(outTrack)
				}
				monophonicTracksForBoscaTrack[track] = outTracks;
			}
		}

		public function writeToStream(stream:IDataOutput):void {
			var out:String = "";
			out += "/** Music Macro Language (MML) exported from Bosca Ceoil */\n";
			for each (var def:String in instrumentDefinitions) {
				out += def;
				out += "\n";
			}

			for each (var monoTracks:Vector.<String> in monophonicTracksForBoscaTrack) {
				if (monoTracks.length == 0) { continue; } // don't bother printing entirely empty tracks

				out += StringUtil.substitute("\n\n// === Bosca Ceoil track with up to {0} notes played at a time\n", monoTracks.length);

				for each (var monoTrack:String in monoTracks) {
					out += "\n// ---- track\n"

					// XXX: I thought note length would be something like (lengthOfPattern / noteDivisions) but I clearly misunderstand
					out += StringUtil.substitute("\nt{0} l{1} // timing (tempo and note length)\n", bpm, 16);

					out += monoTrack;
					out += ";\n"
				}
			}
			stream.writeMultiByte(out, "utf-8");
		}

		protected function _mmlTracksForBoscaPattern(patternNum:int, patternDefinitions:Vector.<musicphraseclass>):Vector.<String> {
			var tracks:Vector.<String> = new Vector.<String>();

			var pattern:musicphraseclass = patternDefinitions[patternNum];
			var octave:int = -1;

			for (var place:uint = 0; place < lengthOfPattern; place++) {
				var notesInThisSlot:Vector.<String> = new Vector.<String>();
				for (var n:int = 0; n < pattern.numnotes; n++) {
					var note:Rectangle = pattern.notes[n];
					var noteStartingAt:int = note.width;
					var sionNoteNum:int = note.x;
					var noteLength:uint = note.y;
					var noteEndingAt:int = noteStartingAt + noteLength - 1;

					var isNotePlaying:Boolean = (noteStartingAt <= place) && (place <= noteEndingAt);

					if (!isNotePlaying) { continue; }

					var newOctave:int = _octaveFromSiONNoteNumber(sionNoteNum);
					var mmlOctave:String = _mmlTransitionFromOctaveToOctave(octave, newOctave);
					var mmlNoteName:String = _mmlNoteNameFromSiONNoteNumber(sionNoteNum);
					var mmlSlur:String = (noteEndingAt > place) ? "& " : "  ";

					octave = newOctave;

					notesInThisSlot.push(mmlOctave + mmlNoteName + mmlSlur);
				}
				while (notesInThisSlot.length > tracks.length) {
					var emptyTrackSoFar:String = StringUtil.repeat(emptyNoteMML, place);
					tracks.push(mmlToUseInstrument[pattern.instr] + "\n" + emptyTrackSoFar);
				}
				var emptyNoteMML:String = "  r   ";

				for (var track:uint = 0; track < tracks.length; track++) {
					var noteMML:String;
					if (track in notesInThisSlot) {
						noteMML = notesInThisSlot[track];
					} else {
						noteMML = emptyNoteMML;
					}
					tracks[track] += noteMML;
				}
			}

			return tracks;
		}

		/**
		 * XXX: Duplicated from TrackerModuleXM (consider factoring out)
		 */
		protected function _mmlNoteNameFromSiONNoteNumber(noteNum:int):String {
			var noteNames:Vector.<String> = Vector.<String>(['c ', 'c+', 'd ', 'd+', 'e ', 'f ', 'f+', 'g ', 'g+', 'a ', 'a+', 'b ']);

			var noteName:String = noteNames[noteNum % 12];
			return noteName;
		}

		/**
		 * XXX: Duplicated from TrackerModuleXM (consider factoring out)
		 */
		protected function _octaveFromSiONNoteNumber(noteNum:int):int {
			var octave:int = int(noteNum / 12);
			return octave;
		}

		protected function _mmlTransitionFromOctaveToOctave(oldOctave:int, newOctave:int):String {
			if (oldOctave == newOctave) {
				return "  ";
			}
			if ((oldOctave + 1) == newOctave) {
				return "< ";
			}
			if ((oldOctave - 1) == newOctave) {
				return "> ";
			}
			return "o" + newOctave;
		}

		protected function _boscaInstrumentToMML(instrument:instrumentclass, channel:int):String {
			return StringUtil.substitute("// instrument \"{0}\"\n{1}\n", instrument.name, instrument.voice.getMML(channel));
		}

		protected function _boscaInstrumentToMMLUse(instrument:instrumentclass, channel:int):String {
			return StringUtil.substitute("%6@{0} v{1} @f{2},{3}", channel, int(instrument.volume / 16), instrument.cutoff, instrument.resonance);
		}

	}
}