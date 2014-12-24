package {
	import flash.utils.IDataOutput;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.geom.Rectangle;

	public class TrackerModuleXM {
		public var songname:ByteArray = new ByteArray();
		public var trackerName:String = 'FastTracker II      ';
		public var songLength:uint;
		public var restartPos:uint;
		public var numChannels:uint = 8; // bosca has a hard-coded limit
		public var numPatterns:uint;
		public var numInstruments:uint;
		public var defaultTempo:uint;
		public var defaultBPM:uint;
		public var patternOrderTable:Array = [
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		];

		public var flags:uint;

		// physical considerations, only relevant for writing
		private var headerSize:uint = 20 + 256;
		private var idText:String = 'Extended Module: ';
		private var sep:uint = 26; // DOS EOF
		private var version:uint = 0x0401;
		
		public var patterns:Vector.<XMPattern> = new Vector.<XMPattern>;


		public function loadFromLiveBoscaCeoilModel(bosca:controlclass, desiredSongName:String):void {
		  var xm:TrackerModuleXM = this;
		  xm.songname.writeMultiByte(desiredSongName.slice(0,20), 'us-ascii');
		  while(xm.songname.length < 20) {
		  	xm.songname.writeByte(0x20); // space-padded
			}

			xm.defaultBPM = bosca.bpm;
			xm.defaultTempo = int(bosca.bpm / 20);
			xm.numChannels = 8;
			xm.numInstruments = bosca.instrument.length;
			for (var i:uint = 0; i < bosca.arrange.lastbar; i++) {
				var xmpat:XMPattern = xmPatternFromBoscaBar(bosca, i);
				xm.patterns.push(xmpat);
				xm.patternOrderTable[i] = i;
				xm.numPatterns++;
				xm.songLength++;
			}
			xm.flags = 0x0100;
			
		}
		public function writeToStream(stream:IDataOutput):void {
			var xm:TrackerModuleXM = this;
			var headbuf:ByteArray = new ByteArray;
			headbuf.endian = Endian.LITTLE_ENDIAN;
			
			headbuf.writeMultiByte(xm.idText, 'us-ascii'); // physical
			headbuf.writeBytes(xm.songname);
			headbuf.writeByte(xm.sep); // physical
			headbuf.writeMultiByte(xm.trackerName, 'us-ascii');
			headbuf.writeShort(xm.version); // physical? probably
			headbuf.writeUnsignedInt(xm.headerSize); // physical
			headbuf.writeShort(xm.songLength);
			headbuf.writeShort(xm.restartPos);
			headbuf.writeShort(xm.numChannels);
			headbuf.writeShort(xm.numPatterns);
			headbuf.writeShort(xm.numInstruments);
			headbuf.writeShort(xm.flags); // physical?
			headbuf.writeShort(xm.defaultTempo);
			headbuf.writeShort(xm.defaultBPM);
			for (var i:int = 0; i < xm.patternOrderTable.length; i++) {
				headbuf.writeByte(xm.patternOrderTable[i]);
			}

			
			stream.writeBytes(headbuf);
			for (i = 0; i < xm.patterns.length; i++) {
				var pattern:XMPattern = xm.patterns[i];
				var patbuf:ByteArray = new ByteArray();
				patbuf.endian = Endian.LITTLE_ENDIAN;
				var patternHeaderLength:uint = 9; // TODO: calculate
				patbuf.writeUnsignedInt(patternHeaderLength);
				patbuf.writeByte(0); // packingType
				patbuf.writeShort(pattern.rows.length);
				
				var patBodyBuf:ByteArray = new ByteArray();
				patBodyBuf.endian = Endian.LITTLE_ENDIAN;
				for (var rownum:uint = 0; rownum < pattern.rows.length; rownum++) {
					var line:XMPatternLine = pattern.rows[rownum];
					for (var chan:uint = 0; chan < line.cellOnTrack.length; chan++) {
						var cell:XMPatternCell = line.cellOnTrack[chan];
						if (cell.isEmpty()) {
							patBodyBuf.writeByte(0x80);
							continue;
						}
						patBodyBuf.writeByte(cell.note);
						patBodyBuf.writeByte(cell.instrument);
						patBodyBuf.writeByte(cell.volume);
						patBodyBuf.writeByte(cell.effect);
						patBodyBuf.writeByte(cell.effectParam);
					}
				}

				patbuf.writeShort(patBodyBuf.length); // packedDataSize
				stream.writeBytes(patbuf);
				stream.writeBytes(patBodyBuf);
			}
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
				for (var j:uint = 0; j < notes.length; j++) {
					var boscaNote:Rectangle = notes[j];
					var timerelativetostartofbar:uint = boscaNote.width; // yes, it's called width. whatever.
					var notelength:uint = boscaNote.y;
					var xmnote:XMPatternCell = boscaBoxNoteToXMNote(box, j);
					// rows[timerelativetostartofbar][i] = xmnote;
					var endrow:uint = timerelativetostartofbar + notelength;
					if (endrow >= numrows) { continue; }
					if (rows[endrow].cellOnTrack[i].note > 0) { continue; } // someone else is already starting to play
					rows[endrow].cellOnTrack[i] = new XMPatternCell({
						note: 97,
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
					note: box.notes[notenum].x,
					instrument: box.instr + 1,
					volume: 0,
					effect: 0,
					effectParam: 0
			});
		}
 
	}
}

class XMPattern {
	public var rows:Vector.<XMPatternLine>;
	public function XMPattern(numrows) {
		rows = new Vector.<XMPatternLine>(numrows, true);
	}
}

class XMPatternLine {
	public var cellOnTrack:Vector.<XMPatternCell>;

	public function XMPatternLine(numtracks) {
		cellOnTrack = new Vector.<XMPatternCell>(numtracks, true);
		for (var i:uint = 0; i < numtracks; i++) {
			cellOnTrack[i] = new XMPatternCell();
		}
	}
}
class XMPatternCell {
	public var note:uint = 0;
	public var instrument:uint = 0;
	public var volume:uint = 0;
	public var effect:uint = 0;
	public var effectParam:uint = 0;
	public function XMPatternCell(config:Object = null) {
		if (config === null) { return; }

		note = config.note;
		instrument = config.instrument;
		volume = config.volume;
		effect = config.effect;
		effectParam = config.effectParam;
	}
	public function isEmpty():Boolean {
		return (note === 0 &&
				instrument === 0 &&
				volume === 0 &&
				effect === 0 &&
				effectParam === 0
			 )
	}
}
