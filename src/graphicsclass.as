package{
	import flash.display.*;
	import flash.geom.*;
  import flash.events.*;
  import flash.net.*;
	
	public class graphicsclass extends gfxbaseclass {
		public function init():void {
			initgfx();
			initfont();
			initpal();
    }
		
		public function initpal():void {
			//Initalise all the program's palettes here
			pal[0].setto(255, 255, 255);      //Pure White
			pal[1].setto(64, 64, 64);         //Background
			pal[2].setto(196, 196, 196);      //Menu bar
			pal[3].setto(160, 160, 160);      //Bar, Bright
			pal[4].setto(128, 128, 128);      //Bar, Dark
			pal[5].setto(96, 96, 96);         //Guideline
			pal[6].setto(64, 64, 64);         //Dark guideline
			pal[7].setto(180, 180, 180);      //Note names
			pal[8].setto(128, 0, 0);          //Note, dark part
			pal[9].setto(196, 0, 0);          //Note, bright part
			
			pal[10].setto(255, 255, 255);     //Arrangement Bar (bright)
			pal[11].setto(128, 128, 128);     //Arrangement Bar (dark)
			pal[12].setto(0, 0, 0);           //Black
			pal[13].setto(96, 0, 0);           //Dark Red
			pal[14].setto(32, 32, 32);         //Very dark grey
			pal[15].setto(255, 0, 0);           //Red
			pal[16].setto(0, 128, 255);           //Cyan
			pal[17].setto(0, 0, 128);           //Dark Blue
			
			//Blue
			pal[100].setto(5, 84, 185);       //Bar, Bright
			pal[101].setto(7, 59, 122);       //Bar, Dark
			pal[102].setto(10, 14, 62);       //Guideline
			pal[103].setto(5, 7, 31);         //Dark guideline
			pal[104].setto(196, 66, 16);      //Note, dark part
			pal[105].setto(255,254,132);      //Note, bright part
			
			//Purple
			pal[110].setto(160, 5, 185);      //Bar, Bright
			pal[111].setto(104, 7, 122);      //Bar, Dark
			pal[112].setto(62, 10, 50);       //Guideline
			pal[113].setto(31, 5, 25);       //Dark guideline
			pal[114].setto(196, 66, 16);      //Note, dark part
			pal[115].setto(255,254,132);      //Note, bright part
			
			//Red
			pal[120].setto(185, 5, 50);      //Bar, Bright
			pal[121].setto(122,7,38);      //Bar, Dark
			pal[122].setto(62, 15, 10);       //Guideline
			pal[123].setto(31, 8, 5);       //Dark guideline
			pal[124].setto(196, 66, 16);      //Note, dark part
			pal[125].setto(255,254,132);      //Note, bright part
			
			//Orange/Yellow
			pal[130].setto(185, 101, 5);     //Bar, Bright
			pal[131].setto(122, 66, 7);     //Bar, Dark
			pal[132].setto(62, 55, 10);       //Guideline
			pal[133].setto(30, 27, 5);       //Dark guideline
			pal[134].setto(196, 66, 16);      //Note, dark part
			pal[135].setto(255, 254, 132);      //Note, bright part
			
			//Green
			pal[140].setto(20, 185, 5);      //Bar, Bright
			pal[141].setto(19, 122, 7);      //Bar, Dark
			pal[142].setto(10, 62, 23);       //Guideline
			pal[143].setto(5, 30, 12);       //Dark guideline
			pal[144].setto(196, 66, 16);      //Note, dark part
			pal[145].setto(255, 254, 132);      //Note, bright part
			
			//Cyan
			pal[150].setto(5, 140, 185);      //Bar, Bright
			pal[151].setto(7, 96, 122);      //Bar, Dark
			pal[152].setto(10, 31, 62);       //Guideline
			pal[153].setto(5, 14, 30);       //Dark guideline
			pal[154].setto(196, 66, 16);      //Note, dark part
			pal[155].setto(255,254,132);      //Note, bright part
			
			//Cyan
			pal[160].setto(5, 140, 185);      //Bar, Bright
			pal[161].setto(7, 96, 122);      //Bar, Dark
			pal[162].setto(10, 31, 62);       //Guideline
			pal[163].setto(5, 14, 30);       //Dark guideline
			pal[164].setto(196, 66, 16);      //Note, dark part
			pal[165].setto(255, 254, 132);      //Note, bright part
			
			//Grayscale
			pal[300].setto(140, 140, 140);      //Bar, Bright
			pal[301].setto(96, 96, 96);      //Bar, Dark
			pal[302].setto(31, 31, 31);       //Guideline
			pal[303].setto(14, 14, 14);       //Dark guideline
			pal[304].setto(196, 66, 16);      //Note, dark part
			pal[305].setto(255,254,132);      //Note, bright part
			
			//Darkened grayscale
			pal[310].setto(70, 70, 70);      //Bar, Bright
			pal[311].setto(48, 48, 48);      //Bar, Dark
			pal[312].setto(15, 15, 15);       //Guideline
			pal[313].setto(7, 7, 7);       //Dark guideline
			pal[314].setto(196, 66, 16);      //Note, dark part
			pal[315].setto(255,254,132);      //Note, bright part
			
		}
		
		public function drawpatterneditor(control:controlclass):void {
			//Pattern editor
			if (control.doublesize) {
				control.boxsize = (screenwidth - 30) / 32;
				control.barsize = control.boxsize * control.barcount;
			}else{
				control.boxsize = (screenwidth - 30) / 16;
				control.barsize = control.boxsize * control.barcount;
			}
			
			//Background alternating colour rows
			for (i = 0; i < 12; i++){
				if (i % 2 == 0) {
					fillrect(0, pianorollposition + linesize + (i * linesize), screenwidth, linesize, 100+(control.musicbox[control.currentbox].palette*10));
				}else{
					fillrect(0, pianorollposition + linesize + (i * linesize), screenwidth, linesize, 101+(control.musicbox[control.currentbox].palette*10));
				}
			}
			
			//Draw bars
			for (i = 0; i < control.boxcount; i++) {
				drawline(20 + (i * control.boxsize), pianorollposition + linesize, 20 + (i * control.boxsize), pianorollposition + (linesize * 13), 102+(control.musicbox[control.currentbox].palette*10));
			}
			for (i = 0; i <= (control.boxcount / control.barcount) + 1; i++) {
				drawline(20 + (i * control.barsize)+1, pianorollposition + linesize, 20 + (i * control.barsize)+1, pianorollposition + (linesize * 13), 103+(control.musicbox[control.currentbox].palette*10));
			}
			
			//Reduced patternsize? Just draw over it!
			if (control.doublesize) {
				if (control.boxcount < 32) {
					fillrect(21 + (control.boxcount * control.boxsize), pianorollposition + linesize, screenwidth, linesize*12, 103 + (control.musicbox[control.currentbox].palette * 10));
				}
			}else{
				if (control.boxcount < 16) {
					fillrect(21 + (control.boxcount * control.boxsize), pianorollposition + linesize, screenwidth, linesize*12, 103 + (control.musicbox[control.currentbox].palette * 10));
				}
			}
			
			//Note names
			fillrect(0, pianorollposition + linesize, 20, linesize * 12, 4);
			if (control.notey > -1) {
				fillrect(0, pianorollposition + linesize + (control.notey * linesize), 20, linesize, 6);
			}
			
			//Print note names
			j = control.instrument[control.musicbox[control.currentbox].instr].type;
			if (j >= 1) {
				//Drumkit!
				j--;
				for (i = 0; i < 12; i++) {
					if (control.musicbox[control.currentbox].start + i < control.drumkit[j].size) {
						if (control.musicbox[control.currentbox].start + i > -1) {
						  print(3, pianorollposition + (linesize * 12) - (i * linesize), control.drumkit[j].voicename[control.musicbox[control.currentbox].start + i], 0, false, true);
						}else {
							if (control.musicbox[control.currentbox].recordfilter == 1) {
								fillrect(0, pianorollposition + (12 * linesize), screenwidth, linesize, 13);
								print(0, pianorollposition + (linesize * 12) - (i * linesize) + 1, "! ADVANCED FILTER EDITING ON !", 15, true);
							}else{	
								fillrect(0, pianorollposition + (12 * linesize), screenwidth, linesize, 12);
								print(0, pianorollposition + (linesize * 12) - (i * linesize) + 1, "ADVANCED FILTER EDITING OFF", 0, true);
							}
						}
					}
				}
			}else{
				for (i = 0; i < 12; i++) {
					if (control.musicbox[control.currentbox].start + i > -1) {
					  print(3, pianorollposition + (linesize * 12) - (i * linesize), control.notename[control.pianoroll[control.musicbox[control.currentbox].start + i]], 0);
					}else {
						if (control.musicbox[control.currentbox].recordfilter == 1) {
							fillrect(0, pianorollposition + (12 * linesize), screenwidth, linesize, 13);
							print(0, pianorollposition + (linesize * 12) - (i * linesize) + 1, "! ADVANCED FILTER EDITING ON !", 15, true);
						}else{	
							fillrect(0, pianorollposition + (12 * linesize), screenwidth, linesize, 12);
							print(0, pianorollposition + (linesize * 12) - (i * linesize) + 1, "ADVANCED FILTER EDITING OFF", 0, true);
						}
					}
				}
			}
			
			//Scroll bar
			if (control.musicbox[control.currentbox].recordfilter == 1) {				
			  fillrect(screenwidth - 10, pianorollposition + linesize, 10, linesize * 12, 9);
			}else {
				fillrect(screenwidth - 10, pianorollposition + linesize, 10, linesize * 12, 4);
			}
			
			//Octave bars
			j = control.instrument[control.musicbox[control.currentbox].instr].type;
			if (j == 0) {
				j = control.musicbox[control.currentbox].start;
				for (i = 0; i < 12; i++) {
					if (((j - i)+12) % control.scalesize == 0) {
						fillrect(0, pianorollposition + linesize + (i * linesize), screenwidth, 2, 0);
						print(screenwidth - 10, pianorollposition + linesize + (i * linesize)+2, String(int(((j - i)+12) / control.scalesize)), 0, false, true);
					}
				}
			}
			
			//DRAW THE NOTES HERE
			for (j = 0; j < control.musicbox[control.currentbox].numnotes; j++) {
				i = control.musicbox[control.currentbox].notes[j].width;
				if(i<control.boxcount){
					control.drawnoteposition = control.invertpianoroll[control.musicbox[control.currentbox].notes[j].x];
					control.drawnotelength = control.musicbox[control.currentbox].notes[j].y * control.boxsize;
					if (control.drawnoteposition > -1) {			
						control.drawnoteposition -= control.musicbox[control.currentbox].start;
						if (control.drawnoteposition < 0) {
							fillrect(21 + (i * control.boxsize), pianorollposition + (linesize * 13) - 2, control.drawnotelength, 2, 104+(control.musicbox[control.currentbox].palette*10));
							fillrect(21 + (i * control.boxsize), pianorollposition + (linesize * 13) - 1, control.drawnotelength, 1, 105+(control.musicbox[control.currentbox].palette*10));
							fillrect(21 + (i * control.boxsize), pianorollposition + (linesize * 13) - 4, 1, 4, 105+(control.musicbox[control.currentbox].palette*10));
							fillrect(21 + (i * control.boxsize)+control.drawnotelength-1, pianorollposition + (linesize * 13) - 4, 1, 4, 105+(control.musicbox[control.currentbox].palette*10));
						}else if (control.drawnoteposition >= 12) {
							fillrect(21 + (i * control.boxsize), pianorollposition + linesize, control.drawnotelength, 2, 104+(control.musicbox[control.currentbox].palette*10));
							fillrect(21 + (i * control.boxsize), pianorollposition + linesize, control.drawnotelength, 1, 105+(control.musicbox[control.currentbox].palette*10));
							fillrect(21 + (i * control.boxsize), pianorollposition + linesize, 1, 4, 105+(control.musicbox[control.currentbox].palette*10));
							fillrect(21 + (i * control.boxsize)+control.drawnotelength-1, pianorollposition + linesize, 1, 4, 105+(control.musicbox[control.currentbox].palette*10));
						}else {
							fillrect(21 + (i * control.boxsize), pianorollposition + (linesize * 12) - (control.drawnoteposition * linesize), control.drawnotelength, linesize, 105+(control.musicbox[control.currentbox].palette*10));
							fillrect(21 + (i * control.boxsize), pianorollposition + (linesize * 12) - (control.drawnoteposition * linesize) + 8, control.drawnotelength, 2, 104+(control.musicbox[control.currentbox].palette*10));
							fillrect(21 + (i * control.boxsize) + control.drawnotelength - 2, pianorollposition + (linesize * 12) - (control.drawnoteposition * linesize), 2, linesize, 104 + (control.musicbox[control.currentbox].palette * 10));
							
							if (control.doublesize) {
								if (control.musicbox[control.currentbox].notes[j].y + control.musicbox[control.currentbox].notes[j].width > 32) {
									print(21 + (i * control.boxsize), pianorollposition + (linesize * 12) - (control.drawnoteposition * linesize), String(int(control.musicbox[control.currentbox].notes[j].y)), 12);
								}
							}else {
								if (control.musicbox[control.currentbox].notes[j].y + control.musicbox[control.currentbox].notes[j].width > 16) {
									print(21 + (i * control.boxsize), pianorollposition + (linesize * 12) - (control.drawnoteposition * linesize), String(int(control.musicbox[control.currentbox].notes[j].y)), 12);
								}
							}
						}
					}
				}
			}
			
			//Bar position
			control.seekposition(control.boxsize * control.looptime);
			if (control.musicbox[control.currentbox].isplayed) {
				//Only draw if this musicbox is actually being played
				fillrect(20 + control.barposition, pianorollposition + linesize, 2, linesize * 12, 10);
				fillrect(20 + control.barposition + 2, pianorollposition + linesize, 2, linesize * 12, 11);
			}
			
			//Draw the cursor
			if (control.cursorx > -1 && control.cursory > -1) {
				if (control.musicbox[control.currentbox].start + (11 - control.cursory) == -1) {
					drawbox(20 + (2 * control.boxsize), pianorollposition + linesize +(control.cursory * linesize), control.boxsize * 12, linesize, 0);
				}else{
					drawbox(20 + (control.cursorx * control.boxsize), pianorollposition + linesize +(control.cursory * linesize), control.boxsize * control.notelength, linesize, 0);
					if (control.notelength > control.boxcount) {
						print(20 + (control.cursorx * control.boxsize), pianorollposition + linesize +(control.cursory * linesize) - linesize, String(control.notelength), 0);
					}
				}
			}
			
			//Menu bar
			fillrect(0, (linesize*23), screenwidth, linesize, 4);
			
			//Instrument
			fillrect(5, (linesize * 23), 140, linesize, 1);
			drawicon(10, (linesize*23) + 2, 1);
			print(24, (linesize * 23), String(control.musicbox[control.currentbox].instr+1) + "  " + control.instrument[control.musicbox[control.currentbox].instr].name, 0, false, true);
			
			
			if (control.instrument[control.musicbox[control.currentbox].instr].type == 0) {
				//Not a drumkit, so show key/scale controls
				//Key
				fillrect(160, (linesize * 23), 40, linesize, 1);
				drawicon(165, (linesize*23) + 2, 1);
				print(179, (linesize * 23), control.notename[control.key], 0, false, true);
				
				//Scale
				fillrect(215, (linesize * 23), screenwidth-230, linesize, 1);
				drawicon(220, (linesize * 23) + 2, 1);
				print(234, (linesize * 23), control.scalename[control.currentscale], 0, false, true);
			}
		}
		
		public function drawlist(control:controlclass):void {
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
				}else{
					if (control.list.item[control.list.numitems - 1] == ">> Next Page") {
						fillrect(control.list.x, control.list.y + ((control.list.numitems - 1) * linesize), control.list.w, linesize, 0);
					}else if (control.list.item[control.list.numitems - 1] == "<< First Page") {
						fillrect(control.list.x, control.list.y + ((control.list.numitems - 1) * linesize), control.list.w, linesize, 0);
					}				
					if (control.list.selection > -1) {
						fillrect(control.list.x, control.list.y + (control.list.selection * linesize), control.list.w, linesize, 2);
					}
				}
				
				for (i = 0; i < control.list.numitems; i++) {
					if (control.list.item[i] == ">> Next Page" || control.list.item[i] == "<< First Page") {
						print(control.list.x + 2, control.list.y + (i * linesize), control.list.item[i], 14);
					}else {
						print(control.list.x + 2, control.list.y + (i * linesize), control.list.item[i], 0);
					}
				}
			}
			
			//Special trash button!
			if (control.trashbutton > 0) {
				fillrect(screenwidth - 50-2, screenheight - control.trashbutton-2, 54, control.trashbutton+4, 12);
				fillrect(screenwidth - 50, screenheight - control.trashbutton, 50, control.trashbutton, 13);
				print(screenwidth - 50 + 2, screenheight - control.trashbutton, "DELETE?", 0, false, true);
			}			
		}
		
		public function drawmusicbox(control:controlclass, xp:int, yp:int, t:int, enabled:Boolean=true):void {
			//Draw a little music box containing our notes!
			if (xp < screenwidth) {
				temppal = control.musicbox[t].palette;
				if (!enabled) temppal = 21;
				
				zoomoffset = zoom / 2;
				if (control.doublesize) zoomoffset = zoomoffset / 2;
				
				fillrect(xp, yp, patternwidth, 12, 100 + (temppal * 10));
				fillrect(xp+22, yp+1, patternwidth - 23, 10, 101 + (temppal * 10));
				for (mbj = 0; mbj < control.musicbox[t].numnotes; mbj++) {
					mbi = control.musicbox[t].notes[mbj].width;
					control.drawnoteposition = control.musicbox[t].notes[mbj].x;
					control.drawnotelength = Math.ceil(control.musicbox[t].notes[mbj].y * zoomoffset);
					if (mbi + control.musicbox[t].notes[mbj].y > control.boxcount) {
						//patternwidth for each bar
						control.drawnotelength = patternwidth - (21 + int(mbi * zoomoffset));
						control.drawnotelength += (patternwidth * (control.musicbox[t].notes[mbj].y - (control.boxcount - mbi)) / control.boxcount);
					}
					if (control.drawnoteposition > -1) {			
						control.drawnoteposition -= control.musicbox[t].bottomnote;
						if(control.musicbox[t].notespan>10){
							control.drawnoteposition = ((control.drawnoteposition * 8) / control.musicbox[t].notespan) + 2;
						}else {
							control.drawnoteposition++;
							if (control.musicbox[t].notespan < 6) {
								control.drawnoteposition += 6 - control.musicbox[t].notespan;
							}
						}
						if (control.drawnoteposition >= 1 && control.drawnoteposition < 11) {
							fillrect(xp + 21 + int(mbi * zoomoffset), yp + 11 - control.drawnoteposition, control.drawnotelength, 1, 105 + (temppal * 10));
						}
					}
				}
				
				fillrect(xp, yp, 20, 12, 101 + (temppal * 10));
				fillrect(xp, yp, 20, 8, 100 + (temppal * 10));
				
				fillrect(xp + 21, yp, 1, 12, 100 + (temppal * 10));
				fillrect(xp + patternwidth - 1, yp, 1, 12, 100 + (temppal * 10));
				
				if (control.currentbox == t) {
					drawbox(xp, yp, patternwidth, patternheight, 9);
					drawbox(xp + 1, yp + 1, patternwidth - 2, patternheight - 2, 12);
				}
				
				if (t + 1 < 10) {
					print(xp + 5, yp + 1, String(t + 1), 2, false, true);
				}else {
					print(xp + 2, yp + 1, String(t + 1), 2, false, true);
				}
			}
		}
		
		public function drawarrangementeditor(control:controlclass):void {
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
			for (i = 0; i < 12; i++) {
				drawline((i * patternwidth), linesize, i * patternwidth, pianorollposition+5, 6);
			}
			
			//Draw patterns
			for (k = 12; k >= 0; k--) {
				for (j = 0; j < 8; j++) {
					if (k + control.arrange.viewstart > -1) {
						if (control.arrange.bar[k + control.arrange.viewstart].channel[j] > -1) {
							drawmusicbox(control, k * patternwidth, linesize + (j * patternheight), control.arrange.bar[k+control.arrange.viewstart].channel[j], control.arrange.channelon[j]);
						}
					}
				}
			}
			
			//Position bar
			i = ((control.looptime * patternwidth) / control.boxcount) + ((control.arrange.currentbar-control.arrange.viewstart) * patternwidth);
			fillrect(i, linesize, 2, pianorollposition, 10);
			fillrect(i + 2, linesize, 2, pianorollposition, 11);
			
			//Draw the cursor
			if (control.arrangecurx > -1 && control.arrangecury > -1) {
				if (control.arrangecurx == 0 && control.arrange.viewstart == -1) {
					/* not using this anymore
					if(control.mx<patternwidth/2){
					  drawbox(0, linesize +(control.arrangecury * patternheight), patternwidth / 2, patternheight, 0);
					}else {
						drawbox(patternwidth/2, linesize +(control.arrangecury * patternheight), patternwidth / 2, patternheight, 0);
					}*/
					drawbox(0, linesize, patternwidth, pianorollposition-6, 0);	
				}else {
				  drawbox(control.arrangecurx * patternwidth, linesize +(control.arrangecury * patternheight), patternwidth, patternheight, 0);	
				}
			}
			
		}
		
		public function drawtimeline(control:controlclass):void {
			//From here: TIMELINE
			fillrect(0, pianorollposition + 4, patterncount * 6, 6, 6);
			for (i = 0; i < 13; i++) {
				drawline((i * patternwidth), pianorollposition+4, i * patternwidth, pianorollposition+10, 14);
			}
			
			if (control.dragaction == 3) {
				for (i = 0; i < 13; i++) {
					if (i + control.arrange.viewstart == control.dragx 
					|| (i + control.arrange.viewstart >= control.dragx && i + control.arrange.viewstart < control.timelinecurx + control.arrange.viewstart + 1)
					|| (i + control.arrange.viewstart < control.dragx && i + control.arrange.viewstart >= control.timelinecurx + control.arrange.viewstart + 1)) {
						fillrect((i * patternwidth), pianorollposition + 4, patternwidth, 6, 0);
					}
				}
			}
			
			for (i = 0; i < 13; i++) {
				if (i + control.arrange.viewstart >= control.arrange.loopstart && i + control.arrange.viewstart < control.arrange.loopend) {
					if (i + control.arrange.viewstart == control.arrange.loopstart) {
						fillrect((i * patternwidth), pianorollposition+5, 2, 4, 2);
					}
					if (i + control.arrange.viewstart == control.arrange.loopend-1) {
						fillrect(((i+1) * patternwidth)-2, pianorollposition+5, 2, 4, 2);
					}
					fillrect((i * patternwidth), pianorollposition + 6, patternwidth, 2, 2);
				}
				//	if (control.arrange.bar[i+control.arrange.viewstart].channel[j] > -1) {
					//	drawmusicbox(control, i * patternwidth, linesize + (j * patternheight), control.arrange.bar[i+control.arrange.viewstart].channel[j]);
				//	}
			}
			
			if (control.arrange.viewstart == -1) {
				fillrect(0, pianorollposition + 4, patternwidth, 6, 16);
			}
			
			//Draw the cursor
			if (control.timelinecurx > -1) {
				if (control.arrange.viewstart == -1 && control.timelinecurx == 0) {
					drawbox(0, linesize, patternwidth, pianorollposition-6, 0);
				}else{
			    drawbox(control.timelinecurx * patternwidth,  pianorollposition + 4, patternwidth, 6, 0);
					print(control.timelinecurx * patternwidth,  pianorollposition + 4 - linesize, String(control.arrange.viewstart +control.timelinecurx + 1), 0, false, true);
				}
			}
		}
		
		public function drawmenu(control:controlclass):void {
			bigprint(12, (linesize * 2) + 2 - 5, "BOSCA CEOIL", 0, 0, 0, false, 3);
			if (control.looptime % control.barcount==1) {
				bigprint(10-2+(Math.random()*4), linesize*2-5-6+(Math.random()*4), "BOSCA CEOIL", 255 - (help.glow*4), 255 - help.glow, 64 + (help.glow*2), false, 3);
			}else{
			  bigprint(10, linesize * 2 - 5, "BOSCA CEOIL", 255 - (help.glow * 4), 255 - help.glow, 64 + (help.glow * 2), false, 3);
			}
			print(165, (linesize * 4)+4, "v1.1", 2, false, true);
			
			
			print(10, (linesize * 5)+5, "Created by Terry Cavanagh", 2, false, true);
			print(10, (linesize * 6)+5, "SiON softsynth library by Kei Mesuda", 2, false, true);
			print(10, (linesize * 7)+5, "Distributed under FreeBSD licence", 2, false, true);
      print(10, (linesize * 9) + 5, "http://www.distractionware.com", 2, false, true);
			
			//Button
			fillrect(220, linesize * 2, 75, 10, 12);
			fillrect(220 -2, (linesize * 2) -2, 75, 10, 1);
			print(220 + 7, (linesize * 2) - 1, "NEW SONG", 0, false, true);
			
			fillrect(305, linesize * 2, 75, 10, 12);
			fillrect(305 -2, (linesize * 2) -2, 75, 10, 1);
			print(305 + 2, (linesize * 2) - 1, "EXPORT .wav", 0, false, true);
			
			fillrect(220, (linesize * 4)+5, 75, 10, 12);
			fillrect(220 -2, (linesize * 4)+5 -2, 75, 10, 1);
			print(220 + 7, (linesize * 4)+5 - 1, "LOAD .ceol", 0, false, true);
			
			fillrect(305, (linesize * 4)+5, 75, 10, 12);
			fillrect(305 -2, (linesize * 4)+5 -2, 75, 10, 1);
			print(305 + 7, (linesize * 4)+5 - 1, "SAVE .ceol", 0, false, true);
			
			fillrect(220, (linesize * 7)-1, 160, linesize, 1);
			rprint(280, (linesize * 7) - 1, "PATTERN", 0, true);
		  drawicon(290, (linesize * 7)-1, 3);
			print(305, (linesize * 7) - 1, String(control.barcount), 0, false, true);
			drawicon(320, (linesize * 7) - 1, 2);
			drawicon(335, (linesize * 7)-1, 3);
			print(345, (linesize * 7) - 1, String(control.boxcount), 0, false, true);
			drawicon(365, (linesize * 7)-1, 2);
			
			fillrect(220, (linesize * 9)-1, 160, linesize, 1);
			rprint(280, (linesize * 9) - 1, "BPM", 0, true);
			drawicon(305, (linesize * 9)-1, 3);
			print(320, (linesize * 9) - 1, String(control.bpm), 0, false, true);
			drawicon(350, (linesize * 9)-1, 2);
		}
		
		public function drawadvancedmenu(control:controlclass):void {
			fillrect(20, (linesize * 3)+2, 160, linesize, 1);
			rprint(100, (linesize * 3) +2, "SOUND BUFFER ", 0, true);
			drawicon(125, (linesize * 3) + 2, 0);
			print(140, (linesize * 3) +2, String(control.buffersize), 0, false, true);
			
			if (control.buffersize != control.currentbuffersize) {
			  if (help.slowsine >= 32) {
				  print(24, (linesize * 4) + 7, "REQUIRES RESTART", 0);
				}else {
				  print(24, (linesize * 4) + 7, "REQUIRES RESTART", 15);
				}
			}
			
			fillrect(20, (linesize * 6) + 2, 160, linesize, 1);
      rprint(80, (linesize * 6) + 2, "SWING", 0, true);
      drawicon(105, (linesize * 6) + 2, 3);
			if(control.swing==-10){
        print(120, (linesize * 6) + 2, String(control.swing), 0, false, true);
			}else if (control.swing < 0 || control.swing == 10 ) {
				print(125, (linesize * 6) + 2, String(control.swing), 0, false, true);
			}else{
				print(130, (linesize * 6) + 2, String(control.swing), 0, false, true);
			}
      drawicon(150, (linesize * 6) + 2, 2);
			print(24, (linesize * 7) + 7, "Swing function by @increpare", 2);
			
			//Switches for global controls!
			fillrect(screenwidth - 120, (linesize * 3)+2, 110, 10, 6);
      drawicon(screenwidth - 135, (linesize * 3) + 2, 0);
      rprint(screenwidth - 140, (linesize * 3) + 2, control.effectname[control.effecttype], 0, true);
				
			j = 0;
			fillrect(screenwidth - 120 +j, (linesize * 3) + 2, 10, 10, 6);
			fillrect(screenwidth - 120 +j+ 1, (linesize * 3) + 2 + 1, 8, 8, 5);		
				
			j = int((control.effectvalue));
			fillrect(screenwidth - 120 +j, (linesize * 3) + 2, 10, 10, 1);
			fillrect(screenwidth - 120 +j + 1, (linesize * 3) + 2 + 1, 8, 8, 2);
		}
		
		public function drawpatternmanager(control:controlclass):void {
			//From here, PATTERN Manager
			patterncount = 54;
			fillrect(patterncount * 6, linesize, screenwidth - (patterncount * 6), pianorollposition, 2);
			
			//Button
			fillrect((patterncount * 6) + 5, linesize + pianorollposition - 14 + 4, screenwidth - (patterncount * 6) - 8, 10, 12);
			if (buttonpress > 0) {
				fillrect((patterncount * 6) + 5, linesize + pianorollposition - 14+4, screenwidth - (patterncount * 6) - 8, 10, 1);
				print((patterncount * 6) + 9, linesize + pianorollposition - 14 + 4, "ADD NEW", 0, false, true);
			}else {
				fillrect((patterncount * 6) + 5-2, linesize + pianorollposition - 14+2, screenwidth - (patterncount * 6) - 8, 10, 1);
				print((patterncount * 6) + 7, linesize + pianorollposition - 14 + 2, "ADD NEW", 0, false, true);
			}
			
			//List
			for (k = 0; k < 7; k++) {
				if (k==0 && control.patternmanagerview > 0 && control.numboxes > 0) {
					//Draw scrollup
					drawicon((patterncount * 6) + 26, linesize + 4 + (k * patternheight), 1);
				}else if (k == 6 && k + control.patternmanagerview < control.numboxes) {
					//Draw scrolldown
					drawicon((patterncount * 6) + 26, linesize + 2 + (k * patternheight), 0);
				}else {
					//Normal
					if (control.patternmanagerview + k < control.numboxes) {
				    drawmusicbox(control, (patterncount * 6) + 3, linesize + 2 + (k * patternheight), control.patternmanagerview + k);
					}
				}
			}
			
			//Draw the cursor
			if (control.patterncury > -1) {
			  drawbox((patterncount * 6) + 3, linesize + 2 + (control.patterncury * patternheight), patterncount, patternheight, 0);
			}
		}
		
		public function drawinstrumentlist(control:controlclass):void {
			fillrect(0, linesize, 140, pianorollposition, 2);
			
			//Button
			fillrect(5, linesize + pianorollposition - 14 + 4, 140 - 8, 10, 12);
			if (buttonpress > 0) {
				fillrect(5, linesize + pianorollposition - 14+4, 140 - 8, 10, 1);
				print(9+8, linesize + pianorollposition - 14 + 4, "ADD NEW INSTRUMENT", 0, false, true);
			}else {
				fillrect(5-2, linesize + pianorollposition - 14+2, 140 - 8, 10, 1);
				print(7+8, linesize + pianorollposition - 14 + 2, "ADD NEW INSTRUMENT", 0, false, true);
			}
			
			//List
			for (k = 0; k < 7; k++) {
				if (k==0 && control.instrumentmanagerview > 0 && control.numinstrument > 0) {
					//Draw scrollup
					drawicon(66, linesize + 4 + (k * patternheight), 1);
				}else if (k == 6 && k + control.instrumentmanagerview < control.numinstrument) {
					//Draw scrolldown
					drawicon(66, linesize + 2 + (k * patternheight), 0);
				}else {
					//Normal
					if (control.instrumentmanagerview + k < control.numinstrument) {
						fillrect(2, linesize + 2 + (k * patternheight), 136, 12, 100 + (control.instrument[control.instrumentmanagerview + k].palette * 10));
						fillrect(2+25, linesize + 2 + (k * patternheight), 136-25, 12, 101 + (control.instrument[control.instrumentmanagerview + k].palette * 10));
						print(6, linesize + 3 + (k * patternheight), String(control.instrumentmanagerview + k + 1), 0, false, true);
						print(28, linesize + 3 + (k * patternheight), control.instrument[control.instrumentmanagerview + k].name, 0, false, true);
					}
				}
			}
			//Draw the cursor
			if (control.instrumentcury > -1) {
			  drawbox(2, linesize + 2 + (control.instrumentcury * patternheight), 136, patternheight, 0);
			}
		}
		
		public function drawinstrument(control:controlclass):void {
			fillrect(140, linesize, screenwidth - 140, pianorollposition, 101 + (control.instrument[control.currentinstrument].palette * 10));
			print(145, linesize + 3, "INSTRUMENT " + String(control.currentinstrument + 1), 0, false, true);
			
			fillrect(143, (linesize * 2)+3, 80, linesize, 100 + (control.instrument[control.currentinstrument].palette * 10));
			drawicon(145, (linesize*2) + 2, 0);
			print(160, (linesize * 2) + 3, control.instrument[control.currentinstrument].category, 0, false, true);
			
			fillrect(143+90, (linesize * 2)+3, 140, linesize, 100 + (control.instrument[control.currentinstrument].palette * 10));
			drawicon(145+90, (linesize*2) + 2, 0);
			print(160 + 90, (linesize * 2) + 3, control.instrument[control.currentinstrument].name, 0, false, true);
			
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
				fillrect(143, (linesize * 4), screenwidth - 174, 55, 8);
				fillrect(screenwidth - 21, (linesize * 4), 10, 55, 8);
				
				for (i = 0; i < 55; i++) {
					if (i % 2 == 0) {
						drawline(143, (linesize * 4) + i, screenwidth - 31, (linesize * 4) + i, 12);
						drawline(screenwidth - 21, (linesize * 4) + i, screenwidth - 11, (linesize * 4) + i, 12);
					}
				}
				if ((help.slowsine % 32) < 16) {
				  print(143 + 40, (linesize * 4) + 57, "! RECORDING FOR PATTERN " + String(control.currentbox + 1) + "!", 15, false, true);
				}
				
				//Move over recording
				j = int(((256-control.musicbox[control.currentbox].volumegraph[control.looptime%control.boxcount]) * 45) / 256);
				fillrect(screenwidth - 21, (linesize * 4) + j, 10, 10, 101 + (control.instrument[control.currentinstrument].palette * 10));
				fillrect(screenwidth - 21 + 1, (linesize * 4) + j + 1, 8, 8, 100 + (control.instrument[control.currentinstrument].palette * 10));		
				
				i = int((control.musicbox[control.currentbox].cutoffgraph[control.looptime%control.boxcount] * 200) / 128);
			  j = int((control.musicbox[control.currentbox].resonancegraph[control.looptime%control.boxcount] * 45) / 9);
			  fillrect(143 + i, (linesize * 4) + j, 10, 10, 101 + (control.instrument[control.currentinstrument].palette * 10));
				fillrect(143 + i + 1, (linesize * 4) + j + 1, 8, 8, 100 + (control.instrument[control.currentinstrument].palette * 10));		
			}else {
				fillrect(143, (linesize * 4), screenwidth - 174, 55, 102 + (control.instrument[control.currentinstrument].palette * 10));
				fillrect(screenwidth - 21, (linesize * 4), 10, 55, 102 + (control.instrument[control.currentinstrument].palette * 10));
			
				for (i = 0; i < 55; i++) {
					if (i % 2 == 0) {
						drawline(143, (linesize * 4) + i, screenwidth - 31, (linesize * 4) + i, 103 + (control.instrument[control.currentinstrument].palette * 10));
						drawline(screenwidth - 21, (linesize * 4) + i, screenwidth - 11, (linesize * 4)+i, 103 + (control.instrument[control.currentinstrument].palette * 10));
					}
				}
				
				print(143 + 50, (linesize * 4) + 57, "LOW PASS FILTER PAD", 103 + (control.instrument[control.currentinstrument].palette * 10));
			  print(screenwidth - 26, (linesize * 4) + 57, "VOL", 103 + (control.instrument[control.currentinstrument].palette * 10));				
				
				//Default values
				j = 0;
				fillrect(screenwidth - 21, (linesize * 4) + j, 10, 10, 6);
				fillrect(screenwidth - 21 + 1, (linesize * 4) + j + 1, 8, 8, 5);		
				
				i = 200;j = 0;
				fillrect(143 + i, (linesize * 4) + j, 10, 10, 6);
				fillrect(143 + i + 1, (linesize * 4) + j + 1, 8, 8, 5);
			
				//Switches for volume/filter
				j = int((256-control.instrument[control.currentinstrument].volume) * 45 / 256);
				fillrect(screenwidth - 21, (linesize * 4) + j, 10, 10, 101 + (control.instrument[control.currentinstrument].palette * 10));
				fillrect(screenwidth - 21 + 1, (linesize * 4) + j + 1, 8, 8, 100 + (control.instrument[control.currentinstrument].palette * 10));
				
				i = int(control.instrument[control.currentinstrument].cutoff*200/128);
				j = int(control.instrument[control.currentinstrument].resonance * 45 / 9);
				fillrect(143 + i, (linesize * 4) + j, 10, 10, 101 + (control.instrument[control.currentinstrument].palette * 10));
				fillrect(143 + i + 1, (linesize * 4) + j + 1, 8, 8, 100 + (control.instrument[control.currentinstrument].palette * 10));
			}
		}
	}
}