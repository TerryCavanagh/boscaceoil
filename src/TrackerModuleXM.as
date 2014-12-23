package {
	import flash.utils.IDataOutput;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

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
		private var headerSize:uint;
		private var idText:String = 'Extended Module: ';
		private var sep:uint = 26; // DOS EOF
		private var version:uint = 0x0401;
		


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
				// var xmpat:XMPattern = xmPatternFromBoscaBar(bosca, i);
				// xm.patterns.push(xmpat);
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
		}
	}
}
