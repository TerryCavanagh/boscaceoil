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
			
			helpwindow = "nothing";
		}
		
		public static function changewindow(winname:String, initalise:Boolean = true):void {
			helpwindow = winname;
			if (winname == "nothing") return;
			windowxoffset = 0; windowyoffset = 0;
			
			switch(winname) {
				case "firstrun":
					if (initalise) {
						windowwidth = 700; windowheight = (gfx.linesize * 6) + 35;
						windowx = gfx.screenwidthmid - (windowwidth / 2); windowy = gfx.screenheightmid - (windowheight / 2);
						windowtext = "Welcome!";
					}
					
					addblackout();
					addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);
					
					addcentertextlabel(windowx, windowy + 30, windowwidth, "Looks like this is your first time using Bosca Ceoil!", 0, true);
					addcentertextlabel(windowx, windowy + 30 + gfx.linesize, windowwidth, "Would you like a quick introduction?", 0, true);
					
					addbutton(windowx + (windowwidth / 3) - 75, windowy + 30 + (gfx.linesize * 3), 150, "YES", "help1", 0, true);
					addbutton(windowx + (2*windowwidth/3) - 75, windowy + 30 + (gfx.linesize *3), 150, "NO", "closewindow", 0, true);
					
					addcentertextlabel(windowx, windowy + 30 + (gfx.linesize * 5), windowwidth, "(You can access this tour later by clicking HELP.)", 2, true);
				break;
				case "help1":
					if (initalise) {
						windowwidth = 400; windowheight = (gfx.linesize * 5) + (gfx.linesize * 2) + 35;
						windowx = gfx.screenwidth - windowwidth - 25;	windowy = 47;
						
						windowtext = "HELP - Placing Notes";
					}
					
					addhighlight(40, gfx.pianorollposition + gfx.linesize, gfx.screenwidth - 40, gfx.screenheight - gfx.pianorollposition - gfx.linesize - gfx.linesize, 18, "");
					
					addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);
					windowline = 0;
					addline("Let's start putting down some");
					addline("notes right away!");
					addline("");
					addline("LEFT CLICK anywhere in the pattern", "LEFT CLICK");
					addline("editor below to place a note.");
					
					addbutton(windowx + windowwidth - 150 - 15, windowy + windowheight - gfx.linesize - 15, 150, "NEXT", "help2", 0, true);
				break;
				case "help2":
					if (initalise) {
						windowwidth = 400; windowheight =  (gfx.linesize * 2) + (gfx.linesize * 2) + 35;
						windowx = gfx.screenwidth - windowwidth - 30;	windowy = 97;
						
						windowtext = "HELP - Placing Notes";
					}
					
					addhighlight(40, gfx.pianorollposition + gfx.linesize, gfx.screenwidth - 40, gfx.screenheight - gfx.pianorollposition - gfx.linesize - gfx.linesize, 18, "");
					highlightflash = 0;
					
					addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);
					windowline = 0;
					addline("You can delete notes with");
					addline("RIGHT CLICK, or " +control.ctrl+" + LEFT CLICK.", "RIGHT CLICK");
					
					addbutton(windowx + windowwidth - 150 - 15, windowy + windowheight - gfx.linesize - 15, 150, "NEXT", "help3", 0, true);
					addbutton(windowx + 15, windowy + windowheight - gfx.linesize - 15, 150, "PREVIOUS", "help1", 0, true);
				break;
				case "help3":
					if (initalise) {
						windowwidth = 360; windowheight =  (gfx.linesize * 3) + (gfx.linesize * 2) + 35;
						windowx = gfx.screenwidth - windowwidth - 52;	windowy = 72;
						
						windowtext = "HELP - Placing Notes";
					}
					
					//Scroll bar
					if (control.doublesize) {
						addhighlight((42 + (32 * control.boxsize)), gfx.pianorollposition + gfx.linesize, gfx.screenwidth - (42 + (32 * control.boxsize)), gfx.screenheight - gfx.pianorollposition - gfx.linesize - gfx.linesize, 18, "");
					}else {
						addhighlight((42 + (16 * control.boxsize)), gfx.pianorollposition + gfx.linesize, gfx.screenwidth - (42 + (16 * control.boxsize)), gfx.screenheight - gfx.pianorollposition - gfx.linesize - gfx.linesize, 18, "");
					}
					
					addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);
					windowline = 0;
					addline("You can reach higher and lower");
					addline("notes with the scrollbar, or by", "scrollbar");
					addline("pressing the UP and DOWN keys.", "UP and DOWN");
					
					addbutton(windowx + windowwidth - 150 - 15, windowy + windowheight - gfx.linesize - 15, 150, "NEXT", "help4", 0, true);
					addbutton(windowx + 15, windowy + windowheight - gfx.linesize - 15, 150, "PREVIOUS", "help2", 0, true);
				break;
				case "help4":
					if (initalise) {
						windowwidth = 700; windowheight =  (gfx.linesize * 5) + (gfx.linesize * 2) + 35;
						windowx = gfx.screenwidth - windowwidth - 37;	windowy = 11;
						
						windowtext = "HELP - Placing Notes";
					}
					
					//Scroll bar
					if (control.doublesize) {
						addhighlight((42 + (32 * control.boxsize)), gfx.pianorollposition + gfx.linesize, gfx.screenwidth - (42 + (32 * control.boxsize)), gfx.screenheight - gfx.pianorollposition - gfx.linesize - gfx.linesize, 18, "");
					}else {
						addhighlight((42 + (16 * control.boxsize)), gfx.pianorollposition + gfx.linesize, gfx.screenwidth - (42 + (16 * control.boxsize)), gfx.screenheight - gfx.pianorollposition - gfx.linesize - gfx.linesize, 18, "");
					}
					
					addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);
					
					windowxoffset = gfx.images[8 + 0].width + 5;
					windowyoffset = 0;
					addtutorialimage(windowx + 5, windowy + 30, 0, true);
					
					windowline = 0;
					addline("Use the MOUSEWHEEL to change", "MOUSEWHEEL");
					addline("the length of the note.");
					addline("");
					addline("(Or press SHIFT + ARROW keys.)", "SHIFT + ARROW");
					
					addbutton(windowx + windowwidth - 150 - 15, windowy + windowheight - gfx.linesize - 15, 150, "NEXT", "help5", 0, true);
					addbutton(windowx + 15 + windowxoffset, windowy + windowheight - gfx.linesize - 15, 150, "PREVIOUS", "help3", 0, true);
				break;
				case "advancedhelp1":
					if (initalise) {
						windowx = 50;	windowy = 50;
						windowwidth = 300; windowheight = 200;
						windowtext = "HELP - Placing Notes";
					}
					
					addhighlight(40, gfx.pianorollposition + gfx.linesize, gfx.screenwidth - 40, gfx.screenheight - gfx.pianorollposition - gfx.linesize - gfx.linesize, 18, "");
					
					addwindow(windowx, windowy, windowwidth, windowheight, helpwindow);
					
					addtextlabel(windowx + 5, windowy + 25, "testing", 2, true);
					addbutton(windowx + 5, windowy + 50, 150, "Credits", "creditstab", 0, true);
				break;
				default:
				  helpwindow = "nothing";
				break;
			}
		}
		
		public static function addline(line:String, high:String = ""):void {
			if(line != ""){
				addtextlabel(windowx + 10 + windowxoffset, windowy + 30 + windowyoffset + (gfx.linesize * windowline), line, 0, true);
				if (high != "") {
					tx = line.search(high);
					tx = gfx.len(help.Left(line, tx));
					addtextlabel(windowx + 10 + tx + windowxoffset, windowy + 30 + windowyoffset + (gfx.linesize * windowline), high, 18, true);
				}
			}
			windowline++;
		}
		
		public static function addwindow(x:int, y:int, w:int, h:int, text:String):void {
			if(helpwindow != "nothing"){
				addguipart(x, y, w, h, windowtext, "window", "window");
			}
		}
		
		public static function addtutorialimage(x:int, y:int, img:int, towindow:Boolean = false):void {
			addguipart(x, y, 0, 0, "", "", "tutorialimage", img);
			if (towindow) button[lastbutton].onwindow = true;
		}
		
		public static function addbutton(x:int, y:int, w:int, text:String, action:String, textoffset:int = 0, towindow:Boolean = false):void {
			addguipart(x, y, w, gfx.buttonheight, text, action, "normal", textoffset);
			if (towindow) button[lastbutton].onwindow = true;
		}
		
		public static function addlogo(x:int, y:int, towindow:Boolean = false):void {
			addguipart(x, y, 356, 44, "BOSCA CEOIL", "logo", "logo");
			if (towindow) button[lastbutton].onwindow = true;
		}
		
		public static function addtextlabel(x:int, y:int, text:String, col:int = 2, towindow:Boolean = false):void {
			addguipart(x, y, col, 0, text, "", "textlabel");
			if (towindow) button[lastbutton].onwindow = true;
		}
		
		public static function addcentertextlabel(x:int, y:int, w:int, text:String, col:int = 2, towindow:Boolean = false):void {
			addguipart(x + ((w / 2) - (gfx.len(text) / 2)), y, col, 0, text, "", "textlabel");
			if (towindow) button[lastbutton].onwindow = true;
		}
		
		public static function addrighttextlabel(x:int, y:int, text:String, col:int = 2, towindow:Boolean = false):void {
			addguipart(x, y, col, 0, text, "", "righttextlabel");
			if (towindow) button[lastbutton].onwindow = true;
		}
		
		public static function addblackout(towindow:Boolean = false):void {
			addguipart(0, 0, 0, 0, "", "", "blackout", 12);
			if (towindow) button[lastbutton].onwindow = true;
		}
		
		public static function addrect(x:int, y:int, w:int, h:int, col:int = 1, action:String = "", towindow:Boolean = false):void {
			addguipart(x, y, w, h, "", action, "fillrect", col);
			if (towindow) button[lastbutton].onwindow = true;
		}
		
		public static function addhighlight(x:int, y:int, w:int, h:int, col:int = 1, action:String = "", towindow:Boolean = false):void {
			highlightflash = 30;
			addguipart(x, y, w, h, "", action, "highlight", col);
			if (towindow) button[lastbutton].onwindow = true;
		}
		
		public static function addleftarrow(x:int, y:int, action:String, towindow:Boolean = false):void {
			addguipart(x, y, 16, 16, "", action, "leftarrow");
			if (towindow) button[lastbutton].onwindow = true;
		}
		
		public static function addrightarrow(x:int, y:int, action:String, towindow:Boolean = false):void {
			addguipart(x, y, 16, 16, "", action, "rightarrow");
			if (towindow) button[lastbutton].onwindow = true;
		}
		
		public static function addplayarrow(x:int, y:int, action:String, towindow:Boolean = false):void {
			addguipart(x, y, 16, 16, "", action, "playarrow");
			if (towindow) button[lastbutton].onwindow = true;
		}
		
		public static function addpausebutton(x:int, y:int, action:String, towindow:Boolean = false):void {
			addguipart(x, y, 16, 16, "", action, "pause");
			if (towindow) button[lastbutton].onwindow = true;
		}
		
		public static function addstopbutton(x:int, y:int, action:String, towindow:Boolean = false):void {
			addguipart(x, y, 16, 16, "", action, "stop");
			if (towindow) button[lastbutton].onwindow = true;
		}
		
		public static function addplusbutton(x:int, y:int, action:String, towindow:Boolean = false):void {
			addguipart(x, y, 16, 16, "", action, "plus");
			if (towindow) button[lastbutton].onwindow = true;
		}
		
		public static function addminusbutton(x:int, y:int, action:String, towindow:Boolean = false):void {
			addguipart(x, y, 16, 16, "", action, "minus");
			if (towindow) button[lastbutton].onwindow = true;
		}
		
		public static function adddownarrow(x:int, y:int, action:String, towindow:Boolean = false):void {
			addguipart(x, y, 16, 16, "", action, "downarrow");
			if (towindow) button[lastbutton].onwindow = true;
		}
			
		public static function adduparrow(x:int, y:int, action:String, towindow:Boolean = false):void {
			addguipart(x, y, 16, 16, "", action, "uparrow");
			if (towindow) button[lastbutton].onwindow = true;
		}
		
		public static function addscrollupbutton(x:int, y:int, w:int, action:String, towindow:Boolean = false):void {
			addguipart(x, y, w, 21, "", action, "scrollup");
			if (towindow) button[lastbutton].onwindow = true;
		}
		
		public static function addscrolldownbutton(x:int, y:int, w:int,action:String, towindow:Boolean = false):void {
			addguipart(x, y, w, 21, "", action, "scrolldown");
			if (towindow) button[lastbutton].onwindow = true;
		}
		
		public static function addvariable(x:int, y:int, variable:String, col:int = 0, towindow:Boolean = false):void {
			addguipart(x, y, col, 0, "", variable, "variable");
			if (towindow) button[lastbutton].onwindow = true;
		}
		
		public static function addhorizontalslider(x:int, y:int, w:int, variable:String, towindow:Boolean = false):void {
			addguipart(x, y, w, 26, "", variable, "horizontalslider");
			if (towindow) button[lastbutton].onwindow = true;
		}
		
		public static function addcontrol(x:int, y:int, type:String):void {
			//For complex multipart things
			if (type == "changepatternlength") {
				addrect(x, y - 4, 320, 26);
				addrighttextlabel(x + 120, y, "PATTERN", 0);
				
				addleftarrow(x + 140, y , "barcountdown");
				addvariable(x + 170, y, "barcount");
				addrightarrow(x + 200, y, "barcountup");
				
				addleftarrow(x + 230, y, "boxcountdown");
				addvariable(x + 250, y, "boxcount");
				addrightarrow(x + 290, y, "boxcountup");
			}else if (type == "changebpm") {
				addrect(x, y - 4, 320, gfx.buttonheight);
				addrighttextlabel(x + 120, y, "BPM", 0);
				
				addleftarrow(x + 170, y, "bpmdown");
				addvariable(x + 200, y, "bpm");
				addrightarrow(x + 260, y, "bpmup");
			}else if (type == "changesoundbuffer") {
				addrect(x, y - 4, 320, gfx.buttonheight);
				addrighttextlabel(x + 160, y, "SOUND BUFFER ", 0);
				
				adddownarrow(x + 210, y, "bufferlist");
				addvariable(x + 240, y, "buffersize");
				addvariable(x + 8, y + gfx.buttonheight + 4, "buffersizealert");
			}else if (type == "swingcontrol") {
				addrect(x, y - 4, 320, gfx.buttonheight);
				addrighttextlabel(x + 120, y, "SWING", 0);
				
				addleftarrow(x + 170, y, "swingdown");
				addvariable(x + 200, y, "swing");
				addrightarrow(x + 260, y, "swingup");
			}else if (type == "globaleffects") {
				addrect(x + 40, y - 4, 150, gfx.buttonheight, 6);
				adddownarrow(x + 10, y, "effectslist");
				addvariable(x, y, "currenteffect");
				addhorizontalslider(x + 40, y - 4, 130, "currenteffect");
			}else if (type == "footer_instrumentlist") {
				addrect(x, y, 280, gfx.linesize, 1, "footer_instrumentlist");
				adduparrow(x + 10, y + 4, "footer_instrumentlist");
				addvariable(x + 38, y, "currentinstrument");	
			}else if (type == "footer_keylist") {
				addrect(x, y, 80, gfx.linesize, 1, "footer_keylist");
				adduparrow(x + 10, y + 4, "footer_keylist");
				addvariable(x + 38, y, "currentkey");
			}else if (type == "footer_scalelist") {
				addrect(x, y, 300, gfx.linesize, 1, "footer_scalelist");
				adduparrow(x + 10, y + 4, "footer_scalelist");
				addvariable(x + 38, y, "currentscale");
			}
		}
		
		public static function addguipart(x:int, y:int, w:int, h:int, contents:String, act:String = "", sty:String = "normal", toffset:int = 0):void {
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
			//trace("addguipart(", x, y, w, h, contents, act, sty, ")", numbuttons);
			button[z].init(x, y, w, h, contents, act, sty);
			button[z].textoffset = toffset;
			if (sty == "horizontalslider" || sty == "scrollup" || sty == "scrolldown"
			 || sty == "window") {
				button[z].moveable = true;
			}
			lastbutton = z;
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
			if (highlightflash > 0) {
				highlightflash--;
			}
			//Do window stuff first
			overwindow = false;
			for (var i:int = 0; i < numbuttons; i++) {
				if (button[i].active && button[i].visable) {
					if (button[i].action == "window") {
						if (help.inboxw(control.mx, control.my, button[i].position.x, button[i].position.y, button[i].position.width, button[i].position.height)) {
							button[i].mouseover = true;
							overwindow = true;
						}
						
						if (key.press && !control.clicklist) {
							if (button[i].moveable) {
								if (help.inboxw(control.mx, control.my, button[i].position.x - 20, button[i].position.y - 20, button[i].position.width + 40, button[i].position.height + 40)) {
									dobuttonmoveaction(i);
								}
							}
						}
					}
				}
			}
			
			for (i = 0; i < numbuttons; i++) {
				if (button[i].active && button[i].visable) {
					if (!overwindow || button[i].onwindow) {
						if (help.inboxw(control.mx, control.my, button[i].position.x, button[i].position.y, button[i].position.width, button[i].position.height)) {
							button[i].mouseover = true;
						}else {
							button[i].mouseover = false;
						}
					}
					
					if (button[i].action == "window" && windowdrag) {
						if (key.hasreleased) {
							windowdrag = false;
							trace("From LEFT: " + String(windowx) + ", " + String(windowy));
							trace("From RIGHT: gfx.screenwidth - windowwidth - " + String(gfx.screenwidth - windowwidth - windowx) + ", gfx.screenheight - " + String(gfx.screenheight - windowy));
						}else {
							button[i].position.x = control.mx - windowdx;
							button[i].position.y = control.my - windowdy;
							if (button[i].position.x < 0) button[i].position.x = 0;
							if (button[i].position.y < 0) button[i].position.y = 0;
							
							if (button[i].position.x > gfx.screenwidth - button[i].position.width) button[i].position.x = gfx.screenwidth - button[i].position.width;
							if (button[i].position.y > gfx.screenheight - button[i].position.height) button[i].position.y = gfx.screenheight - button[i].position.height;
							
							windowddx = windowx - button[i].position.x;
							windowddy = windowy - button[i].position.y;
							
							windowx = button[i].position.x;
							windowy = button[i].position.y;
							
							for (var j:int = 0; j < numbuttons; j++) {
								if (button[j].active && button[j].visable) {
									if (button[j].onwindow) {
										button[j].position.x -= windowddx;
										button[j].position.y -= windowddy;
									}
								}
							}
						}
					}else if (button[i].action != "" && button[i].action != "window" && !control.list.active) {
						if (!overwindow || button[i].onwindow) {
							if (key.press && !control.clicklist) {
								if (button[i].moveable) {
									if (help.inboxw(control.mx, control.my, button[i].position.x - 20, button[i].position.y - 20, button[i].position.width + 40, button[i].position.height + 40)) {
										dobuttonmoveaction(i);
									}
								}
							}
							
							if (key.click) {
								if (button[i].mouseover) {
									dobuttonaction(i);
									key.click = false;
								}
							}
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
						if (button[i].pressed > 0) {
							button[i].pressed--;
							if (button[i].pressed < 2) {
								timage = 1;
							}else{
								timage = 0;
							}
						}else{
							timage = 2;
						}
						if (button[i].mouseover) {
							gfx.fillrect(button[i].position.x - timage, button[i].position.y - timage, button[i].position.width, button[i].position.height, 20);
						}else {
							gfx.fillrect(button[i].position.x - timage, button[i].position.y - timage, button[i].position.width, button[i].position.height, 1);
						}
						
						//tx = button[i].position.x + 7 - timage + button[i].textoffset;
						tx = button[i].position.x + (button[i].position.width / 2) - (gfx.len(button[i].text) / 2) + button[i].textoffset - timage;
						ty = button[i].position.y + 2 - timage;
						
						gfx.print(tx, ty, button[i].text, 0, false, true);
					}else if (button[i].style == "blackout") {
						for (var j:int = 0; j < gfx.screenheight; j++) {
							if (j % 4 == 0) {
								gfx.fillrect(0, j, gfx.screenwidth, 2, 12);
							}
						}
					}else if (button[i].style == "window") {
						tx = button[i].position.x;
						ty = button[i].position.y;
						tw = button[i].position.width;
						th = button[i].position.height;
						gfx.fillrect(tx - 5 + 15, ty - 5 + 15, tw + 10, th + 10, 12);
						gfx.fillrect(tx - 5, ty - 5, tw + 10, th + 10, 12);
						gfx.fillrect(tx, ty, tw, th, 4);
						gfx.fillrect(tx, ty, tw, 24, 5);
						gfx.print(tx + 2, ty + 1, button[i].text, 0, false, true);
						
						gfx.drawicon(tx + tw - 20, ty + 4, 14);
					}else if (button[i].style == "scrollup") {
						if (button[i].pressed > 0) {
							button[i].pressed--;
							gfx.fillrect(button[i].position.x, button[i].position.y, button[i].position.width, 20, 12);
							gfx.fillrect(button[i].position.x + 2, button[i].position.y + 2, button[i].position.width - 4, 16, 6);
							gfx.drawicon(button[i].position.x + ((button[i].position.width - 16)/2), button[i].position.y + 4, 10);
						}else {
							gfx.fillrect(button[i].position.x, button[i].position.y, button[i].position.width, 20, 12);
							gfx.fillrect(button[i].position.x + 2, button[i].position.y + 2, button[i].position.width - 4, 16, 5);
							gfx.drawicon(button[i].position.x + ((button[i].position.width - 16)/2), button[i].position.y + 4, 10);
						}
					}else if (button[i].style == "scrolldown") {
						if (button[i].pressed > 0) {
							button[i].pressed--;
							gfx.fillrect(button[i].position.x, button[i].position.y, button[i].position.width, 20, 12);
							gfx.fillrect(button[i].position.x + 2, button[i].position.y + 2, button[i].position.width - 4, 16, 6);
							gfx.drawicon(button[i].position.x + ((button[i].position.width - 16)/2), button[i].position.y + 4, 11);
						}else {
							gfx.fillrect(button[i].position.x, button[i].position.y, button[i].position.width, 20, 12);
							gfx.fillrect(button[i].position.x + 2, button[i].position.y + 2, button[i].position.width - 4, 16, 5);
							gfx.drawicon(button[i].position.x + ((button[i].position.width - 16)/2), button[i].position.y + 4, 11);
						}
					}else if (button[i].style == "tutorialimage") {
						gfx.drawimage(button[i].textoffset + 8, button[i].position.x, button[i].position.y);
					}else if (button[i].style == "textlabel") {
						gfx.print(button[i].position.x, button[i].position.y, button[i].text, button[i].position.width, false, true);
					}else if (button[i].style == "righttextlabel") {
						gfx.rprint(button[i].position.x, button[i].position.y, button[i].text, button[i].position.width, true);
					}else if (button[i].style == "fillrect") {
						gfx.fillrect(button[i].position.x, button[i].position.y, button[i].position.width, button[i].position.height, button[i].textoffset);
					}else if (button[i].style == "highlight") {
						if (highlightflash % 8 < 4) {
							gfx.drawbox(button[i].position.x, button[i].position.y, button[i].position.width, button[i].position.height, button[i].textoffset);
							gfx.drawbox(button[i].position.x - 2, button[i].position.y - 2, button[i].position.width + 4, button[i].position.height + 4, 19);
						}
					}else if (button[i].style == "leftarrow") {
						gfx.drawicon(button[i].position.x, button[i].position.y, 3);
					}else if (button[i].style == "rightarrow") {
						gfx.drawicon(button[i].position.x, button[i].position.y, 2);
					}else if (button[i].style == "playarrow") {
						if (button[i].pressed > 0) {	
							gfx.drawicon(button[i].position.x, button[i].position.y + 1, 2);
							button[i].pressed--;
						}else{
							gfx.drawicon(button[i].position.x, button[i].position.y, 2);
						}
					}else if (button[i].style == "stop") {
						if (button[i].pressed > 0) {	
							gfx.drawicon(button[i].position.x, button[i].position.y + 1, 6);
							button[i].pressed--;
						}else{
							gfx.drawicon(button[i].position.x, button[i].position.y, 6);
						}
					}else if (button[i].style == "pause") {
						if (button[i].pressed > 0) {	
							gfx.drawicon(button[i].position.x, button[i].position.y + 1, 7);
							button[i].pressed--;
						}else{
							gfx.drawicon(button[i].position.x, button[i].position.y, 7);
						}
					}else if (button[i].style == "plus") {
						if (button[i].pressed > 0) {	
							gfx.drawicon(button[i].position.x, button[i].position.y + 1, 8);
							button[i].pressed--;
						}else{
							gfx.drawicon(button[i].position.x, button[i].position.y, 8);
						}
					}else if (button[i].style == "minus") {
						if (button[i].pressed > 0) {	
							gfx.drawicon(button[i].position.x, button[i].position.y + 1, 9);
							button[i].pressed--;
						}else{
							gfx.drawicon(button[i].position.x, button[i].position.y, 9);
						}
					}else if (button[i].style == "uparrow") {
						gfx.drawicon(button[i].position.x, button[i].position.y, 1);
					}else if (button[i].style == "downarrow") {
						gfx.drawicon(button[i].position.x, button[i].position.y, 0);
					}else if (button[i].style == "horizontalslider") {
						if (button[i].action == "currenteffect") {
							gfx.fillrect(button[i].position.x, button[i].position.y, 20, 26, 6);
							gfx.fillrect(button[i].position.x + 2, button[i].position.y + 2, 16, 22, 5);
							
							tx = int((control.effectvalue));
							gfx.fillrect(button[i].position.x + tx, button[i].position.y, 20, 26, 4);
							gfx.fillrect(button[i].position.x + tx + 2, button[i].position.y + 2, 16, 22, 2);
							
							gfx.fillrect(button[i].position.x + tx + 4, button[i].position.y + 8, 12, 2, 4);
							gfx.fillrect(button[i].position.x + tx + 4, button[i].position.y + 12, 12, 2, 4);
							gfx.fillrect(button[i].position.x + tx + 4, button[i].position.y + 16, 12, 2, 4);
						}
					}else if (button[i].style == "variable") {
						if(button[i].action == "barcount"){
						  gfx.print(button[i].position.x, button[i].position.y, String(control.barcount), button[i].position.width, false, true);
						}else if(button[i].action == "boxcount"){
						  gfx.print(button[i].position.x, button[i].position.y, String(control.boxcount), button[i].position.width, false, true);
						}else if(button[i].action == "bpm"){
						  gfx.print(button[i].position.x, button[i].position.y, String(control.bpm), button[i].position.width, false, true);
						}else if(button[i].action == "buffersize"){
						  gfx.print(button[i].position.x, button[i].position.y, String(control.buffersize), button[i].position.width, false, true);
						}else if (button[i].action == "buffersizealert") {
							if (control.buffersize != control.currentbuffersize) {
								if (help.slowsine >= 32) {
									gfx.print(button[i].position.x, button[i].position.y, "REQUIRES RESTART", 0);
								}else {
									gfx.print(button[i].position.x, button[i].position.y, "REQUIRES RESTART", 15);
								}
							}
						}else if (button[i].action == "swing") {
							if(control.swing==-10){
								gfx.print(button[i].position.x, button[i].position.y, String(control.swing), 0, false, true);
							}else if (control.swing < 0 || control.swing == 10 ) {
								gfx.print(button[i].position.x + 5, button[i].position.y, String(control.swing), 0, false, true);
							}else{
								gfx.print(button[i].position.x + 10, button[i].position.y, String(control.swing), 0, false, true);
							}
						}else if (button[i].action == "currenteffect") {
							gfx.rprint(button[i].position.x, button[i].position.y, control.effectname[control.effecttype], button[i].position.width, true);
						}else if (button[i].action == "currentinstrument") {
							if (control.currentbox > -1) {
								gfx.print(button[i].position.x, button[i].position.y, String(control.musicbox[control.currentbox].instr + 1) + "  " + control.instrument[control.musicbox[control.currentbox].instr].name, 0, false, true);
							}
						}else if (button[i].action == "currentkey") {
							gfx.print(button[i].position.x, button[i].position.y, control.notename[control.key], 0, false, true);
						}else if (button[i].action == "currentscale") {
							gfx.print(button[i].position.x, button[i].position.y, control.scalename[control.currentscale], 0, false, true);
						}
					}else if (button[i].style == "logo") {
						tx = button[i].position.x;
						ty = button[i].position.y;
						if(control.currentbox!=-1){
						  timage = control.musicbox[control.currentbox].palette;
							if (timage > 6) timage = 6;
						}else {
							timage = 6;
						}
						
						if (button[i].pressed > 0) {
							gfx.drawimage(7, tx + 6, ty + 2);
							gfx.drawimage(timage, tx, ty - 8);
							if (control.looptime % control.barcount == 1) {
								button[i].pressed--;
							}
						}else{
							if (control.looptime % control.barcount == 1) {
								gfx.drawimage(7, tx + 6, ty + 10 - 8);
								gfx.drawimage(timage, tx, ty + 4 - 8);
							}else {
								gfx.drawimage(7, tx + 6, ty + 10);
								gfx.drawimage(timage, tx, ty + 4);
							}
						}
					}
				}
			}
		}
		
		public static function deleteall(t:String = ""):void {
			if (t == "") {
				for (var i:int = 0; i < numbuttons; i++) button[i].active = false;
				numbuttons = 0;
			}else{
				//Deselect any buttons with style t
				for (i = 0; i < numbuttons; i++) {
					if (button[i].active) {
						if (button[i].style == t) {
							button[i].active = false;
						}
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
			deleteall();
			
			//Some gui stuff is on every tab: add it back here:
			//Footer
			if (control.currentbox > -1) {
				addrect(0, gfx.screenheight - (gfx.linesize), gfx.screenwidth, gfx.linesize, 4);
				if (control.currentbox > -1) {
					addcontrol(10, gfx.screenheight - (gfx.linesize), "footer_instrumentlist");
					if (control.instrument[control.musicbox[control.currentbox].instr].type == 0) {
						addplusbutton(gfx.screenwidth - 460, gfx.screenheight - (gfx.linesize), "transposeup");
						addminusbutton(gfx.screenwidth - 420, gfx.screenheight - (gfx.linesize), "transposedown");
						addcontrol(gfx.screenwidth - 380, gfx.screenheight - (gfx.linesize), "footer_scalelist");
						addcontrol(gfx.screenwidth - 80, gfx.screenheight - (gfx.linesize), "footer_keylist");
					}
				}
				
				if (control.doublesize) {
					//addrect(42 + (32 * control.boxsize), gfx.pianorollposition + gfx.linesize, gfx.screenwidth - (42 + (32 * control.boxsize)), gfx.screenheight - gfx.linesize - 20 - gfx.pianorollposition - gfx.linesize, 12);
					//addrect(42 + (32 * control.boxsize)+ 2, gfx.pianorollposition + gfx.linesize, gfx.screenwidth - (42 + (32 * control.boxsize))- 4, gfx.screenheight - gfx.linesize - 20 - gfx.pianorollposition - gfx.linesize, 4);
					addscrollupbutton(42 + (32 * control.boxsize), gfx.pianorollposition + gfx.linesize, gfx.screenwidth - (42 + (32 * control.boxsize)), "notescrollup");
				  addscrolldownbutton(42 + (32 * control.boxsize), gfx.screenheight - gfx.linesize - 20, gfx.screenwidth - (42 + (32 * control.boxsize)), "notescrolldown");
				}else {
				  //addrect(42 + (16 * control.boxsize), gfx.pianorollposition + gfx.linesize, gfx.screenwidth - (42 + (16 * control.boxsize)), gfx.screenheight - gfx.linesize - 20 - gfx.pianorollposition - gfx.linesize, 12);
					//addrect(42 + (16 * control.boxsize)+ 2, gfx.pianorollposition + gfx.linesize, gfx.screenwidth - (42 + (16 * control.boxsize))- 4, gfx.screenheight - gfx.linesize - 20 - gfx.pianorollposition - gfx.linesize, 4);
					addscrollupbutton(42 + (16 * control.boxsize), gfx.pianorollposition + gfx.linesize, gfx.screenwidth - (42 + (16 * control.boxsize)), "notescrollup");
				  addscrolldownbutton(42 + (16 * control.boxsize), gfx.screenheight - gfx.linesize - 20, gfx.screenwidth - (42 + (16 * control.boxsize)), "notescrolldown");
				}
			}
			
		  switch(t) {
				case control.MENUTAB_FILE:
					tx = (gfx.screenwidth - 768) / 4;
					addlogo(24 + tx, (gfx.linespacing * 2));
					addtextlabel(330 + tx, (gfx.linespacing * 5), control.versionnumber);
					
					addtextlabel(20 + tx, (gfx.linespacing * 6) + 2, "Created by Terry Cavanagh");
					addtextlabel(20 + tx, (gfx.linespacing * 7) + 2, "http://www.distractionware.com");
					
					addbutton(20 + tx, (gfx.linespacing * 9)-6, 120, "CREDITS", "creditstab");
					addbutton(154 + tx, (gfx.linespacing * 9)-6, 120, "HELP", "helptab");
					
					CONFIG::desktop {
						addbutton(gfx.screenwidth - 340 - tx, gfx.linespacing * 2, 150, "NEW SONG", "newsong");
						addbutton(gfx.screenwidth - 170 - tx, gfx.linespacing * 2, 150, "EXPORT...", "exportlist");
						addbutton(gfx.screenwidth - 340 - tx, (gfx.linespacing * 4) + 10, 150, "LOAD .ceol", "loadceol");
						addbutton(gfx.screenwidth - 170 - tx, (gfx.linespacing * 4) + 10, 150, "SAVE .ceol", "saveceol");
					}
					
					addcontrol(gfx.screenwidth - 340 - tx, (gfx.linespacing * 7) - 2, "changepatternlength");
					addcontrol(gfx.screenwidth - 340 - tx, (gfx.linespacing * 9) - 2, "changebpm");
					
				  addrect(290 + tx, (gfx.linespacing * 9) - 6, 100, 26);
					addplayarrow(300 + tx, (gfx.linespacing * 9) - 2, "play");
					addpausebutton(330 + tx, (gfx.linespacing * 9) - 2, "pause");
					addstopbutton(360 + tx, (gfx.linespacing * 9) - 2, "stop");
				break;
				case control.MENUTAB_CREDITS:
					tx = (gfx.screenwidth - 768) / 4;
				  addtextlabel(tx + 20, (gfx.linespacing * 1)+10, "SiON softsynth library by Kei Mesuda", 0);
					addtextlabel(tx + 20, (gfx.linespacing * 2)+10, "sites.google.com/site/sioncenter/");
					
					addrighttextlabel(gfx.screenwidth - 20 - tx, (gfx.linespacing * 1)+10, "Midias library by Efishocean", 0);
					addrighttextlabel(gfx.screenwidth - 20 - tx, (gfx.linespacing * 2)+10, "code.google.com/p/midas3/");
					
					addtextlabel(tx + 20, (gfx.linespacing * 4), "XM, MML Exporters by Rob Hunter",0);
					addtextlabel(tx + 20, (gfx.linespacing * 5), "about.me/rjhunter/");
					
					addrighttextlabel(gfx.screenwidth - 20 - tx, (gfx.linespacing * 4), "Linux port by Damien L",0);
					addrighttextlabel(gfx.screenwidth - 20 - tx, (gfx.linespacing * 5), "uncovergame.com/");
					
					addtextlabel(tx + 20, (gfx.linespacing * 7) - 10, "Swing function by Stephen Lavelle", 0);
					addtextlabel(tx + 20, (gfx.linespacing * 8) - 10, "increpare.com/");
					
					addtextlabel(tx + 20, (gfx.linespacing * 9) + 8, "Available under FreeBSD Licence", 0);
					
					addrighttextlabel(gfx.screenwidth - 20 - tx, (gfx.linespacing * 7) - 10, "Online version by Chris Kim", 0);
				  addrighttextlabel(gfx.screenwidth - 20 - tx, (gfx.linespacing * 8) - 10, "dy-dx.com/");
					
					addbutton(gfx.screenwidth - 164 - tx, (gfx.linespacing * 9) + 8, 150, "BACK", "filetab");
				break;
				case control.MENUTAB_HELP:
					tx = (gfx.screenwidth - 768) / 2;
					addcentertextlabel(tx,  (gfx.linespacing * 2), 768, "Learn the basics of how to make a song in Bosca Ceoil:", 0);
					addbutton(gfx.screenwidthmid - 126, (gfx.linespacing * 3)+10, 250, "BASIC GUIDE", "help1");
					
					addcentertextlabel(tx,  (gfx.linespacing * 6), 768, "Learn about some of the more advanced features:", 0);
					addbutton(gfx.screenwidthmid - 125, (gfx.linespacing * 7)+10, 250, "TIPS AND TRICKS", "advancedhelp1");
					
					addbutton(gfx.screenwidth - 164 - tx, (gfx.linespacing * 9) + 8, 150, "BACK", "filetab");
				break;
			  case control.MENUTAB_ARRANGEMENTS:
				  addbutton(gfx.patternmanagerx + 10, gfx.linespacing + gfx.pianorollposition - 28, gfx.screenwidth - (gfx.patternmanagerx) - 16, "ADD NEW", "addnewpattern");
			  break;
			  case control.MENUTAB_INSTRUMENTS:
				  addbutton(10, gfx.linespacing + gfx.pianorollposition - 28, 264, "ADD NEW INSTRUMENT", "addnewinstrument");
					addminusbutton(706, (gfx.linespacing * 2) + 6, "previousinstrument");
					addplusbutton(726, (gfx.linespacing * 2) + 6, "nextinstrument");
				break;
				case control.MENUTAB_ADVANCED:
					tx = (gfx.screenwidth - 768) / 4;
				  addcontrol(40 + tx, (gfx.linespacing * 3) + 4, "changesoundbuffer");
					addcontrol(40 + tx, (gfx.linespacing * 7) + 4, "swingcontrol");
					addcontrol(gfx.screenwidth - 210 - tx,  (gfx.linespacing * 3) + 4, "globaleffects");
					
					if (gfx.scalemode == 0) {
						addbutton(gfx.screenwidth - 340 - tx, gfx.linespacing * 7, 150, "SCALE UP", "changescale");
					}else {
						addbutton(gfx.screenwidth - 340 - tx, gfx.linespacing * 7, 150, "SCALE DOWN", "changescale");
					}
					CONFIG::desktop {
						addbutton(gfx.screenwidth - 170 - tx, gfx.linespacing * 7, 150, "IMPORT .mid", "loadmidi");
					}
				break;
			}
			
			if (windowx >= gfx.screenwidth || windowy >= gfx.screenheight) {
				changewindow(helpwindow);
			}else{
				changewindow(helpwindow, false);
			}
		}
		
		public static function dobuttonmoveaction(i:int):void {
			currentbutton = button[i].action;
			
			if (currentbutton == "window") {
				if (control.mx >= button[i].position.x && control.mx < button[i].position.x + button[i].position.width && control.my >= button[i].position.y && control.my <= button[i].position.y + 22) {
					//if we're currently dragging, move the window
					if (windowdrag) {
					}else {
						//otherwise start dragging from here
						if (control.mx >= button[i].position.x + button[i].position.width - 20) {
							//close the window
							changewindow("nothing");
							changetab(control.currenttab);
							control.clicklist = true;
						}else{
							windowdrag = true;
							windowdx = control.mx - button[i].position.x; windowdy = control.my - button[i].position.y;
						}
					}
				}
			}else	if (currentbutton == "currenteffect") {
				if (control.mx >= button[i].position.x - 5  - 20 && control.mx < button[i].position.x + button[i].position.width + 20 && control.my >= button[i].position.y - 4 - 20 && control.my <= button[i].position.y + gfx.buttonheight + 4 + 20) {
					var barposition:int = control.mx - (button[i].position.x + 5);
					if (barposition < 0) barposition = 0; 
					if (barposition > button[i].position.width) barposition = button[i].position.width;
					
					control.effectvalue = barposition;
					control.updateeffects();
				}
			}else if (currentbutton == "notescrollup") {
				if (control.mx >= button[i].position.x && control.mx < button[i].position.x + button[i].position.width && control.my >= button[i].position.y && control.my <= button[i].position.y + button[i].position.width) {
					button[i].pressed = 2;
					if (control.currentbox > -1) {
						control.musicbox[control.currentbox].start++;
						if (control.musicbox[control.currentbox].start > 120 - gfx.notesonscreen) {
							control.musicbox[control.currentbox].start = 120 - gfx.notesonscreen;
						}
					}
				}
			}else if (currentbutton == "notescrolldown") {
				if (control.mx >= button[i].position.x && control.mx < button[i].position.x + button[i].position.width && control.my >= button[i].position.y && control.my <= button[i].position.y + button[i].position.width) {
					button[i].pressed = 2;
					if (control.currentbox > -1) {
						control.musicbox[control.currentbox].start--;
						if (control.musicbox[control.currentbox].start < 0) {
							control.musicbox[control.currentbox].start = 0;
						}
					}
				}
			}
		}
		
		public static function dobuttonaction(i:int):void {
			currentbutton = button[i].action;
			button[i].press();
			
			if (currentbutton == "newsong") {
				control.newsong();
			  button[i].press();
			}else if (currentbutton == "logo") {
				if (!control.musicplaying) {
					button[i].pressed = 0;
				}
			}else if (currentbutton == "play") {
			  if (!control.musicplaying) {
					control.startmusic();
				}
			}else if (currentbutton == "pause") {
			  if (control.musicplaying) {
					control.pausemusic();
				}
			}else if (currentbutton == "stop") {
			  if (control.musicplaying) {
					control.stopmusic();
				}
			}else if (currentbutton == "exportlist") {
				CONFIG::desktop {
					tx = (gfx.screenwidth - 768) / 4;
					control.filllist(control.LIST_EXPORTS);
					control.list.init(gfx.screenwidth - 170 - tx, (gfx.linespacing * 4) - 14);
				}
				
				CONFIG::web {
				  control.exportwav();
				}
			}else if (currentbutton == "loadceol") {
				CONFIG::desktop {
					control.loadceol();
				}
			}else if (currentbutton == "saveceol") {
				CONFIG::desktop {
				  control.saveceol();
				}
			}else if (currentbutton == "filetab") {
				control.changetab(control.MENUTAB_FILE);
			}else if (currentbutton == "arrangementstab") {
				control.changetab(control.MENUTAB_ARRANGEMENTS);
			}else if (currentbutton == "instrumentstab") {
				control.changetab(control.MENUTAB_INSTRUMENTS);
			}else if (currentbutton == "advancedtab") {
				control.changetab(control.MENUTAB_ADVANCED);
			}else if (currentbutton == "creditstab") {
				control.changetab(control.MENUTAB_CREDITS);
			}else if (currentbutton == "helptab") {
				/*
				changewindow("firstrun");
				*/
				control.changetab(control.MENUTAB_HELP);
			}else if (currentbutton == "barcountdown") {
				control.barcount--;
				if (control.barcount < 1) control.barcount = 1;
			}else if (currentbutton == "barcountup") {
				control.barcount++;
				if (control.barcount > 32) control.barcount = 32;
			}else if (currentbutton == "boxcountdown") {
				control.boxcount--;
				if (control.boxcount < 1) control.boxcount = 1;
				control.doublesize = control.boxcount > 16;
				gfx.updateboxsize();
				changetab(control.currenttab);
			}else if (currentbutton == "boxcountup") {
				control.boxcount++;
				if (control.boxcount > 32) control.boxcount = 32;
				control.doublesize = control.boxcount > 16;
				gfx.updateboxsize();
				changetab(control.currenttab);
			}else if (currentbutton == "bpmdown") {
				control.bpm -= 5;
				if (control.bpm < 10) control.bpm = 10;
				control._driver.bpm = control.bpm;
			}else if (currentbutton == "bpmup") {
				control.bpm += 5;
				if (control.bpm > 220) control.bpm = 220;
				control._driver.bpm = control.bpm;
			}else if (currentbutton == "bufferlist") {
				control.filllist(control.LIST_BUFFERSIZE);
				control.list.init(210, (gfx.linespacing * 4) + 4);
			}else if (currentbutton == "swingup") {
				control.swing ++;
				if (control.swing > 10) control.swing = 10;
			}else if (currentbutton == "swingdown") {
				control.swing --;
				if (control.swing < -10) control.swing = -10;
			}else if (currentbutton == "effectslist") {
				tx = (gfx.screenwidth - 768) / 4;
				control.filllist(control.LIST_EFFECTS);
				control.list.init(gfx.screenwidth - 280 - tx, (gfx.linespacing * 4) - 3);
			}else if (currentbutton == "addnewinstrument") {
				if (control.numinstrument < 16) {
					control.numinstrument++;
					control.instrumentmanagerview = control.numinstrument - 6;
					if (control.instrumentmanagerview < 0) control.instrumentmanagerview = 0;
				}
			}else if (currentbutton == "addnewpattern") {
				control.addmusicbox();
				control.patternmanagerview = control.numboxes - 6;
				if (control.patternmanagerview < 0) control.patternmanagerview = 0;
			}else if (currentbutton == "footer_instrumentlist") {
				control.filllist(control.LIST_SELECTINSTRUMENT);
				control.list.init(20, (gfx.screenheight - gfx.linesize) - (control.list.numitems * gfx.linesize));
			}else if (currentbutton == "footer_scalelist") {
				control.filllist(control.LIST_SCALE);
				control.list.init(gfx.screenwidth - 360, (gfx.screenheight - gfx.linesize) - (control.list.numitems * gfx.linesize));
			}else if (currentbutton == "footer_keylist") {
				control.filllist(control.LIST_KEY);
				control.list.init(gfx.screenwidth - 60, (gfx.screenheight - gfx.linesize) - (control.list.numitems * gfx.linesize));
			}else if (currentbutton == "transposeup") {
				control.musicbox[control.currentbox].transpose(1);
			}else if (currentbutton == "transposedown") {
				control.musicbox[control.currentbox].transpose(-1);
			}else if (currentbutton == "nextinstrument") {
				control.nextinstrument();
			}else if (currentbutton == "previousinstrument") {
				control.previousinstrument();
			}else if (currentbutton == "loadmidi") {
			  button[i].press();
				CONFIG::desktop {
					midicontrol.openfile();
				}
			}else if (currentbutton == "changescale") {
			  button[i].press();
				gfx.changescalemode(1 - gfx.scalemode);
				changetab(control.MENUTAB_ADVANCED);
			}else if (currentbutton == "closewindow") {
				changewindow("nothing");
				control.changetab(control.currenttab);
				control.clicklist = true;
			}else if (currentbutton == "help1") {
				if (control.currentbox == -1) {
					control.currentbox = 0;
					control.newsong();
				}
				
				control.currenttab = control.MENUTAB_FILE;
				changewindow("help1");
				control.changetab(control.currenttab); control.clicklist = true;
			}else if (currentbutton == "help2") {
				changewindow("help2");
				control.changetab(control.currenttab); control.clicklist = true;
			}else if (currentbutton == "help3") {
				changewindow("help3");
				control.changetab(control.currenttab); control.clicklist = true;
			}else if (currentbutton == "help4") {
				changewindow("help4");
				control.changetab(control.currenttab); control.clicklist = true;
			}else if (currentbutton == "help5") {
				changewindow("help5");
				control.changetab(control.currenttab); control.clicklist = true;
			}else if (currentbutton == "help6") {
				changewindow("help6");
				control.changetab(control.currenttab); control.clicklist = true;
			}else if (currentbutton == "help7") {
				changewindow("help7");
				control.changetab(control.currenttab); control.clicklist = true;
			}else if (currentbutton == "advancedhelp1") {
				control.currenttab = control.MENUTAB_FILE;
				
				changewindow("advancedhelp1");
				control.changetab(control.currenttab); control.clicklist = true;
			}
		}
		
		public static var button:Vector.<guibutton> = new Vector.<guibutton>;
		public static var numbuttons:int;
		public static var maxbuttons:int;
		
		public static var tx:int, ty:int, timage:int;
		public static var tw:int, th:int;
		public static var currentbutton:String;
		public static var lastbutton:int;
		public static var highlightflash:int;
		
		public static var windowcheck:Boolean;
		public static var windowdrag:Boolean = false;
		public static var overwindow:Boolean = false;
		public static var windowddx:int, windowddy:int;
		public static var windowdx:int, windowdy:int;
		public static var windowx:int, windowy:int;
		public static var windowwidth:int, windowheight:int;
		public static var windowline:int;
		public static var windowxoffset:int;
		public static var windowyoffset:int;
		public static var windowtext:String;
		
		public static var helpwindow:String;
	}
}
