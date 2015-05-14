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
		public function TrackerModuleXM() {
			
		}
		
		public var xm:XMSong;

		public function loadFromLiveBoscaCeoilModel(desiredSongName:String):void {
			var boscaInstrument:instrumentclass;
			
			xm = new XMSong;
			
			xm.songname = desiredSongName;
			xm.defaultBPM = control.bpm;
			xm.defaultTempo = int(control.bpm / 20);
			xm.numChannels = 8; // bosca has a hard-coded limit
			xm.numInstruments = control.numinstrument;
			
			var notesByEachInstrumentNumber:Vector.<Vector.<int>> = _notesUsedByEachInstrumentAcrossEntireSong();
			
			// map notes to other notes (mostly for drums)
			var perInstrumentBoscaNoteToXMNoteMap:Vector.<Vector.<uint>> = new Vector.<Vector.<uint>>;
			for (i = 0; i < control.numinstrument; i++) {
				boscaInstrument = control.instrument[i];
				var boscaNoteToXMNoteMapForThisInstrument:Vector.<uint> = _boscaNoteToXMNoteMapForInstrument(boscaInstrument, notesByEachInstrumentNumber[i]);
				perInstrumentBoscaNoteToXMNoteMap[i] = boscaNoteToXMNoteMapForThisInstrument;
			}
			
			// pattern arrangement
			for (var i:uint = 0; i < control.arrange.lastbar; i++) {
				var xmpat:XMPattern = xmPatternFromBoscaBar(i, perInstrumentBoscaNoteToXMNoteMap);
				xm.patterns.push(xmpat);
				xm.patternOrderTable[i] = i;
				xm.numPatterns++;
				xm.songLength++;
			}
			
			for (i = 0; i < control.numinstrument; i++) {
				boscaInstrument = control.instrument[i];
				var xmInstrument:XMInstrument = new XMInstrument();
				var notesUsed:Vector.<int> = notesByEachInstrumentNumber[i];
				xmInstrument.name = boscaInstrument.name;
				xmInstrument.volume = int(boscaInstrument.volume / 4);
				switch (boscaInstrument.type) {
					case 0:
				    xmInstrument.addSample(_boscaInstrumentToXMSample(boscaInstrument, control._driver));
						break;
					default:
						// XXX: bosca ceoil drumkits are converted lossily to a single XM
						// instrument, but they could be converted to several instruments.
				    var drumkitNumber:uint = boscaInstrument.type - 1;
				    xmInstrument.addSamples(_boscaDrumkitToXMSamples(control.drumkit[drumkitNumber], notesUsed, perInstrumentBoscaNoteToXMNoteMap[i], control._driver));
				   	for (var s:uint = 0; s < notesUsed.length; s++) {
							var sionNote:int = notesUsed[s];
							var key:uint = perInstrumentBoscaNoteToXMNoteMap[i][sionNote] - 1; // 0th key is note 1
							xmInstrument.keymapAssignments[key] = s;
						}
						
				    for each (var sample:XMSample in xmInstrument.samples) {
							sample.volume = xmInstrument.volume;
						}
				}
				
				xm.addInstrument(xmInstrument);
			}
		}

		public function writeToStream(stream:IDataOutput):void {
			xm.writeToStream(stream);
		}

		public function _notesUsedByEachInstrumentAcrossEntireSong():Vector.<Vector.<int>> {
			var seenNotePerInstrument:Array = [];
			var i:uint;
			var n:int;

			// start with a clear 2d array
			for (i = 0; i < control.numinstrument; i++) {
				seenNotePerInstrument[i] = [];
			}

			// build a 2d sparse boolean array of notes used
			for (i = 0; i < control.numboxes; i++) {
				var box:musicphraseclass = control.musicbox[i];
				var instrumentNum:int = box.instr;

				for (n = 0; n < box.numnotes; n++) {
					var noteNum:int = box.notes[n].x;
					seenNotePerInstrument[instrumentNum][noteNum] = true;
				}
			}

			// map the sparse boolean array into a list of list of ints
			var notesUsedByEachInstrument:Vector.<Vector.<int>> = new Vector.<Vector.<int>>;
			for (i = 0; i < seenNotePerInstrument.length; i++) {
				var notesUsedByThisInstrument:Vector.<int> = new Vector.<int>;
				for (n = 0; n < seenNotePerInstrument[i].length; n++) {
					if (seenNotePerInstrument[i][n]) {
						notesUsedByThisInstrument.push(n);
					}
				}
				notesUsedByEachInstrument.push(notesUsedByThisInstrument);
			}

			return notesUsedByEachInstrument;
		}

		protected function xmPatternFromBoscaBar(barNum:uint, instrumentNoteMap:Vector.<Vector.<uint>>):XMPattern {
			var numtracks:uint = 8;
			var numrows:uint = control.boxcount;
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
				var whichbox:int = control.arrange.bar[barNum].channel[i];
				if (whichbox < 0) { continue; }
				var box:musicphraseclass = control.musicbox[whichbox];

				var notes:Vector.<Rectangle> = box.notes;
				for (var j:uint = 0; j < box.numnotes; j++) {
					var boscaNote:Rectangle = notes[j];
					var timerelativetostartofbar:uint = boscaNote.width; // yes, it's called width. whatever.
					var notelength:uint = boscaNote.y;
					var xmnote:XMPatternCell = boscaBoxNoteToXMNote(box, j, instrumentNoteMap);

					// find a clear place to write
					var targetTrack:uint = i;
					while (rows[timerelativetostartofbar].cellOnTrack[targetTrack].note > 0) {
						// track is busy (eg drum hits at once, chords)
						targetTrack++;
						if (!(targetTrack < numtracks)) {
							// too much going on, just ignore this note
							continue;
						}
					}

					rows[timerelativetostartofbar].cellOnTrack[targetTrack] = xmnote;
					var endrow:uint = timerelativetostartofbar + notelength;
					if (endrow >= numrows) { continue; }
					if (rows[endrow].cellOnTrack[targetTrack].note > 0) { continue; } // someone else is already starting to play
					rows[endrow].cellOnTrack[targetTrack] = new XMPatternCell({
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

		protected function boscaBoxNoteToXMNote(box:musicphraseclass, notenum:uint, noteMapping:Vector.<Vector.<uint>>):XMPatternCell {
			var sionNoteNum:int = box.notes[notenum].x;
			var xmNoteNum:uint = noteMapping[box.instr][sionNoteNum];
			return new XMPatternCell(
					{
					note: xmNoteNum,
					instrument: box.instr + 1,
					volume: 0,
					effect: 0,
					effectParam: 0
			});
		}

		protected function _boscaNoteToXMNoteMapForInstrument(boscaInstrument:instrumentclass, usefulNotes:Vector.<int>):Vector.<uint> {
			if (boscaInstrument.type > 0) {
				return _boscaDrumkitToXMNoteMap(usefulNotes);
			}

			return _boscaNoteToXMNoteMapLinear();
		}

		protected function _boscaNoteToXMNoteMapLinear():Vector.<uint> {
			var map:Vector.<uint> = new Vector.<uint>;
			for (var scionNote:int = 0; scionNote < 127; scionNote++) {
				var maybeXMNote:int = scionNote + 13;
				var xmNote:uint;
				if (maybeXMNote < 1) { // too low for XM
					map[scionNote] = 0;
					continue;
				}
				if (maybeXMNote > 96) { // too high for XM
					map[scionNote] = 0;
					continue;
				}
				map[scionNote] = uint(maybeXMNote);
			}
			return map;
		}

		protected function _boscaDrumkitToXMNoteMap(necessaryNotes:Vector.<int>):Vector.<uint> {
			var map:Vector.<uint> = new Vector.<uint>;
			var startAt:int = 49; // 1 = low C, 49 = middle C, 96 = highest B
			var scionNote:int;
			var offset:uint;

			// start with a clear map for the unused notes
			for (scionNote = 0; scionNote < 128; scionNote++) {
				map[scionNote] = 0; // not used anyway
			}

			// fill up the used notes in the middle where sampling doesn't change
			// much
			for (offset = 0; offset < necessaryNotes.length; offset++) {
				var necessaryNote:int = necessaryNotes[offset];
				var xmNote:uint = startAt + offset;
				map[necessaryNote] = xmNote;
			}

			return map;
		}

		// bosca drumkits can be much larger than a single XM instrument
		// and an XM instrument can only have one "relative note" setting all
		// samples.
		//
		protected function _boscaDrumkitToXMSamples(drumkit:drumkitclass, whichDrumNumbers:Vector.<int>, noteMapping:Vector.<uint>, driver:SiONDriver):Vector.<XMSample> {
			var samples:Vector.<XMSample> = new Vector.<XMSample>;
			for (var di:uint = 0; di < whichDrumNumbers.length; di++) {
				var d:uint = whichDrumNumbers[di];
				var voice:SiONVoice = drumkit.voicelist[d];
				var samplename:String = drumkit.voicename[d];
				var sionNoteNum:int = drumkit.voicenote[d];
				var xmNoteNum:uint = noteMapping[sionNoteNum];

				var compensationNeeded:int = 0; //49 - xmNoteNum;

				var xmsample:XMSample = new XMSample;
				xmsample.relativeNoteNumber = 0;
				xmsample.name = voice.name;
				xmsample.volume = 0x40;
				xmsample.bitsPerSample = 16;
				xmsample.data = _playSiONNoteTo16BitDeltaSamples(sionNoteNum + compensationNeeded, voice, 32, driver);

				samples.push(xmsample);
			}
			return samples;
		}

		protected function _boscaInstrumentToXMSample(instrument:instrumentclass, driver:SiONDriver):XMSample {
			var voice:SiONVoice = instrument.voice;
			var xmsample:XMSample = new XMSample;
			xmsample.relativeNoteNumber = +3;
			xmsample.name = voice.name;
			xmsample.volume = 0x40;
			xmsample.bitsPerSample = 16;
			
			// consider voice.preferableNote
			var c5:int = 60;
			
			xmsample.data = _playSiONNoteTo16BitDeltaSamples(c5, voice, 16, driver);
			trace(xmsample);
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
			var mml:String = voice.getMML(voice.channelNum) + ' %6,' + voice.channelNum + '@' + voice.toneNum + ' ' + _mmlNoteFromSiONNoteNumber(note); // theoretically, command 'n60' plays note 60
			trace(mml);
			driver.render(mml, renderBuffer, 1);

			// delta encoding algorithm that module formats like XM use
			var previousSample:int = 0;
			for (var i:uint; i < renderBuffer.length; i++) {
				var thisSample:int = renderBuffer[i] * 32767; // signed float to 16-bit signed int
				var sampleDelta:int = thisSample - previousSample;
				deltasamples.writeShort(sampleDelta);
				previousSample = thisSample;
			}
			driver.play();

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

