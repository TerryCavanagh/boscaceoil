package{
	import flash.display.*;
	import flash.geom.*;
  import flash.events.*;
  import flash.net.*;
	import flash.text.*;
	import flash.utils.Dictionary;
	CONFIG::desktop {
		import flash.display.NativeWindow;
	}
	
	public class gfx extends Sprite {
		public static function init(_stage:Stage):void {
			min_windowwidth = 768;
			min_windowheight = 400;
			updatebackground = 5;
			initgfx();
			initfont();
			initpal();
			
			stage = _stage;
    }
		
		public static function changeframerate(t:int):void {
			if (t != boscaframerate) {
				stage.frameRate = t;
				boscaframerate = t;
			}
		}
		
		
		CONFIG::web {
		public static function changescalemode(t:int):void {
		}
		}
		
		CONFIG::desktop {
		public static function changescalemode(t:int):void {
			//Set new minimum screensize
			if (t == 0) {
				min_windowwidth = 768;
				min_windowheight = 540;
				stage.nativeWindow.minSize = new Point(768 + windowboundsx, 540 + windowboundsy);
			}else {
				min_windowwidth = 1152;
				min_windowheight = 690;
				stage.nativeWindow.minSize = new Point(1152 + windowboundsx, 690 + windowboundsy);
			}
			
			scalemode = t;
			control.forceresize = true;
			control.clicklist = true; // Stops from placing a note on resize
		}
		}
		
		public static function tutorialimagewidth(t:int):int {
			return images[t + 8].width;
		}
		
		public static function tutorialimageheight(t:int):int {
			return images[t + 8].height;
		}
		
		public static function forceminimumsize():void {
			if (windowwidth < min_windowwidth && windowheight < min_windowheight) {
				changewindowsize(min_windowwidth, min_windowheight);
			}else if (windowwidth < min_windowwidth) {
				changewindowsize(min_windowwidth, windowheight);
			}else if (windowheight < min_windowheight) {
				changewindowsize(windowwidth, min_windowheight);
			}
		}
		
		public static function initpal():void {
			//Initalise all the program's palettes here
			pal[0].setto(255, 255, 255);      //Pure White
			pal[1].setto(52, 66, 70);         //Background
			pal[2].setto(188, 200, 204);      //Menu bar
			pal[3].setto(146, 163, 170);      //Bar, Bright
			pal[4].setto(109, 133, 141);      //Bar, Dark
			pal[5].setto(80, 101, 106);       //Guideline  
			pal[6].setto(52, 66, 70);         //Dark guideline
			pal[7].setto(146, 185, 196);      //Note names
			pal[8].setto(104, 0, 0);          //Note, dark part
			pal[9].setto(160, 0, 0);          //Note, bright part
			
			pal[10].setto(255, 255, 255);     //Arrangement Bar (bright)
			pal[11].setto(109, 133, 141);     //Arrangement Bar (dark)
			pal[12].setto(0, 0, 0);           //Black
			pal[13].setto(72, 0, 0);          //Dark Red
			pal[14].setto(26, 33, 35);        //Very dark grey
			pal[15].setto(255, 0, 0);         //Red
			pal[16].setto(0, 132, 255);       //Cyan
			pal[17].setto(0, 0, 140);         //Dark Blue
			pal[18].setto(255, 255, 0);       //Yellow
			pal[19].setto(222, 222, 0);       //Darker Yellow
			
			pal[20].setto(65, 82, 87);        //Background mouseover
			
			//Blue
			pal[100].setto(59, 39, 238);       //Bar, Bright
			pal[101].setto(43, 33, 151);       //Bar, Dark
			pal[102].setto(10, 14, 62);       //Guideline
			pal[103].setto(5, 7, 31);         //Dark guideline
			pal[104].setto(255,185,95);      //Note, dark part
			pal[105].setto(255,255,192);      //Note, bright part
			pal[106].setto(188,207,255);     //Octave change
			
			//Purple
			pal[110].setto(156, 11, 240);      //Bar, Bright
			pal[111].setto(91, 5, 143);      //Bar, Dark
			pal[112].setto(10, 14, 62);       //Guideline
			pal[113].setto(5, 7, 31);         //Dark guideline
			pal[114].setto(255,185,95);      //Note, dark part
			pal[115].setto(255,255,192);      //Note, bright part
			pal[116].setto(224,185,255);     //Octave change
			
			//Red
			pal[120].setto(210, 41, 58);      //Bar, Bright
			pal[121].setto(124,23,35);      //Bar, Dark
			pal[122].setto(62, 15, 10);       //Guideline
			pal[123].setto(31, 8, 5);       //Dark guideline
			pal[124].setto(255,185,95);       //Note, dark part
			pal[125].setto(255,255,192);      //Note, bright part
			pal[126].setto(244,193,201);     //Octave change
			
			//Orange
			pal[130].setto(210, 153, 41);     //Bar, Bright
			pal[131].setto(124, 90, 23);     //Bar, Dark
			pal[132].setto(62, 55, 10);       //Guideline
			pal[133].setto(30, 27, 5);       //Dark guideline
			pal[134].setto(255,185,95);       //Note, dark part
			pal[135].setto(255,255,192);      //Note, bright part
			pal[136].setto(244,224,193);      //Octave change
			
			//Green
			pal[140].setto(54, 215, 36);      //Bar, Bright
			pal[141].setto(32, 127, 20);      //Bar, Dark
			pal[142].setto(10, 62, 23);       //Guideline
			pal[143].setto(5, 30, 12);       //Dark guideline
			pal[144].setto(255,185,95);      //Note, dark part
			pal[145].setto(255,255,192);     //Note, bright part
			pal[146].setto(200,246,191);      //Octave change
			
			//Cyan
			pal[150].setto(19, 144, 232);      //Bar, Bright
			pal[151].setto(10, 86, 138);      //Bar, Dark
			pal[152].setto(10, 31, 62);       //Guideline
			pal[153].setto(5, 14, 30);       //Dark guideline
			pal[154].setto(255,185,95);      //Note, dark part
			pal[155].setto(255,255,192);     //Note, bright part
			pal[156].setto(186,227,250);     //Octave change
			
			//Grayscale
			pal[300].setto(140, 140, 140);      //Bar, Bright
			pal[301].setto(96, 96, 96);      //Bar, Dark
			pal[302].setto(31, 31, 31);       //Guideline
			pal[303].setto(14, 14, 14);       //Dark guideline
			pal[304].setto(255,185,95);       //Note, dark part
			pal[305].setto(255,255,192);    //Note, bright part
			pal[306].setto(227,227,227);     //Octave change
		}
		
		public static function updateboxsize():void {
			if (control.doublesize) {
				control.boxsize = (screenwidth - 60) / 32;
				control.barsize = control.boxsize * control.barcount;
			}else{
				control.boxsize = (screenwidth - 60) / 16;
				control.barsize = control.boxsize * control.barcount;
			}
		}
		
		public static function drawpatterneditor():void {
			//Pattern editor
			updateboxsize();
			
			//Background alternating colour rows
			for (i = 0; i < notesonscreen; i++){
				if (i % 2 == 0) {
					fillrect(0, screenheight - linesize - (i * linesize), screenwidth, linesize, 100 + (control.musicbox[control.currentbox].palette * 10));
					fillrect(0, screenheight - linesize - (i * linesize), screenwidth, 2, 103+(control.musicbox[control.currentbox].palette*10));
				}else{
					fillrect(0, screenheight - linesize - (i * linesize), screenwidth, linesize, 101 + (control.musicbox[control.currentbox].palette * 10));
					fillrect(0, screenheight - linesize - (i * linesize), screenwidth, 2, 103+(control.musicbox[control.currentbox].palette*10));
				}
			}
			
			//Draw bars
			for (i = 0; i < control.boxcount; i++) {
				fillrect(40 + (i * control.boxsize), pianorollposition + linesize, 2, (linesize * patterneditorheight), 102+(control.musicbox[control.currentbox].palette*10));
			}
			for (i = 0; i <= (control.boxcount / control.barcount) + 1; i++) {
				fillrect(40 + (i * control.barsize)+2, pianorollposition + linesize, 2,  (linesize * patterneditorheight), 103+(control.musicbox[control.currentbox].palette*10));
			}
			
			//Reduced patternsize? Just draw over it!
			if (control.doublesize) {
				if (control.boxcount < 32) {
					fillrect(42 + (control.boxcount * control.boxsize), pianorollposition + linesize, screenwidth, linesize*patterneditorheight, 103 + (control.musicbox[control.currentbox].palette * 10));
				}
			}else{
				if (control.boxcount < 16) {
					fillrect(42 + (control.boxcount * control.boxsize), pianorollposition + linesize, screenwidth, linesize*patterneditorheight, 103 + (control.musicbox[control.currentbox].palette * 10));
				}
			}
			
			//Note names
			fillrect(0, pianorollposition + linesize, 40, linesize * patterneditorheight, 4);
			if (control.notey > -1) {
				fillrect(0,  screenheight - linesize - (control.notey * linesize), 40, linesize, 6);
			}
			
			//Print note names
			j = control.instrument[control.musicbox[control.currentbox].instr].type;
			if (j >= 1) {
				//Drumkit!
				j--;
				for (i = 0; i < notesonscreen; i++) {
					if (control.musicbox[control.currentbox].start + i - 1 < control.drumkit[j].size) {
						if (control.musicbox[control.currentbox].start + i - 1 > -1) {
						  print(3, screenheight - linesize - (i * linesize), control.drumkit[j].voicename[control.musicbox[control.currentbox].start + i - 1], 0, false, true);
						}else {
							if (control.musicbox[control.currentbox].recordfilter == 1) {
								fillrect(0, screenheight - linesize - (i * linesize), screenwidth, linesize, 13);
								print(gfx.screenwidthmid - (gfx.len("! ADVANCED FILTER EDITING ON !") / 2), screenheight - linesize - (i * linesize) + 1, "! ADVANCED FILTER EDITING ON !", 15, false);
							}else{	
								fillrect(0, screenheight - linesize - (i * linesize), screenwidth, linesize, 12);
								print(gfx.screenwidthmid - (gfx.len("ADVANCED FILTER EDITING OFF") / 2), screenheight - linesize - (i * linesize) + 1, "ADVANCED FILTER EDITING OFF", 0);
							}
						}
					}
				}
			}else {
				for (i = 0; i < notesonscreen; i++) {
					if (control.musicbox[control.currentbox].start + i - 1> -1) {
					  print(3, screenheight - linesize - (i * linesize), control.notename[control.pianoroll[control.musicbox[control.currentbox].start + i - 1]], 0);
					}else {
						if (control.musicbox[control.currentbox].recordfilter == 1) {
							fillrect(0, screenheight - linesize - (i * linesize), screenwidth, linesize, 13);
							print(gfx.screenwidthmid - (gfx.len("! ADVANCED FILTER EDITING ON !") / 2), screenheight - linesize - (i * linesize) + 1, "! ADVANCED FILTER EDITING ON !", 15);
						}else{	
							fillrect(0, screenheight - linesize - (i * linesize), screenwidth, linesize, 12);
							print(gfx.screenwidthmid - (gfx.len("ADVANCED FILTER EDITING OFF") / 2), screenheight - linesize - (i * linesize) + 1, "ADVANCED FILTER EDITING OFF", 0, true);
						}
					}
				}
			}
			
			//Scroll bar
			if(control.doublesize){
				if (control.musicbox[control.currentbox].recordfilter == 1) {				
					fillrect((42 + (32 * control.boxsize)), pianorollposition + linesize, 40, linesize * patterneditorheight, 9);
				}else {
					fillrect((42 + (32 * control.boxsize)), pianorollposition + linesize, 40, linesize * patterneditorheight, 4);
				}
			}else {
				if (control.musicbox[control.currentbox].recordfilter == 1) {				
					fillrect((42 + (16 * control.boxsize)), pianorollposition + linesize, 40, linesize * patterneditorheight, 9);
				}else {
					fillrect((42 + (16 * control.boxsize)), pianorollposition + linesize, 40, linesize * patterneditorheight, 4);
				}
			}
			
			//Octave bars
			j = control.instrument[control.musicbox[control.currentbox].instr].type;
			if (j == 0) {				
				j = control.musicbox[control.currentbox].start;
				for (i = 0; i < notesonscreen; i++) {
					if ((j + i) % control.scalesize == 0) {
						fillrect(30, screenheight - linesize - (i * linesize), screenwidth, 3, 106 + (control.musicbox[control.currentbox].palette * 10));
						fillrect(30, screenheight - linesize - (i * linesize) + 3, screenwidth, 1, 107 + (control.musicbox[control.currentbox].palette * 10));
						tempstring = String(int(j + i) / control.scalesize);
						print(screenwidth - 20, screenheight - linesize - (i * linesize) + 4, tempstring, 0, false, true);
					}
				}
			}
			
			//DRAW THE NOTES HERE
			for (j = 0; j < control.musicbox[control.currentbox].numnotes; j++) {
				i = control.musicbox[control.currentbox].notes[j].width;
				if (i < control.boxcount) {
					control.drawnoteposition = control.invertpianoroll[control.musicbox[control.currentbox].notes[j].x] + 1;
					control.drawnotelength = control.musicbox[control.currentbox].notes[j].y * control.boxsize;
					if (control.drawnoteposition > -1) {			
						control.drawnoteposition -= control.musicbox[control.currentbox].start;
						if (control.drawnoteposition <= 0) {
							fillrect(42 + (i * control.boxsize), screenheight - linesize - 4, control.drawnotelength, 4, 104+(control.musicbox[control.currentbox].palette*10));
							fillrect(42 + (i * control.boxsize), screenheight - linesize - 2, control.drawnotelength, 2, 105+(control.musicbox[control.currentbox].palette*10));
							fillrect(42 + (i * control.boxsize), screenheight - linesize - 8, 2, 8, 105+(control.musicbox[control.currentbox].palette*10));
							fillrect(42 + (i * control.boxsize) + control.drawnotelength - 2, screenheight - linesize - 8, 2, 8, 105 + (control.musicbox[control.currentbox].palette * 10));
						}else if (control.drawnoteposition >= notesonscreen) {
							fillrect(42 + (i * control.boxsize), pianorollposition + linesize, control.drawnotelength, 4, 104+(control.musicbox[control.currentbox].palette*10));
							fillrect(42 + (i * control.boxsize), pianorollposition + linesize, control.drawnotelength, 2, 105+(control.musicbox[control.currentbox].palette*10));
							fillrect(42 + (i * control.boxsize), pianorollposition + linesize, 2, 8, 105+(control.musicbox[control.currentbox].palette*10));
							fillrect(42 + (i * control.boxsize) + control.drawnotelength - 2, pianorollposition + linesize, 2, 8, 105+(control.musicbox[control.currentbox].palette*10));
						}else {
							fillrect(42 + (i * control.boxsize), screenheight - linesize - (control.drawnoteposition * linesize), control.drawnotelength, linesize, 105+(control.musicbox[control.currentbox].palette*10));
							fillrect(42 + (i * control.boxsize), screenheight - linesize - (control.drawnoteposition * linesize) + 16, control.drawnotelength, 4, 104+(control.musicbox[control.currentbox].palette*10));
							fillrect(42 + (i * control.boxsize) + control.drawnotelength - 4,  screenheight - linesize - (control.drawnoteposition * linesize), 4, linesize, 104 + (control.musicbox[control.currentbox].palette * 10));
							
							tempstring = String(int(control.musicbox[control.currentbox].notes[j].y))
							if (control.doublesize) {
								if (control.musicbox[control.currentbox].notes[j].y + control.musicbox[control.currentbox].notes[j].width > 32) {
									print(42 + (i * control.boxsize), screenheight - linesize - (control.drawnoteposition * linesize), tempstring, 12);
								}
							}else {
								if (control.musicbox[control.currentbox].notes[j].y + control.musicbox[control.currentbox].notes[j].width > 16) {
									print(42 + (i * control.boxsize), screenheight - linesize - (control.drawnoteposition * linesize), tempstring, 12);
								}
							}
						}
					}
				}
			}
		}
		
		public static function drawpatterneditor_cursor():void {
			//Bar position
			control.seekposition(control.boxsize * control.looptime);
			if (control.musicbox[control.currentbox].isplayed) {
				//Only draw if this musicbox is actually being played
				fillrect(40 + control.barposition, pianorollposition + linesize, 4, linesize * patterneditorheight, 10);
				fillrect(40 + control.barposition + 4, pianorollposition + linesize, 4, linesize * patterneditorheight, 11);
			}
			
			//Draw the cursor
			if (control.cursorx > -1 && control.cursory > -1) {
				if (control.musicbox[control.currentbox].start + control.cursory - 1 == -1) {
					if (control.doublesize) {
						drawbox(40 + (4 * control.boxsize), gfx.screenheight - linesize - (control.cursory * linesize), control.boxsize * 24, linesize, 0);
					}else{
						drawbox(40 + (2 * control.boxsize), gfx.screenheight - linesize - (control.cursory * linesize), control.boxsize * 12, linesize, 0);
					}
				}else {
					if (control.cursory == notesonscreen - 1) {
						//draw partial cursor
						drawpartialbox(40 + (control.cursorx * control.boxsize), gfx.screenheight - linesize - (control.cursory * linesize), control.boxsize * control.notelength, linesize, 0, pianorollposition + linesize);
					}else {
						drawbox(40 + (control.cursorx * control.boxsize), gfx.screenheight - linesize - (control.cursory * linesize), control.boxsize * control.notelength, linesize, 0);
						if (control.notelength > control.boxcount) {
							tempstring = String(control.notelength);
							print(40 + (control.cursorx * control.boxsize), gfx.screenheight - linesize  - (control.cursory * linesize), tempstring, 0);
						}
					}
				}
			}
		}
		
		public static function drawlist():void {
			if (control.list.active) {
				//Draw list
				fillrect(control.list.x - 2, control.list.y - 2, control.list.w + 4, control.list.h + 4, 12);
				fillrect(control.list.x, control.list.y, control.list.w, control.list.h, 11);
				if (control.list.type == control.LIST_SELECTINSTRUMENT) {
					for (i = 0; i < control.list.numitems; i++) {
						fillrect(control.list.x, control.list.y + (i * linesize), control.list.w, linesize, 101 + (control.instrument[i].palette*10));
					}
					if (control.list.selection > -1) {
						fillrect(control.list.x, control.list.y + (control.list.selection * linesize), control.list.w, linesize, 100 + (control.instrument[control.list.selection].palette*10));
					}
				}else {
					for (i = 0; i < control.list.numitems; i++) {
						if (help.Left(control.list.item[i], 1) == ">" || help.Left(control.list.item[i], 1) == "<") {
							fillrect(control.list.x, control.list.y + (i * linesize), control.list.w, linesize, 0);
						}
					}
					
					if (control.list.type == control.LIST_MIDIINSTRUMENT) {
						if (control.midilistselection > -1) {
							fillrect(control.list.x, control.list.y + (control.midilistselection * linesize), control.list.w, linesize, 3);
						}
					}
					
					if (control.list.selection > -1) {
						fillrect(control.list.x, control.list.y + (control.list.selection * linesize), control.list.w, linesize, 2);
					}
				}
				
				for (i = 0; i < control.list.numitems; i++) {
					if (help.Left(control.list.item[i], 1) == ">" || help.Left(control.list.item[i], 1) == "<") {
						print(control.list.x + 2, control.list.y + (i * linesize), control.list.item[i], 14);
					}else {
						print(control.list.x + 2, control.list.y + (i * linesize), control.list.item[i], 0);
					}
				}
			}
			
			if (control.secondlist.active) {
				//Draw list
				fillrect(control.secondlist.x - 2, control.secondlist.y - 2, control.secondlist.w + 4, control.secondlist.h + 4, 12);
				fillrect(control.secondlist.x, control.secondlist.y, control.secondlist.w, control.secondlist.h, 11);
				for (i = 0; i < control.secondlist.numitems; i++) {
					if (help.Left(control.secondlist.item[i], 1) == ">" || help.Left(control.secondlist.item[i], 1) == "<") {
						fillrect(control.secondlist.x, control.secondlist.y + (i * linesize), control.secondlist.w, linesize, 0);
					}
				}
				if (control.secondlist.selection > -1) {
					fillrect(control.secondlist.x, control.secondlist.y + (control.secondlist.selection * linesize), control.secondlist.w, linesize, 2);
				}
				
				for (i = 0; i < control.secondlist.numitems; i++) {
					if (help.Left(control.secondlist.item[i], 1) == ">" || help.Left(control.secondlist.item[i], 1) == "<") {
						print(control.secondlist.x + 2, control.secondlist.y + (i * linesize), control.secondlist.item[i], 14);
					}else {
						print(control.secondlist.x + 2, control.secondlist.y + (i * linesize), control.secondlist.item[i], 0);
					}
				}
			}
			
			//Special trash button!
			if (control.trashbutton > 0) {
				fillrect(screenwidth - 100-4, screenheight - (control.trashbutton*2)-4, 108, (control.trashbutton*2)+8, 12);
				fillrect(screenwidth - 100, screenheight - (control.trashbutton*2), 100, (control.trashbutton*2), 13);
				print(screenwidth - 100 + 4, screenheight - (control.trashbutton*2), "DELETE?", 0, false, true);
			}			
		}
		
		public static function drawmusicbox(xp:int, yp:int, t:int, enabled:Boolean=true, forcezoom:int = -1):void {
			//Draw a little music box containing our notes!
			if (xp < screenwidth) {
				temppal = control.musicbox[t].palette;
				if (!enabled) temppal = 21;
				
				if (forcezoom == -1) {
					temppatternwidth = patternwidth;
					zoomoffset = zoom / 2;
				}else {
					temppatternwidth = 44 + (forcezoom * 16);
					zoomoffset = forcezoom / 2;
				}
				
				if (control.doublesize) zoomoffset = zoomoffset / 2;
				
				fillrect(xp, yp, temppatternwidth, 24, 100 + (temppal * 10));
				fillrect(xp + 44, yp + 2, temppatternwidth - 46, 20, 101 + (temppal * 10));
				for (mbj = 0; mbj < control.musicbox[t].numnotes; mbj++) {
					mbi = control.musicbox[t].notes[mbj].width;
					control.drawnoteposition = control.musicbox[t].notes[mbj].x;
					control.drawnotelength = Math.ceil(control.musicbox[t].notes[mbj].y * zoomoffset);
					if (mbi + control.musicbox[t].notes[mbj].y > control.boxcount) {
						//temppatternwidth for each bar
						control.drawnotelength = (temppatternwidth/2) - (21 + int(mbi * zoomoffset));
						control.drawnotelength += ((temppatternwidth/2) * (control.musicbox[t].notes[mbj].y - (control.boxcount - mbi)) / control.boxcount);
					}
					if (control.drawnoteposition > -1) {			
						control.drawnoteposition -= control.musicbox[t].bottomnote;
						if (control.musicbox[t].notespan > 10) {
							control.drawnoteposition = ((control.drawnoteposition * 8) / control.musicbox[t].notespan) + 2;
						}else {
							control.drawnoteposition++;
							if (control.musicbox[t].notespan < 6) {
								control.drawnoteposition += 6 - control.musicbox[t].notespan;
							}
						}
						if (control.drawnoteposition >= 1 && control.drawnoteposition < 11) {
							fillrect(xp + 42 + int((mbi*2) * zoomoffset), yp + 22 - (control.drawnoteposition*2), control.drawnotelength*2, 2, 105 + (temppal * 10));
						}
					}
				}
				
				fillrect(xp, yp, 40, 24, 101 + (temppal * 10));
				fillrect(xp, yp, 40, 16, 100 + (temppal * 10));
				
				fillrect(xp + 42, yp, 2, 24, 100 + (temppal * 10));
				fillrect(xp + temppatternwidth - 2, yp, 2, 24, 100 + (temppal * 10));
				
				if (control.currentbox == t) {
					drawbox(xp, yp, temppatternwidth, patternheight, 9);
					drawbox(xp + 2, yp + 2, temppatternwidth - 4, patternheight - 4, 12);
				}
				
				if (t + 1 < 10) {
					print(xp + 10, yp + 2, String(t + 1), 2, false, true);
				}else {
					print(xp + 4, yp + 2, String(t + 1), 2, false, true);
				}
			}
		}
		
		public static function drawarrangementeditor():void {
			for (i = 0; i < 8; i++) {
				if(control.arrange.channelon[i]){
					if (i % 2 == 0) {
						fillrect(0, linesize + (i * patternheight), screenwidth, patternheight, 4);
					}else{
						fillrect(0, linesize + (i * patternheight), screenwidth, patternheight, 5);
					}
				}else {
					fillrect(0, linesize + (i * patternheight), screenwidth, patternheight, 14);
				}
			}
			
			//Draw bars
			temp = int(screenwidth / patternwidth);
			for (i = 0; i < temp; i++) {
				fillrect((i * patternwidth), linesize, 2, pianorollposition + 10 - linesize, 6);
			}
			
			//Draw patterns
			for (k = temp; k >= 0; k--) {
				for (j = 0; j < 8; j++) {
					if (k + control.arrange.viewstart > -1) {
						if (control.arrange.bar[k + control.arrange.viewstart].channel[j] > -1) {
							drawmusicbox(k * patternwidth, linesize + (j * patternheight), control.arrange.bar[k+control.arrange.viewstart].channel[j], control.arrange.channelon[j]);
						}
					}
				}
			}
		}
		
		public static function drawarrangementcursor():void {
			//Position bar
			i = ((control.looptime * patternwidth) / control.boxcount) + ((control.arrange.currentbar - control.arrange.viewstart) * patternwidth);
			if (i < patternmanagerx) {
				fillrect(i, linesize, 4, pianorollposition, 10);
				fillrect(i + 4, linesize, 4, pianorollposition, 11);
			}
			
			if (control.mx < 20 && control.my > linesize && control.my < linesize + pianorollposition && control.arrange.viewstart > 0) {
				if (arrangementscrollleft < 20) {
					arrangementscrollleft += 4;
					if (arrangementscrollleft >= 20) arrangementscrollleft = 20;
				}
				
				fillrect(-20 + arrangementscrollleft, linesize, 20, pianorollposition, 12);
				fillrect(-20 + 2 + arrangementscrollleft, linesize + 2, 16, pianorollposition - 4, 5);
				drawicon(-20 + 4 + arrangementscrollleft, linesize + (pianorollposition / 2) - 12, 12);
			}else if (control.mx > patternmanagerx - 20 && control.mx < patternmanagerx && control.my > linesize && control.my < linesize + pianorollposition) {
				if (arrangementscrollright < 20) {
					arrangementscrollright += 4;
					if (arrangementscrollright >= 20) arrangementscrollright = 20;
				}
				
				fillrect(patternmanagerx - arrangementscrollright, linesize, 20, pianorollposition, 12);
				fillrect(patternmanagerx - arrangementscrollright + 2, linesize + 2, 16, pianorollposition - 4, 5);
				drawicon(patternmanagerx - arrangementscrollright + 5, linesize + (pianorollposition / 2) - 12, 13);
			}else {
				//Draw the cursor
				if (control.arrangecurx > -1 && control.arrangecury > -1) {
					if (control.arrangecurx == 0 && control.arrange.viewstart == -1) {
						drawbox(0, linesize, patternwidth, pianorollposition-12, 0);	
					}else {
						drawbox(control.arrangecurx * patternwidth, linesize +(control.arrangecury * patternheight), patternwidth, patternheight, 0);	
					}
				}
				
				if (arrangementscrollleft > 0) {
					arrangementscrollleft -= 4;
					if (arrangementscrollleft <= 0) arrangementscrollleft = 0;
					
					fillrect(-20 + arrangementscrollleft, linesize, 20, pianorollposition, 12);
					fillrect(-20 + 2 + arrangementscrollleft, linesize + 2, 16, pianorollposition - 4, 5);
					drawicon(-20 + 4 + arrangementscrollleft, linesize + (pianorollposition / 2) - 12, 12);
				}
				if (arrangementscrollright > 0) {
					arrangementscrollright -= 4;
					if (arrangementscrollright <= 0) arrangementscrollright = 0;
					
					fillrect(patternmanagerx - arrangementscrollright, linesize, 20, pianorollposition, 12);
					fillrect(patternmanagerx - arrangementscrollright + 2, linesize + 2, 16, pianorollposition - 4, 5);
					drawicon(patternmanagerx - arrangementscrollright + 5, linesize + (pianorollposition / 2) - 12, 13);
					drawpatternmanager();
				}
			}
		}
		
		public static function drawtimeline():void {
			//From here: TIMELINE
			fillrect(0, pianorollposition + 8, screenwidth, 12, 6);
			
			temp = int(screenwidth / patternwidth);
			for (i = 0; i < temp; i++) {
				fillrect((i * patternwidth), pianorollposition + 8, 2, 12, 14);
			}
			
			if (control.dragaction == 3) {
				for (i = 0; i < temp; i++) {
					if (i + control.arrange.viewstart == control.dragx 
					|| (i + control.arrange.viewstart >= control.dragx && i + control.arrange.viewstart < control.timelinecurx + control.arrange.viewstart + 1)
					|| (i + control.arrange.viewstart < control.dragx && i + control.arrange.viewstart >= control.timelinecurx + control.arrange.viewstart + 1)) {
						fillrect((i * patternwidth), pianorollposition + 8, patternwidth, 12, 0);
					}
				}
			}
			
			for (i = 0; i < temp; i++) {
				if (i + control.arrange.viewstart >= control.arrange.loopstart && i + control.arrange.viewstart < control.arrange.loopend) {
					if (i + control.arrange.viewstart == control.arrange.loopstart) {
						fillrect((i * patternwidth), pianorollposition+10, 4, 8, 2);
					}
					if (i + control.arrange.viewstart == control.arrange.loopend-1) {
						fillrect(((i+1) * patternwidth)-4, pianorollposition+10, 4, 8, 2);
					}
					fillrect((i * patternwidth), pianorollposition + 12, patternwidth, 4, 2);
				}
				//	if (control.arrange.bar[i+control.arrange.viewstart].channel[j] > -1) {
					//	drawmusicbox(control, i * patternwidth, linesize + (j * patternheight), control.arrange.bar[i+control.arrange.viewstart].channel[j]);
				//	}
			}
			
			if (control.arrange.viewstart == -1) {
				fillrect(0, pianorollposition + 8, patternwidth, 12, 16);
			}
		}
		
		public static function drawtimeline_cursor():void {
			//Draw the cursor
			if (control.timelinecurx > -1) {
				if (control.arrange.viewstart == -1 && control.timelinecurx == 0) {
					drawbox(0, linesize, patternwidth, pianorollposition - 12, 0);
				}else{
			    drawbox(control.timelinecurx * patternwidth,  pianorollposition + 8, patternwidth, 12, 0);
					print(control.timelinecurx * patternwidth,  pianorollposition + 8 - linesize, String(control.arrange.viewstart +control.timelinecurx + 1), 0, false, true);
				}
			}
		}
		
		public static function drawpatternmanager():void {
			//From here, PATTERN Manager
			fillrect(patternmanagerx, linesize, screenwidth - patternmanagerx, pianorollposition, 2);
			
			//List
			for (k = 0; k < 7; k++) {
				if (k==0 && control.patternmanagerview > 0 && control.numboxes > 0) {
					//Draw scrollup
					drawicon(patternmanagerx + 50, linesize + 4 + (k * patternheight), 1);
				}else if (k == 6 && k + control.patternmanagerview < control.numboxes) {
					//Draw scrolldown
					drawicon(patternmanagerx + 50, linesize + 2 + (k * patternheight), 0);
				}else {
					//Normal
					if (control.patternmanagerview + k < control.numboxes) {
				    drawmusicbox(patternmanagerx + 3, linesize + 2 + (k * patternheight), control.patternmanagerview + k, true, 4);
					}
				}
			}
		}
		
		public static function drawpatternmanager_cursor():void {
			//Draw the cursor
			if (control.patterncury > -1) {
			  drawbox(patternmanagerx + 3, linesize + 2 + (control.patterncury * patternheight), 108, patternheight, 0);
			}
		}
		
		public static function drawinstrumentlist():void {
			fillrect(0, linesize, 280, pianorollposition, 2);
			
			//List
			for (k = 0; k < 7; k++) {
				if (k==0 && control.instrumentmanagerview > 0 && control.numinstrument > 0) {
					//Draw scrollup
					drawicon(132, linesize + 8 + (k * patternheight), 1);
				}else if (k == 6 && k + control.instrumentmanagerview < control.numinstrument) {
					//Draw scrolldown
					drawicon(132, linesize + 4 + (k * patternheight), 0);
				}else {
					//Normal
					if (control.instrumentmanagerview + k < control.numinstrument) {
						fillrect(4, linesize + 4 + (k * patternheight), 272, 24, 100 + (control.instrument[control.instrumentmanagerview + k].palette * 10));
						fillrect(4+50, linesize + 4 + (k * patternheight), 272-50, 24, 101 + (control.instrument[control.instrumentmanagerview + k].palette * 10));
						print(12, linesize + 6 + (k * patternheight), String(control.instrumentmanagerview + k + 1), 0, false, true);
						print(56, linesize + 6 + (k * patternheight), control.instrument[control.instrumentmanagerview + k].name, 0, false, true);
					}
				}
			}
			//Draw the cursor
			if (control.instrumentcury > -1) {
			  drawbox(4, linesize + 4 + (control.instrumentcury * patternheight), 272, patternheight, 0);
			}
		}
		
		public static function drawinstrument():void {
			fillrect(280, linesize, screenwidth - 280, pianorollposition, 101 + (control.instrument[control.currentinstrument].palette * 10));
			print(290, linesize + 6, "INSTRUMENT " + String(control.currentinstrument + 1), 0, false, true);
			
			fillrect(286, (linesize * 2) + 6, 160, linesize, 100 + (control.instrument[control.currentinstrument].palette * 10));
			drawicon(290, (linesize * 2) + 4, 0);
			print(320, (linesize * 2) + 6, control.instrument[control.currentinstrument].category, 0, false, true);
			
			fillrect(286+180, (linesize * 2)+6, 280, linesize, 100 + (control.instrument[control.currentinstrument].palette * 10));
			drawicon(290+180, (linesize * 2) + 4, 0);
			print(320 + 180, (linesize * 2) + 6, control.instrument[control.currentinstrument].name, 0, false, true);
			
			//Filter pad and volume bar
			i = 0;
			if (control.currentbox > -1) {
				if (control.musicbox[control.currentbox].recordfilter == 1) {
					if(control.musicbox[control.currentbox].instr == control.currentinstrument){
					  i = 1;
					}
				}
			}
			if (i == 1) {
				fillrect(286, (linesize * 4), screenwidth - 348, 110, 8);
				fillrect(screenwidth - 42, (linesize * 4), 20, 110, 8);
				
				for (i = 0; i < 110; i++) {
					if (i % 4 == 0) {
						fillrect(286, (linesize * 4) + i, screenwidth - 348, 2, 12);
						fillrect(screenwidth - 42, (linesize * 4) + i, 20, 2, 12);
					}
				}
				
				print(286 + ((screenwidth - 348)/2) - (len("! RECORDING FOR PATTERN " + String(control.currentbox + 1) + "!") / 2), (linesize * 4) + 114, "! RECORDING FOR PATTERN " + String(control.currentbox + 1) + "!", 15, false, true);
				
				//Move over recording
				j = int(((256-control.musicbox[control.currentbox].volumegraph[control.looptime%control.boxcount]) * 90) / 256);
				fillrect(screenwidth - 42, (linesize * 4) + j, 20, 20, 101 + (control.instrument[control.currentinstrument].palette * 10));
				fillrect(screenwidth - 42 + 2, (linesize * 4) + j + 2, 16, 16, 100 + (control.instrument[control.currentinstrument].palette * 10));		
				
				i = int((control.musicbox[control.currentbox].cutoffgraph[control.looptime%control.boxcount] * (screenwidth - 368)) / 128);
			  j = int((control.musicbox[control.currentbox].resonancegraph[control.looptime%control.boxcount] * 90) / 9);
			  fillrect(286 + i, (linesize * 4) + j, 20, 20, 101 + (control.instrument[control.currentinstrument].palette * 10));
				fillrect(286 + i + 2, (linesize * 4) + j + 2, 16, 16, 100 + (control.instrument[control.currentinstrument].palette * 10));		
			}else {
				fillrect(286, (linesize * 4), screenwidth - 348, 110, 102 + (control.instrument[control.currentinstrument].palette * 10));
				fillrect(screenwidth - 42, (linesize * 4), 20, 110, 102 + (control.instrument[control.currentinstrument].palette * 10));
				
				for (i = 0; i < 110; i++) {
					if (i % 4 == 0) {
						fillrect(286, (linesize * 4) + i, screenwidth - 348, 2, 103 + (control.instrument[control.currentinstrument].palette * 10));
						fillrect(screenwidth - 42, (linesize * 4) + i, 20, 2, 103 + (control.instrument[control.currentinstrument].palette * 10));
					}
				}
				
				print(286 + ((screenwidth - 348)/2) - (len("LOW PASS FILTER PAD") / 2), (linesize * 4) + 114, "LOW PASS FILTER PAD", 103 + (control.instrument[control.currentinstrument].palette * 10));
				print(screenwidth - 52, (linesize * 4) + 114, "VOL", 103 + (control.instrument[control.currentinstrument].palette * 10));				
				
				//Default values
				j = 0;
				fillrect(screenwidth - 42, (linesize * 4) + j, 20, 20, 6);
				fillrect(screenwidth - 42 + 2, (linesize * 4) + j + 2, 16, 16, 5);		
				
				i = screenwidth - 368; j = 0;
				fillrect(286 + i, (linesize * 4) + j, 20, 20, 6);
				fillrect(286 + i + 2, (linesize * 4) + j + 2, 16, 16, 5);
				
				//Switches for volume/filter
				j = int((256-control.instrument[control.currentinstrument].volume) * 90 / 256);
				fillrect(screenwidth - 42, (linesize * 4) + j, 20, 20, 101 + (control.instrument[control.currentinstrument].palette * 10));
				fillrect(screenwidth - 42 + 2, (linesize * 4) + j + 2, 16, 16, 100 + (control.instrument[control.currentinstrument].palette * 10));
				
				i = int(control.instrument[control.currentinstrument].cutoff * (screenwidth - 368) / 128);
				j = int(control.instrument[control.currentinstrument].resonance * 90 / 9);
				fillrect(286 + i, (linesize * 4) + j, 20, 20, 101 + (control.instrument[control.currentinstrument].palette * 10));
				fillrect(286 + i + 2, (linesize * 4) + j + 2, 16, 16, 100 + (control.instrument[control.currentinstrument].palette * 10));
			}
		}
		
		public static function initgfx():void {
			//We initialise a few things
			linesize = 20; 
			linespacing = 20;
			buttonheight = 26; 
			patternheight = 24;
			setzoomlevel(4);
			pianorollposition = linesize * 10;
			
			fontsize.push(0); fontsize.push(0); fontsize.push(0); fontsize.push(0);		
			fontsize.push(0); fontsize.push(0); fontsize.push(0); fontsize.push(0);		
			
			fontsize[0] = 16;
			fontsize[1] = 32;
			fontsize[2] = 48;
			fontsize[3] = 64;
			fontsize[4] = 96;
			
			icons_rect = new Rectangle(0, 0, 32, 32);
			trect = new Rectangle; tpoint = new Point();
			tbuffer = new BitmapData(1, 1, true);
			ct = new ColorTransform(0, 0, 0, 1, 255, 255, 255, 1); //Set to white
			tempicon = new BitmapData(32, 32, false, 0x000000);
			
			backbuffer = new BitmapData(1, 1, false, 0x000000);
			backbuffercache = new BitmapData(1, 1, false, 0x000000);
			
			for (i = 0; i < 400; i++) {
				pal.push(new paletteclass());
			}
			
			buttonpress = 0;
			
			screen = new Bitmap(backbuffer);
			screen.x = 0;
			screen.y = 0; 
		}
		
		public static function setzoomlevel(t:int):void {
			zoom = t;
			patternwidth = 44 + (zoom * 16);
		}
		
		CONFIG::desktop {
			public static function changewindowsize(w:int, h:int):void {
				//if (w < 768) w = 768;
				//if (h < 480) h = 480;
				windowboundsx = stage.nativeWindow.bounds.width - stage.stageWidth;
				windowboundsy = stage.nativeWindow.bounds.height - stage.stageHeight;
				windowwidth = w;
				windowheight = h;
				if (control.fullscreen) {
					
				}else{
					if (stage && stage.nativeWindow) {
						stage.nativeWindow.width = w + windowboundsx;
						stage.nativeWindow.height = h + windowboundsy;
					}
				}
				
				if (gfx.scalemode == 1) {
					screenwidth = w/1.5; screenheight = h/1.5;	
				}else {
					screenwidth = w; screenheight = h;	
				}
				
				screenwidthmid = screenwidth / 2; screenheightmid = screenheight / 2;
				screenviewwidth = screenwidth; screenviewheight = screenheight;		
			}
		}

		CONFIG::web {
			public static function changewindowsize(w:int, h:int):void {
				// no-op
			}
		}

		public static function settrect(x:int, y:int, w:int, h:int):void {
			trect.x = x;
			trect.y = y;
			trect.width = w;
			trect.height = h;
		}

		public static function settpoint(x:int, y:int):void {
			tpoint.x = x;
			tpoint.y = y;
		}
		
		public static function addimage():void {
			var t:BitmapData = new BitmapData(buffer.width, buffer.height, true, 0x000000);
			t.copyPixels(buffer, new Rectangle(0, 0, buffer.width, buffer.height), tl);
			images.push(t);
		}
		
		public static function drawimage(t:int, xp:int, yp:int):void {
			settpoint(xp, yp);
			settrect(0, 0, images[t].width, images[t].height);
			backbuffer.copyPixels(images[t], trect, tpoint);
		}
		
		public static function makeiconarray():void {
			for (var i:int = 0; i < 20; i++) {
				var t:BitmapData = new BitmapData(32, 32, true, 0x000000);
				var temprect:Rectangle = new Rectangle(i * 32, 0, 32, 32);	
				t.copyPixels(buffer, temprect, tl);
				icons.push(t);
			}
		}	
		
		// Draw Primatives
		public static function drawline(x1:int, y1:int, x2:int, y2:int, col:int):void {
			if (x1 > x2) {
				drawline(x2, y1, x1, y2, col);
			}else if (y1 > y2) {
				drawline(x1, y2, x2, y1, col);
			}else {
				tempshape.graphics.clear();
				tempshape.graphics.lineStyle(1, RGB(pal[col].r, pal[col].g, pal[col].b));
				tempshape.graphics.lineTo(x2 - x1, y2 - y1);
				
				shapematrix.translate(x1, y1);
				backbuffer.draw(tempshape, shapematrix);
				shapematrix.translate(-x1, -y1);
			}
		}
		
		public static function drawpartialbox(x1:int, y1:int, w1:int, h1:int, col:int, cutoff:int):void {
			if (y1 > cutoff) {
				settrect(x1, y1, w1, 2); backbuffer.fillRect(trect, RGB(pal[col].r, pal[col].g, pal[col].b));
			}
			if (y1 + h1 - 2 > cutoff){
				settrect(x1, y1 + h1 - 2, w1, 2); backbuffer.fillRect(trect, RGB(pal[col].r, pal[col].g, pal[col].b));
			}
			if (y1 > cutoff) {
				settrect(x1, y1, 2, h1); backbuffer.fillRect(trect, RGB(pal[col].r, pal[col].g, pal[col].b));
			}else {
				settrect(x1, cutoff, 2, h1 - (cutoff - y1)); backbuffer.fillRect(trect, RGB(pal[col].r, pal[col].g, pal[col].b));
			}
			if (y1 > cutoff) {
				settrect(x1 + w1 - 2, y1, 2, h1); backbuffer.fillRect(trect, RGB(pal[col].r, pal[col].g, pal[col].b));
			}else {
				settrect(x1 + w1 - 2, cutoff, 2, h1 - (cutoff - y1)); backbuffer.fillRect(trect, RGB(pal[col].r, pal[col].g, pal[col].b));
			}
		}
		
		public static function drawbox(x1:int, y1:int, w1:int, h1:int, col:int):void {
			settrect(x1, y1, w1, 2); backbuffer.fillRect(trect, RGB(pal[col].r, pal[col].g, pal[col].b));
			settrect(x1, y1 + h1 - 2, w1, 2); backbuffer.fillRect(trect, RGB(pal[col].r, pal[col].g, pal[col].b));
			settrect(x1, y1, 2, h1); backbuffer.fillRect(trect, RGB(pal[col].r, pal[col].g, pal[col].b));
			settrect(x1 + w1 - 2, y1, 2, h1); backbuffer.fillRect(trect, RGB(pal[col].r, pal[col].g, pal[col].b));
		}
		
		public static function cls():void {
			fillrect(0, 0, 384, 240, 1);
		}
		
		public static function fillrect(x1:int, y1:int, w1:int, h1:int, t:int):void {
			settrect(x1, y1, w1, h1);
			backbuffer.fillRect(trect, RGB(pal[t].r, pal[t].g, pal[t].b));
		}
		
		public static function drawbuffericon(x:int, y:int, t:int):void {
			settpoint(x, y);
			buffer.copyPixels(icons[t], icons_rect, tpoint);
		}

		public static function drawicon(x:int, y:int, t:int):void {
			settpoint(x, y);
			backbuffer.copyPixels(icons[t], icons_rect, tpoint);
		}
		
		//Text Functions
		public static function initfont():void {			
		  tf_1.embedFonts = true;
			tf_1.defaultTextFormat = new TextFormat("FFF Aquarius Bold Condensed", fontsize[0], 0, true);
			tf_1.width = screenwidth; tf_1.height = 200;
			tf_1.antiAliasType = AntiAliasType.NORMAL;
			
		  tf_2.embedFonts = true;
			tf_2.defaultTextFormat = new TextFormat("FFF Aquarius Bold Condensed", fontsize[1], 0, true);
			tf_2.width = screenwidth; tf_2.height = 100;
			tf_2.antiAliasType = AntiAliasType.NORMAL;
			
		  tf_3.embedFonts = true;
			tf_3.defaultTextFormat = new TextFormat("FFF Aquarius Bold Condensed", fontsize[2], 0, true);
			tf_3.width = screenwidth; tf_3.height = 100;
			tf_3.antiAliasType = AntiAliasType.NORMAL;
			
		  tf_4.embedFonts = true;
			tf_4.defaultTextFormat = new TextFormat("FFF Aquarius Bold Condensed", fontsize[3], 0, true);
			tf_4.width = screenwidth; tf_4.height = 100;
			tf_4.antiAliasType = AntiAliasType.NORMAL;
			
		  tf_5.embedFonts = true;
			tf_5.defaultTextFormat = new TextFormat("FFF Aquarius Bold Condensed", fontsize[4], 0, true);
			tf_5.width = screenwidth; tf_5.height = 100;
			tf_5.antiAliasType = AntiAliasType.NORMAL;
		}

		public static function rprint(x:int, y:int, t:String, col:int, shadow:Boolean = false):void {
			x = x - len(t);
			print(x, y, t, col, false, shadow);
		}
		
		public static var cachedtextindex:Dictionary = new Dictionary;
		public static var cachedtext:Vector.<BitmapData> = new Vector.<BitmapData>;
		public static var cachedrect:Vector.<Rectangle> = new Vector.<Rectangle>;
		public static var cacheindex:int;
		public static var cachelabel:String;
		
		public static function print(x:int, y:int, t:String, col:int, cen:Boolean = false, shadow:Boolean = false):void {
			if(shadow){
				cachelabel = t + "_" + String(col) + "_shadow";
			}else {
				cachelabel = t + "_" + String(col) + "_noshadow";
			}
			if (cachedtextindex[cachelabel] == null) {
				//Cache the text
				cacheindex = cachedtext.length;
				cachedtextindex[cachelabel] = cacheindex;
				cachedtext.push(new BitmapData(len(t), 22, true, 0));
				cachedrect.push(new Rectangle(0, 0, len(t), 22));
				
				printoncache(0, 0, t, col, false, shadow);
			}
			
			cacheindex = cachedtextindex[cachelabel];
			settpoint(x, y);
			backbuffer.copyPixels(cachedtext[cacheindex], cachedrect[cacheindex], tpoint);
		}
		
		public static function printoncache(x:int, y:int, t:String, col:int, cen:Boolean = false, shadow:Boolean=false):void {
			y -= 3;
			
			tf_1.textColor = RGB(pal[col].r, pal[col].g, pal[col].b);
			tf_1.text = t;
			if (cen) x = screenwidthmid - (tf_1.textWidth / 2) + x;
			
			if (shadow) {
				shapematrix.translate(x + 1, y + 1);
				tf_1.textColor = RGB(0, 0, 0);
				cachedtext[cacheindex].draw(tf_1, shapematrix);
				
				shapematrix.translate( -x - 1, -y - 1);
			}
			
			shapematrix.translate(x, y);
			tf_1.textColor = RGB(pal[col].r, pal[col].g, pal[col].b);
			cachedtext[cacheindex].draw(tf_1, shapematrix);
			
			shapematrix.translate(-x, -y);
		}
		
		public static function normalprint(x:int, y:int, t:String, col:int, cen:Boolean = false, shadow:Boolean=false):void {
			y -= 3;
			
			tf_1.textColor = RGB(pal[col].r, pal[col].g, pal[col].b);
			tf_1.text = t;
			if (cen) x = screenwidthmid - (tf_1.textWidth / 2) + x;
			
			if (shadow) {
				shapematrix.translate(x + 1, y + 1);
				tf_1.textColor = RGB(0, 0, 0);
				backbuffer.draw(tf_1, shapematrix);
				
				shapematrix.translate( -x - 1, -y - 1);
			}
			
			shapematrix.translate(x, y);
			tf_1.textColor = RGB(pal[col].r, pal[col].g, pal[col].b);
			backbuffer.draw(tf_1, shapematrix);
			
			shapematrix.translate(-x, -y);
		}
		
		public static function len(t:String, sz:int = 1):int {
			if(sz==1){
				tf_1.text = t;
				return tf_1.textWidth;
			}else if (sz == 2) {
				tf_2.text = t;
				return tf_2.textWidth;
			}else if (sz == 3) {
				tf_3.text = t;
				return tf_3.textWidth;
			}else if (sz == 4) {
				tf_4.text = t;
				return tf_4.textWidth;
			}else if (sz == 5) {
				tf_5.text = t;
				return tf_5.textWidth;
			}
			
			tf_1.text = t;
			return tf_1.textWidth;
		}
		public static function hig(t:String, sz:int = 1):int {
			if(sz==1){
				tf_1.text = t;
				return tf_1.textHeight;
			}else if (sz == 2) {
				tf_2.text = t;
				return tf_2.textHeight;
			}else if (sz == 3) {
				tf_3.text = t;
				return tf_3.textHeight;
			}else if (sz == 4) {
				tf_4.text = t;
				return tf_4.textHeight;
			}else if (sz == 5) {
				tf_5.text = t;
				return tf_5.textHeight;
			}
			
			tf_1.text = t;
			return tf_1.textHeight;
		}

		public static function rbigprint(x:int, y:int, t:String, r:int, g:int, b:int, cen:Boolean = false, sc:Number = 2):void {
			x = x - len(t, sc);
			bigprint(x, y, t, r, g, b, cen, sc);
		}

		public static function bigprint(x:int, y:int, t:String, r:int, g:int, b:int, cen:Boolean = false, sc:Number = 2):void {
			if (r < 0) r = 0; if (g < 0) g = 0; if (b < 0) b = 0;
			if (r > 255) r = 255; if (g > 255) g = 255; if (b > 255) b = 255;
			
			y -= 3;
			
			if (sc == 2) {
				tf_2.text = t;
				if (cen) x = screenwidthmid - (tf_2.textWidth / 2);
				
				shapematrix.translate(x, y);
				tf_2.textColor = RGB(r, g, b);
				backbuffer.draw(tf_2, shapematrix);
				
				shapematrix.translate(-x, -y);
			}else if (sc == 3) {
				tf_3.text = t;
				if (cen) x = screenwidthmid - (tf_3.textWidth / 2);
				
				shapematrix.translate(x, y);
				tf_3.textColor = RGB(r, g, b);
				backbuffer.draw(tf_3, shapematrix);
				
				shapematrix.translate(-x, -y);
			}else if (sc == 4) {
				tf_4.text = t;
				if (cen) x = screenwidthmid - (tf_4.textWidth / 2);
				
				shapematrix.translate(x, y);
				tf_4.textColor = RGB(r, g, b);
				backbuffer.draw(tf_4, shapematrix);
				
				shapematrix.translate(-x, -y);
			}else if (sc == 5) {
				tf_5.textColor = RGB(r, g, b);
				tf_5.text = t;
				if (cen) x = screenwidthmid - (tf_5.textWidth / 2);
				
				shapematrix.translate(x, y);
				backbuffer.draw(tf_5, shapematrix);
				shapematrix.translate(-x, -y);
			}
		}
		
		public static function RGB(red:Number,green:Number,blue:Number):Number{
			return (blue | (green << 8) | (red << 16))
		}
		
		//Render functions
		public static function normalrender():void {
			backbuffer.unlock();
			backbuffer.lock();
		}
		
		public static function render():void {
			if (control.test) {
				settrect(0, 0, screenwidth, 10);
				backbuffer.fillRect(trect, 0x000000);
				print(5, 0, control.teststring, 2, false);
			}
			
			normalrender();
		}
		  
		public static var icons:Vector.<BitmapData> = new Vector.<BitmapData>;
		public static var ct:ColorTransform;
	  public static var icons_rect:Rectangle;
	  public static var tl:Point = new Point(0, 0);
		public static var images:Vector.<BitmapData> = new Vector.<BitmapData>;
		public static var trect:Rectangle, tpoint:Point, tbuffer:BitmapData;
		public static var i:int, j:int, k:int, l:int, mbi:int, mbj:int;
		public static var tempstring:String;
		
		public static var screenwidth:int, screenheight:int;
		public static var screenwidthmid:int, screenheightmid:int;
		public static var screenviewwidth:int, screenviewheight:int;
		public static var linesize:int, patternheight:int, patternwidth:int;
		public static var temppatternwidth:int;
		public static var patternmanagerx:int;
		public static var linespacing:int;
		public static var patterneditorheight:int;
		public static var buttonheight:int;
		public static var pianorollposition:int;
		public static var notesonscreen:int;
		
		public static var temp:int, temp2:int, temp3:int;
		public static var alphamult:uint;
		public static var stemp:String;
		public static var buffer:BitmapData;
		public static var temppal:int;
		
		public static var zoom:int, zoomoffset:Number;
		
		public static var tempicon:BitmapData;
		//Actual backgrounds
		public static var drawto:BitmapData;
		public static var backbuffer:BitmapData;
		public static var backbuffercache:BitmapData;
		public static var updatebackground:int;
		public static var screenbuffer:BitmapData;
		public static var screen:Bitmap;
		//Tempshape
		public static var tempshape:Shape = new Shape();
		public static var shapematrix:Matrix = new Matrix();
		
		[Embed(source = "graphics/font.swf", symbol = "FFF Aquarius Bold Condensed")]
		public static var ttffont:Class;
		public static var tf_1:TextField = new TextField();
		public static var tf_2:TextField = new TextField();
		public static var tf_3:TextField = new TextField();
		public static var tf_4:TextField = new TextField();
		public static var tf_5:TextField = new TextField();
		public static var fontsize:Vector.<int> = new Vector.<int>;
		
		public static var pal:Vector.<paletteclass> = new Vector.<paletteclass>;
		
		public static var buttonpress:int;
		
		public static var stage:Stage;
		
		public static var windowwidth:int, windowheight:int;
		public static var min_windowwidth:int, min_windowheight:int;
		public static var windowboundsx:int, windowboundsy:int;
		public static var scalemode:int;
		
		public static var boscaframerate:int = -1;
		
		public static var arrangementscrollleft:int = 0;
		public static var arrangementscrollright:int = 0;
	}
}