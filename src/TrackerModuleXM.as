package {
	import flash.utils.IDataOutput;
	import flash.geom.Rectangle;

	public class TrackerModuleXM {
		public var xm:XMSong;

		public function loadFromLiveBoscaCeoilModel(bosca:controlclass, desiredSongName:String):void {
		  xm = new XMSong;

		  //TODO: move to .name property of XMSong
		  xm.songname.writeMultiByte(desiredSongName.slice(0,20), 'us-ascii');
		  while(xm.songname.length < 20) {
		  	xm.songname.writeByte(0x20); // space-padded
			}

			xm.defaultBPM = bosca.bpm;
			xm.defaultTempo = int(bosca.bpm / 20);
			xm.numChannels = 8;
			xm.numInstruments = bosca.numinstrument;
			for (var i:uint = 0; i < bosca.arrange.lastbar; i++) {
				var xmpat:XMPattern = xmPatternFromBoscaBar(bosca, i);
				xm.patterns.push(xmpat);
				xm.patternOrderTable[i] = i;
				xm.numPatterns++;
				xm.songLength++;
			}
			xm.flags = 0x0100; // TODO: move default to XMSong

			for (i = 0; i < bosca.numinstrument; i++) {
				var boscaInstrument:instrumentclass = bosca.instrument[i];
				var xmInstrument:XMInstrument = new XMInstrument();
				xmInstrument.name = boscaInstrument.name;
				xmInstrument.volume = int(boscaInstrument.volume / 4);
				xmInstrument.addSample(new XMSampleFake());
				xm.addInstrument(xmInstrument);
			}
		}

		public function writeToStream(stream:IDataOutput):void {
			trace('deprecated, use XMSong.writeToStream() instead');
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

class XMSong {
	import flash.utils.IDataOutput;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.geom.Rectangle;

	public var songname:ByteArray = new ByteArray();
	public var trackerName:String = 'FastTracker v2.00   ';
	public var songLength:uint = 0;
	public var restartPos:uint;
	public var numChannels:uint = 8; // bosca has a hard-coded limit
	public var numPatterns:uint = 0;
	public var numInstruments:uint;
	public var instruments:Vector.<XMInstrument> = new Vector.<XMInstrument>;
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
	private var version:uint = 0x0104;

	public var patterns:Vector.<XMPattern> = new Vector.<XMPattern>;

	public function writeToStream(stream:IDataOutput):void {
		var xm:XMSong = this;
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

		for (var instno:uint = 0; instno < xm.instruments.length; instno++) {
			var inst:XMInstrument = xm.instruments[instno];
			var instrheadbuf:ByteArray = new ByteArray();
			instrheadbuf.endian = Endian.LITTLE_ENDIAN;
			var headerSize:uint = (inst.samples.length < 1) ? 29 : 263;
			instrheadbuf.writeUnsignedInt(headerSize);
			instrheadbuf.writeMultiByte(inst.name, 'us-ascii');
			instrheadbuf.writeByte(0); // type
			instrheadbuf.writeShort(inst.samples.length);
			if (inst.samples.length < 1) {
				stream.writeBytes(instrheadbuf);
			}
			instrheadbuf.writeUnsignedInt(40); // sampleHeaderSize
			for (var kma:uint = 0; kma < inst.keymapAssignments.length; kma++) {
				instrheadbuf.writeByte(inst.keymapAssignments[kma]);
			}
			for (var p:uint = 0; p < 12; p++) {
				// var point:XMEnvelopePoint = inst.volumeEnvelope.points[p];
				// instrheadbuf.writeShort(point.x);
				// instrheadbuf.writeShort(point.y);
				instrheadbuf.writeShort(0x1111);
				instrheadbuf.writeShort(0x2222);
			}
			for (p = 0; p < 12; p++) {
				// var point:XMEnvelopePoint = inst.panningEnvelope.points[p];
				// instrheadbuf.writeShort(point.x);
				// instrheadbuf.writeShort(point.y);
				instrheadbuf.writeShort(0xdeed);
				instrheadbuf.writeShort(0xfeef);
			}
			instrheadbuf.writeByte(0); // numVolumePoints
			instrheadbuf.writeByte(0); // numVolumePoints
			instrheadbuf.writeByte(0); // volSustainPoint
			instrheadbuf.writeByte(0); // volLoopStartPoint
			instrheadbuf.writeByte(0); // volLoopEndPoint
			instrheadbuf.writeByte(0); // panSustainPoint
			instrheadbuf.writeByte(0); // panLoopStartPoint
			instrheadbuf.writeByte(0); // panLoopEndPoint
			instrheadbuf.writeByte(0); // volumeType
			instrheadbuf.writeByte(0); // panningType
			instrheadbuf.writeByte(0); // vibratoType
			instrheadbuf.writeByte(0); // vibratoSweep
			instrheadbuf.writeByte(0); // vibratoDepth
			instrheadbuf.writeByte(0); // vibratoRate
			instrheadbuf.writeShort(0); // volumeFadeout);
			// the 22 bytes at offset +241 are reserved
			for (i = 0; i < 22; i++) {
				instrheadbuf.writeByte(0x00);
			}
			stream.writeBytes(instrheadbuf);
			for (var s:uint = 0; s < inst.samples.length; s++) {
				var sample:XMSample = inst.samples[s];
				var sampleHeadBuf:ByteArray = new ByteArray();
				sampleHeadBuf.endian = Endian.LITTLE_ENDIAN;
				sampleHeadBuf.writeUnsignedInt(sample.data.length);
				sampleHeadBuf.writeUnsignedInt(sample.loopStart);
				sampleHeadBuf.writeUnsignedInt(sample.loopLength);
				sampleHeadBuf.writeByte(sample.volume);
				sampleHeadBuf.writeByte(sample.finetune);
				var sampleType:uint = (sample.loopsForward ? 1 : 0) |
					(sample.bitsPerSample == 16 ? 2 : 0);
				sampleHeadBuf.writeByte(sampleType);
				sampleHeadBuf.writeByte(sample.panning);
				sampleHeadBuf.writeByte(sample.relativeNoteNumber);
				sampleHeadBuf.writeByte(0); // regular 'delta' sample encoding
				sampleHeadBuf.writeMultiByte(sample.name, 'us-ascii');
				stream.writeBytes(sampleHeadBuf);
			}
			for (s = 0; s < inst.samples.length; s++) {
				sample = inst.samples[s];
				stream.writeBytes(sample.data);
			}
		}
	}

	public function addInstrument(instrument:XMInstrument):void {
		instruments.push(instrument);
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
			 );
	}
}

class XMInstrument {
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	protected var _name:ByteArray;
	public var volume:uint = 40;
	public var samples:Vector.<XMSample> = new Vector.<XMSample>();
	public var keymapAssignments:Vector.<uint> = Vector.<uint>([
    0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0
  ]);

	public function XMInstrument() {
		_name = new ByteArray();
		_name.endian = Endian.LITTLE_ENDIAN;
		this.name  = '                      ';
	}

  public function addSample(sample:XMSample):void {
  	samples.push(sample);
	}
	public function get name():String {
		return _name.toString();
	}
	public function set name(unpadded:String):void {
		_name.clear();
		_name.writeMultiByte(unpadded.slice(0,22), 'us-ascii');
		for (var i:uint = _name.length; i < 22; i++) {
			_name.writeByte(0x20); // space-padded
		}
	}
}

class XMSample {
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public var volume:uint;
	public var finuetune:uint = 0;
	// type bitfield: looping, 8-bit/16-bit
	public var panning:uint = 0x80;
	public var relativeNoteNumber:int = 0;
	protected var _name:ByteArray;
	public var data:ByteArray;
	public var bitsPerSample:uint = 8;
	public var finetune:uint = 0;
	public var loopStart:uint = 0;
	public var loopLength:uint = 0;
	public var loopsForward:Boolean = false;

	public function XMSample() {
		_name = new ByteArray();
		_name.endian = Endian.LITTLE_ENDIAN;
		this.name  = '                      ';
	}
	public function get name():String {
		return _name.toString();
	}
	public function set name(unpadded:String):void {
		_name.clear();
		_name.writeMultiByte(unpadded.slice(0,22), 'us-ascii');
		for (var i:uint = _name.length; i < 22; i++) {
			_name.writeByte(0x20); // space-padded
		}
	}
}

class XMSampleFake extends XMSample {
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	public function XMSampleFake() {
		this.bitsPerSample = 8;
		this.name = 'fake sample           ';
		this.data = new ByteArray();
		var sinewave:Array = [
			0x0a,0x64,0x08,0x9c,0x06,0x05,0x04,0x03,0x64,0x00,0x00,
			0x00,0x9c,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,
			0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,
			0xd8,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,
			0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,
			0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe
		];
		this.data.endian = Endian.LITTLE_ENDIAN;
		for (var i:uint = 0; i < sinewave.length; i++) {
			this.data.writeByte(sinewave[i]);
		}
		loopLength = sinewave.length;
		loopsForward = true;
		volume = 40;
	}
}
