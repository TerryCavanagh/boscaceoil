package {
	import flash.desktop.InteractiveIcon;
	import flash.display.*;
	import flash.geom.*;
  import flash.events.*;
	import flash.utils.*;
  import flash.net.*;
	import bigroom.input.KeyPoll;
	
	public class guiclass {
		public function guiclass() {}
		
		public static function init():void {
			for (var i:int = 0; i < 250; i++) {
				button.push(new guibutton());
			}
			
			numbuttons = 0;
			maxbuttons = 250;
		}
		
		public static function addbutton(x:int, y:int, w:int, h:int, contents:String, act:String = "", sty:String = "normal"):void {
			var i:int, z:int;
			if(numbuttons == 0) {
				//If there are no active buttons, Z=0;
				z = 0; 
			}else {
				i = 0; z = -1;
				while (i < numbuttons) {
					if (!button[i].active) {
						z = i; i = numbuttons;
					}
					i++;
				}
				if (z == -1) {
					z = numbuttons;
				}
			}
			//trace("addbutton(", x, y, w, h, contents, act, sty, ")", numbuttons);
			button[z].init(x, y, w, h, contents, act, sty);
			numbuttons++;
		}
		
		public static function clear():void {
			for (var i:int = 0; i < numbuttons; i++) {
				button[i].active = false;
			}
			numbuttons = 0;
		}
		
		public static function buttonexists(t:String):Boolean {
			//Return true if there is an active button with action t
			for (var i:int = 0; i < numbuttons; i++) {
				if (button[i].active) {
					if (button[i].action == t) {
						return true;
					}
				}
			}
			
			return false;
		}
		
		public static function checkinput(key:KeyPoll):void {
			for (var i:int = 0; i < numbuttons; i++) {
				if (button[i].active && button[i].visable) {
					if (help.inboxw(control.mx, control.my, button[i].position.x, button[i].position.y, button[i].position.width, button[i].position.height)) {
						button[i].mouseover = true;
					}else {
						button[i].mouseover = false;
					}
					
					if (key.click) {
						if (button[i].mouseover) {
							dobuttonaction(i);
						  //button[i].selected = true;
						}
					}
				}
			}
			
			cleanup();
		}
		
		public static function cleanup():void {
			var i:int = 0;
			i = numbuttons - 1; while (i >= 0 && !button[i].active) { numbuttons--; i--; }
		}
		
		public static function drawbuttons():void {
			for (var i:int = 0; i < numbuttons; i++) {
				if (button[i].active && button[i].visable) {
					if (button[i].style == "normal") {
						gfx.fillrect(button[i].position.x, button[i].position.y, button[i].position.width, button[i].position.height, 12);
						
						if (button[i].mouseover) {
							gfx.fillrect(button[i].position.x - 2, button[i].position.y - 2, button[i].position.width, button[i].position.height, 20);
						}else {
							gfx.fillrect(button[i].position.x - 2, button[i].position.y - 2, button[i].position.width, button[i].position.height, 1);
						}
						
						tx = button[i].position.x + 7;
						ty = button[i].position.y - 1;
						gfx.print(tx, ty, button[i].text, 0, false, true);
					}
				}
			}
		}
		
		public static function deleteall(t:String):void {
			//Deselect any buttons with style t
			for (var i:int = 0; i < numbuttons; i++) {
				if (button[i].active) {
					if (button[i].style == t) {
						button[i].active = false;
					}
				}
			}
		}
		
		public static function selectbutton(t:String):void {
			//select any buttons with action t
			for (var i:int = 0; i < numbuttons; i++) {
				if (button[i].active) {
					if (button[i].action == t) {
						dobuttonaction(i);
						button[i].selected = true;
					}
				}
			}
		}
		
		public static function deselect(t:String):void {
			//Deselect any buttons with action t
			for (var i:int = 0; i < numbuttons; i++) {
				if (button[i].active) {
					if (button[i].action == t) {
						button[i].selected = false;
					}
				}
			}
		}
		
		public static function deselectall(t:String):void {
			//Deselect any buttons with style t
			for (var i:int = 0; i < numbuttons; i++) {
				if (button[i].active) {
					if (button[i].style == t) {
						button[i].selected = false;
					}
				}
			}
		}
		
		public static function findbuttonbyaction(t:String):int {
			for (var i:int = 0; i < numbuttons; i++) {
				if (button[i].active) {
					if (button[i].action == t) {
						return i;
					}
				}
			}
			return 0;
		}
		
		public static function changetab(t:int):void {
			//Delete all buttons when tabs change, and create new ones
			deleteall("normal");
			
		  switch(t) {
				case control.MENUTAB_FILE:
					CONFIG::desktop {
						guiclass.addbutton(220, gfx.linesize * 2, 75, 10, "NEW SONG");
						guiclass.addbutton(305, gfx.linesize * 2, 75, 10, "EXPORT .wav");
					}
				break;
			}
		}
		
		public static function dobuttonaction(i:int):void {
			//fill this in
		}
		
		public static var button:Vector.<guibutton> = new Vector.<guibutton>;
		public static var numbuttons:int;
		public static var maxbuttons:int;
		
		public static var tx:int, ty:int;
	}
}