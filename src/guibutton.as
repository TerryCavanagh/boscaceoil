package {
	import flash.geom.*;
 
	public class guibutton {
		public function guibutton() {
			position = new Rectangle(0, 0, 0, 0);
			selected = false;
			active = false;
			visable = false;
			mouseover = false;
		}
		
		public function init(x:int, y:int, w:int, h:int, contents:String, act:String = "", sty:String = "normal"):void {
			position.setTo(x, y, w, h);
			text = contents;
		  action = act;
			style = sty;
			
			selected = false;
			moveable = false;
			visable = true;
			active = true;
			onwindow = false;
			textoffset = 0;
			pressed = 0;
		}
		
		public function press():void {
			pressed = 6;
		}
		
		public var position:Rectangle;
		public var text:String;
		public var action:String;
		public var style:String;
		
		public var visable:Boolean;
		public var mouseover:Boolean;
		public var selected:Boolean;
		public var active:Boolean;
		public var moveable:Boolean;
		public var onwindow:Boolean;
		
		public var pressed:int;
		public var textoffset:int;
	}
}