package co.sparemind.trackermodule {
	public class XMInstrument {
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

}

