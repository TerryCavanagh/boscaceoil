package {
	import flash.display.*;
	import flash.geom.*;
  import flash.events.*;
  import flash.net.*;
	
	public class listclass  {
		public function listclass():void {
			for (var i:int = 0; i < 30; i++) {
				item.push("");
			}
			clear();
		}
		
		public function clear():void {
			numitems = 0;
			active = false;
			x = 0; y = 0;
			selection = -1;
		}
		
		public function init(xp:int, yp:int):void {
			x = xp; y = yp; active = true;
			getwidth();
			h = numitems * gfx.linesize;
		}
		
		public function close():void {
			active = false;
		}
		
		public function getwidth():void {
			w = 0;
			var temp:int;
			for (var i:int = 0; i < numitems; i++) {
				temp = gfx.len(item[i]);
				if (w < temp) w = temp;
			}
			w += 10;
		}
		
		public var item:Vector.<String> = new Vector.<String>;
		public var numitems:int;
		public var active:Boolean;
		public var x:int, y:int, w:int, h:int;
		public var type:int;
		public var selection:int;
	}
}
