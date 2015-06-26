package {
	import flash.display.*;
	import flash.geom.*;
  import flash.events.*;
  import flash.net.*;
	
	public class help {
		public static function init():void {
		  glow = 0;
			glowdir = 0;
			slowsine = 0;
		}
		
		public function RGB(red:Number,green:Number,blue:Number):Number{
			return (blue | (green << 8) | (red << 16))
		}
		
		public static function removeObject(obj:Object, arr:Array):void{
			var i:String;
			for (i in arr){
				if (arr[i] == obj){
					arr.splice(i,1)
					break;
				}
			}
		}
		
		public static function updateglow():void {
			slowsine+=2;
			if (slowsine >= 64) slowsine = 0;
			
		  if (glowdir == 0) {
			  glow+=2; 
				if (glow >= 63) glowdir = 1;
			}else {
			  glow-=2;
				if (glow < 1) glowdir = 0;
			}
		}
		
		public static function inbox(xc:int, yc:int, x1:int, y1:int, x2:int, y2:int):Boolean {
			if (xc >= x1 && xc <= x2) {
				if (yc >= y1 && yc <= y2) {
					return true;
				}
			}
			return false;
		}
		
		public static function inboxw(xc:int, yc:int, x1:int, y1:int, x2:int, y2:int):Boolean {
			if (xc >= x1 && xc <= x1+x2) {
				if (yc >= y1 && yc <= y1+y2) {
					return true;
				}
			}
			return false;
		}
		
		public static function Instr(s:String,c:String,start:int=1):int{
  		return (s.indexOf(c,start-1)+1);
		}
		
		public static function Mid(s:String,start:int=0,length:int=1):String{
		  return s.substr(start,length);
		}
		
		public static function Left(s:String,length:int=1):String{
		  return s.substr(0,length);
		}
		
		public static function Right(s:String,length:int=1):String{
		  return s.substr(s.length-length,length);
		} 
		
		public static var glow:int, slowsine:int;
		public static var glowdir:int;
	}
}
