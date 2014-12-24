package co.sparemind.trackermodule {
	public class XMPatternCell {
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
}

