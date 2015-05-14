package {
	import flash.desktop.InteractiveIcon;
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
			if (act == "") {
				action = contents;
			}else{
				action = act;
			}
			style = sty;
			
			selected = false;
			visable = true;
			active = true;
			textoffset = 0;
		}
		
		public var position:Rectangle;
		public var text:String;
		public var action:String;
		public var style:String;
		
		public var visable:Boolean;
		public var mouseover:Boolean;
		public var selected:Boolean;
		public var active:Boolean;
		
		public var textoffset:int;
	}
}