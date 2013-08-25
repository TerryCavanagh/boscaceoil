package {
	import flash.display.*;
	import flash.geom.*;
  import flash.events.*;
  import flash.net.*;
	
	public class arrangementclass  {
		public function arrangementclass():void {
			for (var i:int = 0; i < 1000; i++) {
				bar.push(new barclass);
			}
			for (i = 0; i < 100; i++) {
				copybuffer.push(new barclass);
			}
			copybuffersize = 0;
			
			for (i = 0; i < 8; i++) {
				channelon.push(true);
			}
			clear();
		}
		
		public function copy():void {
			for (var i:int = loopstart; i < loopend; i++) {
				for (var j:int = 0; j < 8; j++) {
					copybuffer[i-loopstart].channel[j] = bar[i].channel[j];
				}
			}
			copybuffersize = loopend-loopstart;
		}
		
		public function paste(t:int):void {
			for (var i:int = 0; i < copybuffersize; i++) {
				insertbar(t);
			}
			
			for (i = t; i < t + copybuffersize; i++) {
				for (var j:int = 0; j < 8; j++) {
					bar[i].channel[j] = copybuffer[i - t].channel[j];
				}
			}
		}
		
		public function clear():void {
			loopstart = 0;
			loopend = 1;
			currentbar = 0;
			
			for (var i:int = 0; i < lastbar; i++) {
				for (var j:int = 0; j < 8; j++) {
					bar[i].channel[j] = -1;
				}
			}
			
			lastbar = 1;
		}
		
		public function addpattern(a:int, b:int, t:int):void {
			bar[a].channel[b] = t;
			if (a + 1 > lastbar) lastbar = a + 1;
		}
		
		public function removepattern(a:int, b:int):void {
			bar[a].channel[b] = -1;
			var lbcheck:int = 0;
			for (var i:int = 0; i <= lastbar; i++) {
				for (var j:int = 0; j < 8; j++) {
					if (bar[i].channel[j] > -1) {
						lbcheck = i;
					}
				}
			}
			lastbar = lbcheck + 1;
		}
		
		public function insertbar(t:int):void {
			for (var i:int = lastbar+1; i > t; i--) {
				for (var j:int = 0; j < 8; j++) {
					bar[i].channel[j] = bar[i - 1].channel[j];
				}
			}
			for (j = 0; j < 8; j++) {
				bar[t].channel[j] = -1;
			}
			lastbar++;
		}
		
		public function deletebar(t:int):void {
			for (var i:int = t; i < lastbar+1; i++) {
				for (var j:int = 0; j < 8; j++) {
					bar[i].channel[j] = bar[i + 1].channel[j];
				}
			}
			lastbar--;
		}
		
		public var copybuffer:Vector.<barclass> = new Vector.<barclass>;
		public var copybuffersize:int;
		
		public var bar:Vector.<barclass> = new Vector.<barclass>;
		public var channelon:Vector.<Boolean> = new Vector.<Boolean>;
		public var loopstart:int, loopend:int;
		public var currentbar:int;
		
		public var lastbar:int;
		
		public var viewstart:int;
	}
}
