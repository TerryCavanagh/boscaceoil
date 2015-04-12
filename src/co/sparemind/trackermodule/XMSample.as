package co.sparemind.trackermodule {
	public class XMSample {
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
}

