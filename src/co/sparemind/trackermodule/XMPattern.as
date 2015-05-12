package co.sparemind.trackermodule {
	public class XMPattern {
		public var rows:Vector.<XMPatternLine>;
		public function XMPattern(numrows:int) {
			rows = new Vector.<XMPatternLine>(numrows, true);
		}
	}

}

