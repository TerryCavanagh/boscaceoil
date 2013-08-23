package {
	import flash.display.*;
	import flash.geom.*;
  import flash.events.*;
  import flash.net.*;
	
	public class paletteclass  {
		public function paletteclass():void {
			r = 0; g = 0; b = 0;
		}
		
		public function setto(r1:int, g1:int, b1:int):void {
			r = r1; g = g1; b = b1;
			fixbounds();
		}
		
		public function transition(r1:int, g1:int, b1:int, speed:int=5):void {
			if (r < r1) {	r += speed;	if (r > r1) r = r1;	}
			if (g < g1) {	g += speed;	if (g > g1) g = g1;	}
			if (b < b1) {	b += speed;	if (b > b1) b = b1;	}
			
			if (r > r1) {	r -= speed;	if (r < r1) r = r1;	}
			if (g > g1) {	g -= speed;	if (g < g1) g = g1;	}
			if (b > b1) {	b -= speed;	if (b < b1) b = b1;	}
			
			fixbounds();
		}
		
		public function fixbounds():void {
			if (r <= 0) r = 0;    if (g <= 0) g = 0;    if (b <= 0) b = 0; 
			if (r > 255) r = 255;	if (g > 255) g = 255;	if (b > 255) b = 255;
		}
		
		public var r:int, g:int, b:int;
	}
}
