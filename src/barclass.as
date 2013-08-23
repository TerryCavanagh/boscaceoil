package {
	import flash.display.*;
	import flash.geom.*;
  import flash.events.*;
  import flash.net.*;
	
	public class barclass  {
		public function barclass():void {
			for (var i:int = 0; i < 8; i++) {
				channel.push( -1);
			}
			clear();
		}
		
		public function clear():void {
			for (var i:int = 0; i < 8; i++) {
				channel[i] = -1;
			}
		}
		
		public var channel:Vector.<int> = new Vector.<int>;
	}
}
