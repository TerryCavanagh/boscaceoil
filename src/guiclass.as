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
		
		public static function addlogo(x:int, y:int):void {
			addbutton(x, y, 0, 0, "BOSCA CEOIL", "", "logo");
		}
		
		public static function addtextlabel(x:int, y:int, text:String, col:int = 2):void {
			addbutton(x, y, col, 0, text, "", "textlabel");
		}
		
		public static function addbutton(x:int, y:int, w:int, h:int, contents:String, act:String = "", sty:String = "normal", toffset:int = 0):void {
			if (button.length == 0) init();
			
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
			button[z].textoffset = toffset;
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
						
						tx = button[i].position.x + 7 + button[i].textoffset;
						ty = button[i].position.y - 1;
						gfx.print(tx, ty, button[i].text, 0, false, true);
					}else if (button[i].style == "textlabel") {
						gfx.print(button[i].position.x, button[i].position.y, button[i].text, button[i].position.width, false, true);
					}else if (button[i].style == "logo") {
						tx = button[i].position.x;
						ty = button[i].position.y;
						gfx.bigprint(tx, ty, "BOSCA CEOIL", 0, 0, 0, false, 3);
						if (control.looptime % control.barcount==1) {
							gfx.drawimage(0, tx - 2 + (Math.random() * 4), ty - 4 + (Math.random() * 4));
						}else{
							gfx.drawimage(0, tx, ty + 2);
						}
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
					addlogo(12, (gfx.linesize * 2) - 3);
					addtextlabel(165, (gfx.linesize * 4) + 4, control.versionnumber);
					
					addtextlabel(10, (gfx.linesize * 5) + 5, "SiON softsynth library by Kei Mesuda");
					addtextlabel(10, (gfx.linesize * 6) + 5, "XM Exporter by Rob Hunter");
					addtextlabel(10, (gfx.linesize * 7) + 5, "Distributed under FreeBSD licence");
					//addtextlabel(10, (gfx.linesize * 9)+5, "Created by Terry Cavanagh");
					addtextlabel(10, (gfx.linesize * 9)+5, "http://www.distractionware.com");
					
					CONFIG::desktop {
						
						addbutton(220, gfx.linesize * 2, 75, 10, "NEW SONG", "newsong");
						addbutton(305, gfx.linesize * 2, 75, 10, "EXPORT .wav", "exportwav", "normal", -5);
						//addbutton(305, gfx.linesize * 3, 75, 10, "EXPORT .xm", "exportxm");
						addbutton(220, (gfx.linesize * 4) + 5, 75, 10, "LOAD .ceol", "loadceol");
						addbutton(305, (gfx.linesize * 4) + 5, 75, 10, "SAVE .ceol", "saveceol");
					}
				break;
			}
		}
		
		public static function dobuttonaction(i:int):void {
			if (button[i].text == "newsong") {
				control.newsong();
			}else if (button[i].text == "exportwav") {
				control.exportwav();
			}else if (button[i].text == "exportxm") {
				control.exportxm();
			}else if (button[i].text == "loadceol") {
				control.loadceol();
			}else if (button[i].text == "saveceol") {
				control.saveceol();
			}
		}
		
		public static var button:Vector.<guibutton> = new Vector.<guibutton>;
		public static var numbuttons:int;
		public static var maxbuttons:int;
		
		public static var tx:int, ty:int;
	}
}