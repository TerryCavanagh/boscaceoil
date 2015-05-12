package co.sparemind.trackermodule {
	public class XMPatternLine {
		public var cellOnTrack:Vector.<XMPatternCell>;

		public function XMPatternLine(numtracks:int) {
			cellOnTrack = new Vector.<XMPatternCell>(numtracks, true);
			for (var i:uint = 0; i < numtracks; i++) {
				cellOnTrack[i] = new XMPatternCell();
			}
		}
	}
}
