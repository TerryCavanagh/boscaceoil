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
		
		public static function addbutton(x:int, y:int, w:int, text:String, action:String, textoffset:int = 0):void {
			addguipart(x, y, w, 13, text, action, "normal", textoffset);
		}
		
		public static function addlogo(x:int, y:int):void {
			addguipart(x, y, gfx.images[0].width, gfx.images[0].height, "BOSCA CEOIL", "logo", "logo");
		}
		
		public static function addtextlabel(x:int, y:int, text:String, col:int = 2):void {
			addguipart(x, y, col, 0, text, "", "textlabel");
		}
		
		public static function addrighttextlabel(x:int, y:int, text:String, col:int = 2):void {
			addguipart(x, y, col, 0, text, "", "righttextlabel");
		}
		
		public static function addrect(x:int, y:int, w:int, h:int, col:int = 1):void {
			addguipart(x, y, w, h, "", "", "fillrect", col);
		}
		
		public static function addleftarrow(x:int, y:int, action:String):void {
			addguipart(x, y, 16, 16, "", action, "leftarrow");
		}
		
		public static function addrightarrow(x:int, y:int, action:String):void {
			addguipart(x, y, 16, 16, "", action, "rightarrow");
		}
		
		public static function addplayarrow(x:int, y:int, action:String):void {
			addguipart(x, y, 16, 16, "", action, "playarrow");
		}
		
		public static function addpausebutton(x:int, y:int, action:String):void {
			addguipart(x, y, 16, 16, "", action, "pause");
		}
		
		public static function addstopbutton(x:int, y:int, action:String):void {
			addguipart(x, y, 16, 16, "", action, "stop");
		}
		
		public static function addplusbutton(x:int, y:int, action:String):void {
			addguipart(x, y, 16, 16, "", action, "plus");
		}
		
		public static function addminusbutton(x:int, y:int, action:String):void {
			addguipart(x, y, 16, 16, "", action, "minus");
		}
		
		public static function adddownarrow(x:int, y:int, action:String):void {
			addguipart(x, y, 16, 16, "", action, "downarrow");
		}
		
		public static function addvariable(x:int, y:int, variable:String, col:int = 0):void {
			addguipart(x, y, col, 0, "", variable, "variable");
		}
		
		public static function addhorizontalslider(x:int, y:int, w:int, variable:String):void {
			addguipart(x, y, w, 0, "", variable, "horizontalslider");
		}
		
		public static function addcontrol(x:int, y:int, type:String):void {
			//For complex multipart things
			if (type == "changepatternlength") {
				addrect(x, y-2, 160, 13);
				addrighttextlabel(x + 60, y, "PATTERN", 0);
				
				addleftarrow(x + 70, y , "barcountdown");
				addvariable(x + 85, y, "barcount");
				addrightarrow(x + 100, y, "barcountup");
				
				addleftarrow(x + 115, y, "boxcountdown");
				addvariable(x + 125, y, "boxcount");
				addrightarrow(x + 145, y, "boxcountup");
			}else if (type == "changebpm") {
				addrect(x, y - 2, 160, gfx.linesize+3);
				addrighttextlabel(x + 60, y, "BPM", 0);
				
				addleftarrow(x + 85, y, "bpmdown");
				addvariable(x + 100, y, "bpm");
				addrightarrow(x + 130, y, "bpmup");
			}else if (type == "changesoundbuffer") {
				addrect(x, y - 2, 160, gfx.linesize+3);
				addrighttextlabel(x + 80, y, "SOUND BUFFER ", 0);
				
				adddownarrow(x + 105, y, "bufferlist");
				addvariable(x + 120, y, "buffersize");
				addvariable(x + 4, y + gfx.linesize + 5, "buffersizealert");
			}else if (type == "swingcontrol") {
				addrect(x, y - 2, 160, gfx.linesize + 3);
				addrighttextlabel(x + 60, y, "SWING", 0);
				
				addleftarrow(x + 85, y, "swingdown");
				addvariable(x + 100, y, "swing");
				addrightarrow(x + 130, y, "swingup");
			}else if (type == "globaleffects") {
				addrect(x, y - 2, 110, gfx.linesize + 3, 6);
				adddownarrow(x - 15, y, "effectslist");
				addvariable(x - 20, y, "currenteffect");
				addhorizontalslider(x, y - 2, 100, "currenteffect");
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
			if (sty == "horizontalslider") {
				button[z].moveable = true;
			}
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
					
					if (button[i].action != "" && !control.list.active) {
						if (key.press && !control.clicklist) {
							if (button[i].moveable) {
								dobuttonmoveaction(i);
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
					}else if (button[i].style == "textlabel") {
						gfx.print(button[i].position.x, button[i].position.y, button[i].text, button[i].position.width, false, true);
					}else if (button[i].style == "righttextlabel") {
						gfx.rprint(button[i].position.x, button[i].position.y, button[i].text, button[i].position.width, true);
					}else if (button[i].style == "fillrect") {
						gfx.fillrect(button[i].position.x, button[i].position.y, button[i].position.width, button[i].position.height, button[i].textoffset);
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
						gfx.drawicon(button[i].position.x, button[i].position.y, 8);
					}else if (button[i].style == "minus") {
						gfx.drawicon(button[i].position.x, button[i].position.y, 9);
					}else if (button[i].style == "uparrow") {
						gfx.drawicon(button[i].position.x, button[i].position.y, 1);
					}else if (button[i].style == "downarrow") {
						gfx.drawicon(button[i].position.x, button[i].position.y, 0);
					}else if (button[i].style == "horizontalslider") {
						if (button[i].action == "currenteffect") {
							gfx.fillrect(button[i].position.x, button[i].position.y, 10, 13, 6);
							gfx.fillrect(button[i].position.x + 1, button[i].position.y + 1, 8, 11, 5);
							
							tx = int((control.effectvalue));
							gfx.fillrect(button[i].position.x +tx, button[i].position.y, 10, 13, 4);
							gfx.fillrect(button[i].position.x +tx + 1, button[i].position.y + 1, 8, 11, 2);
							
							gfx.fillrect(button[i].position.x +tx + 2, button[i].position.y + 4, 6, 1, 4);
							gfx.fillrect(button[i].position.x +tx + 2, button[i].position.y + 6, 6, 1, 4);
							gfx.fillrect(button[i].position.x +tx + 2, button[i].position.y + 8, 6, 1, 4);
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
							gfx.drawimage(7, tx + 3, ty + 1);
							gfx.drawimage(timage, tx, ty - 4);
							if (control.looptime % control.barcount == 1) {
								button[i].pressed--;
							}
						}else{
							if (control.looptime % control.barcount == 1) {
								gfx.drawimage(7, tx+3, ty + 5 - 4);
								gfx.drawimage(timage, tx, ty + 2 - 4);
							}else {
								gfx.drawimage(7, tx+3, ty + 5);
								gfx.drawimage(timage, tx, ty + 2);
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
			
		  switch(t) {
				case control.MENUTAB_FILE:
					addlogo(12, (gfx.linesize * 3) - 6);
					addtextlabel(165, (gfx.linesize * 5) + 4, control.versionnumber);
					
					addtextlabel(10, (gfx.linesize * 6)+5, "Created by Terry Cavanagh");
					addtextlabel(10, (gfx.linesize * 7)+5, "http://www.distractionware.com");
					
					addbutton(10, (gfx.linesize * 9), 75, "CREDITS", "creditstab");
					
					CONFIG::desktop {
						addbutton(220, gfx.linesize * 2, 75, "NEW SONG", "newsong");
						addbutton(305, gfx.linesize * 2, 75, "EXPORT", "exportlist");
						addbutton(220, (gfx.linesize * 4) + 5, 75, "LOAD .ceol", "loadceol");
						addbutton(305, (gfx.linesize * 4) + 5, 75, "SAVE .ceol", "saveceol");
					}
					
					addcontrol(220, (gfx.linesize * 7) - 1, "changepatternlength");
					addcontrol(220, (gfx.linesize * 9) - 1, "changebpm");
					
					addplayarrow(150, (gfx.linesize * 9), "play");
					addpausebutton(165, (gfx.linesize * 9), "pause");
					addstopbutton(180, (gfx.linesize * 9), "stop");
				break;
			  case control.MENUTAB_CREDITS:
				  addtextlabel(10, (gfx.linesize * 2), "SiON softsynth library by Kei Mesuda", 0);
					addrighttextlabel(384 - 10, (gfx.linesize * 2), "Online version by Chris Kim", 0);
				  addtextlabel(10, (gfx.linesize * 3), "sites.google.com/site/sioncenter/");
					addrighttextlabel(384 - 10, (gfx.linesize * 3), "dy-dx.com/");
					
					addtextlabel(10, (gfx.linesize * 5), "Swing function by Stephen Lavelle",0);
					addrighttextlabel(384-10, (gfx.linesize * 5), "XM Exporter by Rob Hunter",0);
					addtextlabel(10, (gfx.linesize * 6), "increpare.com/");
					addrighttextlabel(384 - 10, (gfx.linesize * 6), "about.me/rjhunter/");
					
					addtextlabel(10, (gfx.linesize * 8), "Linux port by Damien L",0);
					addtextlabel(10, (gfx.linesize * 9), "uncovergame.com/");
					addrighttextlabel(384-10, (gfx.linesize * 8), "Open Source under FreeBSD licence",0);
					
					addbutton(302, (gfx.linesize * 9)+4, 75, "BACK", "filetab");
				break;
			  case control.MENUTAB_ARRANGEMENTS:
				  addbutton((gfx.patterncount * 6) + 5, gfx.linesize + gfx.pianorollposition - 14, gfx.screenwidth - (gfx.patterncount * 6) - 8, "ADD NEW", "addnewpattern");
			  break;
			  case control.MENUTAB_INSTRUMENTS:
				  addbutton(5, gfx.linesize + gfx.pianorollposition - 14, 132, "ADD NEW INSTRUMENT", "addnewinstrument");
				break;
			  case control.MENUTAB_ADVANCED:
				  addcontrol(20, (gfx.linesize * 3) + 2, "changesoundbuffer");
					addcontrol(20, (gfx.linesize * 6) + 2, "swingcontrol");
					addcontrol(gfx.screenwidth - 120,  (gfx.linesize * 3)+2, "globaleffects");
				break;
			}
		}
		
		
		public static function dobuttonmoveaction(i:int):void {
			currentbutton = button[i].action;
			
			if (currentbutton == "currenteffect") {
				if (control.mx >= button[i].position.x - 5 && control.my < button[i].position.x + button[i].position.width && control.my >= button[i].position.y -4&& control.my <= button[i].position.y + (gfx.linesize) + 3  + 4) {
					var barposition:int = control.mx - (button[i].position.x + 5);
					if (barposition < 0) barposition = 0; 
					if (barposition > button[i].position.width) barposition = button[i].position.width;
					
					control.effectvalue = barposition;
					control.updateeffects();
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
				control.filllist(control.LIST_EXPORTS);
				control.list.init(gfx.screenwidth - 100, (gfx.linesize * 3) - 1);
			}else if (currentbutton == "loadceol") {
				control.loadceol();
			}else if (currentbutton == "saveceol") {
				control.saveceol();
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
			}else if (currentbutton == "boxcountup") {
				control.boxcount++;
				if (control.boxcount > 32) control.boxcount = 32;
				control.doublesize = control.boxcount > 16;
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
				control.list.init(105, (gfx.linesize * 4) - 3);
			}else if (currentbutton == "swingup") {
				control.swing ++;
				if (control.swing > 10) control.swing = 10;
			}else if (currentbutton == "swingdown") {
				control.swing --;
				if (control.swing < -10) control.swing = -10;
			}else if (currentbutton == "effectslist") {
				control.filllist(control.LIST_EFFECTS);
				control.list.init(gfx.screenwidth - 150, (gfx.linesize * 4) - 3);
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
			}
		}
		
		public static var button:Vector.<guibutton> = new Vector.<guibutton>;
		public static var numbuttons:int;
		public static var maxbuttons:int;
		
		public static var tx:int, ty:int, timage:int;
		public static var currentbutton:String;
	}
}