package {
	import flash.utils.IDataOutput;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.geom.Rectangle;
	import org.si.sion.SiONDriver;
	import org.si.sion.SiONVoice;
	import co.sparemind.trackermodule.XMSong;
	import co.sparemind.trackermodule.XMInstrument;
	import co.sparemind.trackermodule.XMSample;
	import co.sparemind.trackermodule.XMPattern;
	import co.sparemind.trackermodule.XMPatternLine;
	import co.sparemind.trackermodule.XMPatternCell;

	public class TrackerModuleXM {
		public var xm:XMSong;

		public function loadFromLiveBoscaCeoilModel(bosca:controlclass, desiredSongName:String):void {
			xm = new XMSong;

			xm.songname = desiredSongName;
			xm.defaultBPM = bosca.bpm;
			xm.defaultTempo = int(bosca.bpm / 20);
			xm.numChannels = 8; // bosca has a hard-coded limit
			xm.numInstruments = bosca.numinstrument;
			for (var i:uint = 0; i < bosca.arrange.lastbar; i++) {
				var xmpat:XMPattern = xmPatternFromBoscaBar(bosca, i);
				xm.patterns.push(xmpat);
				xm.patternOrderTable[i] = i;
				xm.numPatterns++;
				xm.songLength++;
			}

			for (i = 0; i < bosca.numinstrument; i++) {
				var boscaInstrument:instrumentclass = bosca.instrument[i];
				var xmInstrument:XMInstrument = new XMInstrument();
				xmInstrument.name = boscaInstrument.name;
				xmInstrument.volume = int(boscaInstrument.volume / 4);
				switch (boscaInstrument.type) {
					case 0:
						xmInstrument.addSample(_boscaInstrumentToXMSample(boscaInstrument, bosca._driver));
						break;
					default:
						// XXX: bosca ceoil drumkits are converted lossily to a single XM
						// instrument, but they could be converted to several instruments.
						var drumkitNumber:uint = boscaInstrument.type - 1;
						xmInstrument.addSamples(_boscaDrumkitToXMSamples(bosca.drumkit[drumkitNumber], bosca._driver));
						for (var s:uint = 0; s < xmInstrument.samples.length; s++) {
							var key:uint = s + 13;
							xmInstrument.keymapAssignments[key] = s;
						}
				}
				xm.addInstrument(xmInstrument);
			}
		}

		public function writeToStream(stream:IDataOutput):void {
			xm.writeToStream(stream);
		}

		protected function xmPatternFromBoscaBar(bosca:controlclass, barNum:uint):XMPattern {
			var numtracks:uint = 8;
			var numrows:uint = bosca.boxcount;
			var pattern:XMPattern = new XMPattern(numrows);
			var rows:Vector.<XMPatternLine> = pattern.rows;
		// 	var lineAllNotesOff = [];
		// 	for (var i:uint = 0; i < numtracks; i++) {
		// 		lineAllNotesOff.push({
		// 			note: 97,
		// 			instrument: 0,
		// 			volume: 0,
		// 			effect: 0,
		// 			effectParam: 0
		// 		});
		// 	}
		// 	rows.push(lineAllNotesOff.slice(0));
			for (var rowToBlank:uint = 0; rowToBlank < numrows; rowToBlank++) {
				rows[rowToBlank] = new XMPatternLine(numtracks);
			}
			// ----------
			for (var i:uint = 0; i < numtracks; i++) {
				var whichbox:int = bosca.arrange.bar[barNum].channel[i];
				if (whichbox < 0) { continue; }
				var box:musicphraseclass = bosca.musicbox[whichbox];

				var notes:Vector.<Rectangle> = box.notes;
				for (var j:uint = 0; j < box.numnotes; j++) {
					var boscaNote:Rectangle = notes[j];
					var timerelativetostartofbar:uint = boscaNote.width; // yes, it's called width. whatever.
					var notelength:uint = boscaNote.y;
					var xmnote:XMPatternCell = boscaBoxNoteToXMNote(box, j);
					rows[timerelativetostartofbar].cellOnTrack[i] = xmnote;
					var endrow:uint = timerelativetostartofbar + notelength;
					if (endrow >= numrows) { continue; }
					if (rows[endrow].cellOnTrack[i].note > 0) { continue; } // someone else is already starting to play
					rows[endrow].cellOnTrack[i] = new XMPatternCell({
						note: 97, // "note off"
						instrument: 0,
						volume: 0,
						effect: 0,
						effectParam: 0
					});
				}
			}
			return pattern;
		}

		protected function boscaBoxNoteToXMNote(box:musicphraseclass, notenum:uint):XMPatternCell {
			return new XMPatternCell(
					{
					note: box.notes[notenum].x + 13, // SiON notes are 0-127, XM is 1-96
					instrument: box.instr + 1,
					volume: 0,
					effect: 0,
					effectParam: 0
			});
		}

		// this conversion is very lossy.
		//
		// bosca drumkits can be much larger than a single XM instrument
		// and an XM instrument can only have one "relative note" setting all
		// samples.
		//
		protected function _boscaDrumkitToXMSamples(drumkit:drumkitclass, driver:SiONDriver):Vector.<XMSample> {
			var samples:Vector.<XMSample> = new Vector.<XMSample>
			for (var d:uint; d < drumkit.size; d++) {
				var voice:SiONVoice = drumkit.voicelist[d];
				var samplename:String = drumkit.voicename[d];
				var sionNoteNum:int = drumkit.voicenote[d];
				var xmNoteNum:uint = sionNoteNum + 13;

				var xmsample:XMSample = new XMSample;
				xmsample.relativeNoteNumber = 0;
				xmsample.name = voice.name;
				xmsample.volume = 0x40;
				xmsample.bitsPerSample = 16;
				xmsample.data = _playSiONNoteTo16BitDeltaSamples(sionNoteNum, voice, 1, driver);

				samples.push(xmsample);
			}
			return samples;
		}

		protected function _boscaInstrumentToXMSample(instrument:instrumentclass, driver:SiONDriver):XMSample {
			var voice:SiONVoice = instrument.voice;
			var xmsample:XMSample = new XMSample;
			xmsample.relativeNoteNumber = 0;
			xmsample.name = voice.name;
			xmsample.volume = 0x40;
			xmsample.bitsPerSample = 16;

			// consider voice.preferableNote
			var c5:int = 60;
			
			xmsample.data = _playSiONNoteTo16BitDeltaSamples(c5, voice, 1, driver);
			return xmsample;
		}

		protected function _playSiONNoteTo16BitDeltaSamples(note:int, voice:SiONVoice, length:Number, driver:SiONDriver):ByteArray {
			var deltasamples:ByteArray = new ByteArray;
			deltasamples.endian = Endian.LITTLE_ENDIAN;

			// XXX: Interferes with regular playback. Find a more reliable way.
			// driver.renderQueue() might work
			driver.stop();

			var renderBuffer:Vector.<Number> = new Vector.<Number>;
			// XXX: only works for %6 (FM synth) voices.
			// theoretically voice.moduleType is 6 for FM and switchable
			var mml:String = voice.getMML(voice.channelNum) + ' %6,' + voice.channelNum + '@' + voice.toneNum + ' ' + _mmlNoteFromSiONNoteNumber(note);
			driver.render(mml, renderBuffer, 1);

			// delta encoding algorithm that module formats like XM use
			var previousSample:int = 0;
			for (var i:uint; i < renderBuffer.length; i++) {
				var thisSample:int = renderBuffer[i] * 32767; // signed float to 16-bit signed int
				var sampleDelta:int = thisSample - previousSample;
				deltasamples.writeShort(sampleDelta);
				previousSample = thisSample;
			}

			return deltasamples;
		}

		/**
		 *
		 * I'm sure there's a better way to do this (eg maybe there's an MML
		 * command for "play note number").
		 */
		protected function _mmlNoteFromSiONNoteNumber(noteNum:int):String {
			var noteNames:Vector.<String> = Vector.<String>(['c', 'c+', 'd', 'd+', 'e', 'f', 'f+', 'g', 'g+', 'a', 'a+', 'b']);

			var octave:int = int(noteNum / 12);
			var noteName:String = noteNames[noteNum % 12];
			return 'o' + octave + noteName;
		}
	}
}

