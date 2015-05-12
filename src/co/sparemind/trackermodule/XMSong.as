package co.sparemind.trackermodule {
	/**
	 * A tracker-module song in the "XM" format
	 *
	 * Largely based on the document entitled "The Unofficial XM File Format
	 * Specification: FastTracker II, ADPCM and Stripped Module Subformats"
	 * revision 2 by Mr.H et al. Also explored interactively with XM loading
	 * tools like MikMod, XMP, MilkyTracker, SunVox and even TiMidity++.
	 *
	 * Although this code was originally written for use with Terry Cavanagh's
	 * "Bosca Ceoil", it contains no dependencies on Bosca Ceoil and should work
	 * anywhere you want to export to XM format.
	 *
	 * I should also note that this is the first time I've written ActionScript
	 * code, so it's very likely this code is unusual. Hopefully it's still
	 * useful to you.
	 */
	public class XMSong { import flash.utils.IDataOutput; import
		flash.utils.ByteArray; import flash.utils.Endian;

		/** Theoretically the name of the tool that produced this file.
		 *
		 * In practice some players care about the tracker name so
		 * there are a couple "safe" values.
		 */
		public function XMSong() {
			
		}
		 
		public var trackerName:String = 'FastTracker v2.00   ';
		public var songLength:uint = 0;
		public var restartPos:uint;
		public var numChannels:uint = 8;
		public var numPatterns:uint = 0;
		public var numInstruments:uint;
		public var instruments:Vector.<XMInstrument> = new Vector.<XMInstrument>;

		/**
		 * How many "ticks" per second. Normally about 5 or 6.
		 *
		 * The song itself can change speed through control events.
		 */
		public var defaultTempo:uint;

		/**
		 * Speed of song in beats per minute (BPM)
		 *
		 * The song itself can change speed through control events.
		 */
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

		/**
		 * Which frequencies table calculation to use
		 *
		 * 0 = Amiga frequency table
		 * 1 = Linear frequency table
		 */
		public var flags:uint = 0x0001; // frequency table

		// physical considerations, only relevant for writing
		private var headerSize:uint = 20 + 256;
		private var idText:String = 'Extended Module: ';
		private var sep:uint = 26; // DOS EOF
		private var version:uint = 0x0104;

		public var patterns:Vector.<XMPattern> = new Vector.<XMPattern>;

		protected var _name:ByteArray = new ByteArray();

		public function get songname():String {
			return _name.toString();
		}

		public function set songname(unpadded:String):void {
			_name.clear();
			_name.writeMultiByte(unpadded.slice(0,20), 'us-ascii');
			for (var i:uint = _name.length; i < 20; i++) {
				_name.writeByte(0x20); // space-padded
			}
		}

		public function writeToStream(stream:IDataOutput):void {
			var xm:XMSong = this;
			var headbuf:ByteArray = new ByteArray;
			headbuf.endian = Endian.LITTLE_ENDIAN;

			headbuf.writeMultiByte(xm.idText, 'us-ascii'); // physical
			headbuf.writeMultiByte(xm.songname, 'us-ascii');
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
				instrheadbuf.writeByte(0); // type (always 0)
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
					instrheadbuf.writeShort(0x0000);
					instrheadbuf.writeShort(0x0000);
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
						(sample.bitsPerSample == 16 ? 16 : 0);
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
}

