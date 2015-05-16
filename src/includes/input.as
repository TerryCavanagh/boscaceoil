public function input(key:KeyPoll):void {
	var i:int, j:int, k:int;
	
	generickeypoll();
	if (control.fixmouseclicks) {
		control.fixmouseclicks = false;
		key.releaseall();
	}
	
	control.cursorx = -1; control.cursory = -1; control.notey = -1;
	control.instrumentcury = -1;
	control.arrangecurx = -1; control.arrangecury = -1;
	control.patterncury = -1; control.timelinecurx = -1;
	control.list.selection = -1;
	
	if(control.clicklist){
	  if (!key.press) {
			control.clicklist = false;
		}
	}
	
	guiclass.checkinput(key);
	
	if (control.list.active){
		if(control.mx > control.list.x && control.mx < control.list.x + control.list.w && control.my > control.list.y && control.my < control.list.y + control.list.h) {
			control.list.selection = control.my - control.list.y;
			control.list.selection = (control.list.selection - (control.list.selection % gfx.linesize)) / gfx.linesize;
		}
	}else {
		if (control.mx > 20 && control.mx < gfx.screenwidth - 12) {
			if (control.my > gfx.pianorollposition + gfx.linesize && control.my < gfx.pianorollposition + (gfx.linesize * 13)) {
				control.cursorx = (control.mx - 20);
				control.cursorx = (control.cursorx - (control.cursorx % control.boxsize)) / control.boxsize;
				control.cursory = (control.my - gfx.linesize - gfx.pianorollposition);
				control.cursory = (control.cursory - (control.cursory % gfx.linesize)) / gfx.linesize;
				
				if (control.cursorx >= control.boxcount) control.cursorx = control.boxcount - 1;
			}
		}else if (control.mx <= 20) {
			if (control.my > gfx.pianorollposition + gfx.linesize && control.my < gfx.pianorollposition + (gfx.linesize * 13)) {
				control.notey = (control.my - gfx.linesize - gfx.pianorollposition);
				control.notey = (control.notey - (control.notey % gfx.linesize)) / gfx.linesize;
			}
		}
		
		if (control.my > gfx.linesize && control.my < gfx.pianorollposition + 10) {
			if (control.currenttab == control.MENUTAB_ARRANGEMENTS) {
				//Priority: Timeline, Pattern manager, arrangements
				if (control.mx > (gfx.patterncount * 6)) {
					//Pattern Manager
					control.patterncury = control.my - gfx.linesize - 2;
					control.patterncury = (control.patterncury - (control.patterncury % gfx.patternheight)) / gfx.patternheight;
					if (control.patterncury > 6) control.patterncury = -1;
				}else if (control.my >= gfx.pianorollposition + 4 || control.dragaction == 3) {
					//Timeline
					control.timelinecurx = control.mx;
					control.timelinecurx = (control.timelinecurx - (control.timelinecurx % gfx.patternwidth)) / gfx.patternwidth;
				}else{
					//Arrangements
					control.arrangecurx = control.mx;
					control.arrangecurx = (control.arrangecurx - (control.arrangecurx % gfx.patternwidth)) / gfx.patternwidth;
					control.arrangecury = (control.my - gfx.linesize);
					control.arrangecury = (control.arrangecury - (control.arrangecury % gfx.patternheight)) / gfx.patternheight;
					if (control.arrangecury > 7) control.arrangecury = 7;
				}
			}else if (control.currenttab == control.MENUTAB_INSTRUMENTS) {
				if (control.mx < 140) {
					control.instrumentcury = control.my - gfx.linesize;
					control.instrumentcury = (control.instrumentcury - (control.instrumentcury % gfx.patternheight)) / gfx.patternheight;
					if (control.instrumentcury > 6) control.instrumentcury = -1;
				}
			}
		}
	}
	
	if (control.copykeyheld) {
		if (!key.isDown(Keyboard.C) && !key.isDown(Keyboard.V)) {
			control.copykeyheld = false;
		}
	}
	
	if (control.timelinecurx > -1) {
		if (key.ctrlheld && !control.copykeyheld) {
		  if (key.isDown(Keyboard.V)) {
				control.copykeyheld = true;
				control.arrange.paste(control.arrange.viewstart + control.timelinecurx);
			}
		}
	}
	
	if (key.ctrlheld && !control.copykeyheld) {
		if (key.isDown(Keyboard.C)) {
			control.copykeyheld = true;
			control.arrange.copy();
			control.showmessage("PATTERNS COPIED");
		}
	}
	
	if (control.cursorx > -1 && control.cursory > -1 && control.currentbox > -1 && !control.clicklist) {
		if (key.press && control.dragaction == 0) {
			//Add note 
			if (control.musicbox[control.currentbox].start + (11 - control.cursory) == -1) {
				if (key.click) {
					control.musicbox[control.currentbox].recordfilter = 1 - control.musicbox[control.currentbox].recordfilter;
				}
			}else{
				control.currentnote = control.pianoroll[control.musicbox[control.currentbox].start + (11 - control.cursory)];
				if (control.musicbox[control.currentbox].noteat(control.cursorx, control.currentnote)) {
					control.currentnote = control.pianoroll[control.musicbox[control.currentbox].start + (11 - control.cursory)];
				  control.musicbox[control.currentbox].removenote(control.cursorx, control.currentnote);
					control.musicbox[control.currentbox].addnote(control.cursorx, control.currentnote, control.notelength);
				}else{
					control.musicbox[control.currentbox].addnote(control.cursorx, control.currentnote, control.notelength);
				}
			}
		}
		
		if (key.rightpress) {
			//For the moment, just remove any note in this position
			if (control.musicbox[control.currentbox].start + (11 - control.cursory) > -1) {
				control.currentnote = control.pianoroll[control.musicbox[control.currentbox].start + (11 - control.cursory)];
				
				control.musicbox[control.currentbox].removenote(control.cursorx, control.currentnote);
			}
		}
	}else {
		if (key.click) {
			if (control.list.active){
				if (control.list.selection > -1) {
					//List selection stuff here
					if (control.list.type == control.LIST_CATEGORY) {
					  control.list.close();
						control.instrument[control.currentinstrument].category = control.list.item[control.list.selection];
						control.voicelist.index = control.voicelist.getfirst(control.instrument[control.currentinstrument].category);
						control.changeinstrumentvoice(control.voicelist.name[control.voicelist.index]);
					}
					if (control.list.type == control.LIST_INSTRUMENT) {
						if (control.list.item[control.list.selection] == ">> Next Page") {
							control.voicelist.pagenum++;
							control.list.close();
							control.filllist(control.LIST_INSTRUMENT);
							control.list.init(235, (gfx.linesize * 3) + 3);
						}else if (control.list.item[control.list.selection] == "<< First Page") {
							control.voicelist.pagenum = 0;
							control.list.close();
							control.filllist(control.LIST_INSTRUMENT);
							control.list.init(235, (gfx.linesize * 3) + 3);
						}else{
							control.changeinstrumentvoice(control.list.item[control.list.selection]);
							control.list.close();
						}
					}
					if (control.list.type == control.LIST_SELECTINSTRUMENT) {
						control.musicbox[control.currentbox].instr = control.list.selection;
						control.musicbox[control.currentbox].palette = control.instrument[control.musicbox[control.currentbox].instr].palette;
						control.list.close();
					}
					if (control.list.type == control.LIST_KEY) {
						control.changekey(control.list.selection);
						control.list.close();
					}
					if (control.list.type == control.LIST_SCALE) {
						control.changescale(control.list.selection);
						control.list.close();
					}
					
					if (control.list.type == control.LIST_BUFFERSIZE) {
						control.setbuffersize(control.list.selection);
						control.list.close();
					}
					
					if (control.list.type == control.LIST_EFFECTS) {
						control.effecttype = control.list.selection;
						control.updateeffects();
						control.list.close();
					}
					
					if (control.list.type == control.LIST_SCREENSIZE) {
						gfx.changewindowsize(control.list.selection + 1);
						control.fullscreen = false;
						control.savescreensettings();
						control.list.close();
					}
					
					if (control.list.type == control.LIST_EXPORTS) {
						if (control.list.selection) {
							control.exportwav();
						}else {
							control.exportxm();
						}
						control.list.close();
					}
				}else {
					control.list.close();
				}
				control.clicklist = true;
			}else if (control.my <= gfx.linesize) {
				//Change tabs
				if (control.mx < (gfx.screenwidth-40) / 4) {
					control.changetab(control.MENUTAB_FILE);
				}else if (control.mx < (2*(gfx.screenwidth-40)) / 4) {
					control.changetab(control.MENUTAB_ARRANGEMENTS);
				}else if (control.mx < (3*(gfx.screenwidth-40)) / 4) {
					control.changetab(control.MENUTAB_INSTRUMENTS);
				}else if (control.mx >= gfx.screenwidth - 20) {
					if (control.fullscreen) {control.fullscreen = false;
					}else {control.fullscreen = true;}
					updategraphicsmode();
				}else if (control.mx >= gfx.screenwidth - 40) {
					control.filllist(control.LIST_SCREENSIZE);
					control.list.init(gfx.screenwidth - 40, gfx.linesize - 2);
				}else{
					control.changetab(control.MENUTAB_ADVANCED);
				}
			}else if (control.my > gfx.linesize && control.my < gfx.pianorollposition + 10) {				
				if (control.currenttab == control.MENUTAB_ARRANGEMENTS) {
					//Arrangements
					//Timeline
					if (control.timelinecurx > -1) {
						j = control.arrange.viewstart + control.timelinecurx;
						if (j > -1) {
							if (control.doubleclickcheck > 0) {
								//Set loop song from this bar
								control.arrange.loopstart = j;
								control.arrange.loopend = control.arrange.lastbar;	
								if (control.arrange.loopend <= control.arrange.loopstart) {
									control.arrange.loopend = control.arrange.loopstart + 1;
								}
								control.doubleclickcheck = 0;
							}else{
								control.dragx = j;
								control.dragaction = 3;
								control.doubleclickcheck = 25;
							}
						}
					}
					//Pattern Manager
					if (control.patterncury > -1) {
						if (control.patterncury == 0 && control.patternmanagerview > 0 && control.numboxes > 0) {
							control.patternmanagerview--;
						}else if (control.patterncury == 6 && control.patterncury + control.patternmanagerview < control.numboxes) {
							control.patternmanagerview++;
						}else {
							j = control.patternmanagerview + control.patterncury;
							if (j > -1 && j<control.numboxes) {
								control.changemusicbox(j);
							  control.dragaction = 2;
							  control.dragpattern = j;
								control.dragx = control.mx; control.dragy = control.my;
							}
						}
					}
					//Arrangements
					if (control.arrangecurx > -1 && control.arrangecury > -1) {
						//Change, start drag
						if (control.dragaction == 0) {
							if(control.arrangecurx + control.arrange.viewstart>-1){
								j = control.arrange.bar[control.arrangecurx + control.arrange.viewstart].channel[control.arrangecury];
								if (j > -1) {
									control.changemusicbox(j);
									control.dragaction = 1;
									control.dragpattern = j;
									control.dragx = control.mx; control.dragy = control.my;
								}
							}else {
								//Clicked the control panel
								if (control.arrange.viewstart == -1 && control.arrangecurx == 0) {
									/* Not doing this stuff anymore
									if (control.mx < gfx.patternwidth / 2) {
										control.arrange.channelon[control.arrangecury] = true;
									}else {
										control.arrange.channelon[control.arrangecury] = false;
									}*/
									//Set loop to entire song!
									control.arrange.loopstart = 0;
									control.arrange.loopend = control.arrange.lastbar;
								}
							}
						}
						
						//control.arrange.bar[control.arrangecurx + control.arrange.viewstart].channel[control.arrangecury] = control.currentbox;
					}
				}else if (control.currenttab == control.MENUTAB_INSTRUMENTS) {
					//Instrument Manager
					if (control.instrumentcury > -1) {
						if (control.instrumentcury == 0 && control.instrumentmanagerview > 0 && control.numinstrument > 0) {
							control.instrumentmanagerview--;
						}else if (control.instrumentcury == 6 && control.instrumentcury + control.instrumentmanagerview < control.numinstrument) {
							control.instrumentmanagerview++;
						}else if (control.instrumentcury == 7) {
							//Add a new one!
							
						}else {
							j = control.instrumentcury + control.instrumentmanagerview;
							if (j < control.numinstrument) {
							  control.currentinstrument = j;
							}
						}
					}else {
						if (control.my > (gfx.linesize * 2) + 3 && control.my < (gfx.linesize * 3) + 3) {
							if (control.mx > 140 && control.mx < 230) {
								control.filllist(control.LIST_CATEGORY);
								control.list.init(145, (gfx.linesize * 3) + 3);
							}else if (control.mx >= 230) {
								control.voicelist.makesublist(control.instrument[control.currentinstrument].category);
								control.filllist(control.LIST_INSTRUMENT);
								control.list.init(235, (gfx.linesize * 3) + 3);
							}
						}
					}
				}
			}else if (control.my > gfx.screenheight - gfx.linesize) {
				if (control.currentbox > -1) {
					if (!control.list.active) {
						if (control.mx < 150) {
							control.filllist(control.LIST_SELECTINSTRUMENT);
							control.list.init(10, (gfx.screenheight - gfx.linesize) - (control.list.numitems * gfx.linesize));
						}else if (control.mx < 210) {
							if (control.instrument[control.musicbox[control.currentbox].instr].type == 0) {
								control.filllist(control.LIST_KEY);
								control.list.init(170, (gfx.screenheight - gfx.linesize) - (control.list.numitems * gfx.linesize));
							}
						}else {
							if (control.instrument[control.musicbox[control.currentbox].instr].type == 0) {
								control.filllist(control.LIST_SCALE);
								control.list.init(220, (gfx.screenheight - gfx.linesize) - (control.list.numitems * gfx.linesize));
							}
						}
					}
				}
			}else if (control.notey > -1) {
				//Play a single note
				if (control.currentbox > -1) {
				  if (control.instrument[control.musicbox[control.currentbox].instr].type == 0) {	
						//Normal instrument
						j = control.musicbox[control.currentbox].start + (11 - control.notey);
						if (j >= 0 && j < 128) control._driver.noteOn(control.pianoroll[j], control.instrument[control.musicbox[control.currentbox].instr].voice, control.notelength);
					}else {
						//Drumkit
						j = control.musicbox[control.currentbox].start + (11 - control.notey);
						if (j >= 0 && j < 128) control._driver.noteOn(control.drumkit[control.instrument[control.musicbox[control.currentbox].instr].type-1].voicenote[j], control.drumkit[control.instrument[control.musicbox[control.currentbox].instr].type-1].voicelist[j], control.notelength);
					}
				}
			}
		}
		
		if (key.press && !control.clicklist) {
			if (control.currenttab == control.MENUTAB_INSTRUMENTS) {
				if (control.my > gfx.linesize && control.my < gfx.pianorollposition + 10) {				
					if (control.mx >= 140 && control.my > 35 && control.mx < gfx.screenwidth - 25) {
						i = control.mx - 140; j = control.my - 40;
						if (i < 0) i = 0; if(i>200) i=200;
						if (j < 0) j = 0; if(j>45) j=45;
						k = 0;
						if (control.currentbox > -1) {
							if (control.musicbox[control.currentbox].recordfilter == 1) k = 1;
						}
						if (k == 1) {
							control.musicbox[control.currentbox].cutoffgraph[control.looptime%control.boxcount] = (i * 128) / 200;
							control.musicbox[control.currentbox].resonancegraph[control.looptime%control.boxcount] = (j * 9) / 45;
							control.instrument[control.currentinstrument].changefilterto(control.musicbox[control.currentbox].cutoffgraph[control.looptime%control.boxcount],control.musicbox[control.currentbox].resonancegraph[control.looptime%control.boxcount], control.musicbox[control.currentbox].volumegraph[control.looptime%control.boxcount]);
							if (control.instrument[control.currentinstrument].type > 0) {
								control.drumkit[control.instrument[control.currentinstrument].type-1].updatefilter(control.instrument[control.currentinstrument].cutoff, control.instrument[control.currentinstrument].resonance);
							}
						}else{
							control.instrument[control.currentinstrument].setfilter((i * 128) / 200, (j * 9) / 45);
							control.instrument[control.currentinstrument].updatefilter();
							if (control.instrument[control.currentinstrument].type > 0) {
								control.drumkit[control.instrument[control.currentinstrument].type-1].updatefilter(control.instrument[control.currentinstrument].cutoff, control.instrument[control.currentinstrument].resonance);
							}
						}
					}else if(control.my > 35 && control.mx >= gfx.screenwidth - 25) {
						j = control.my - 45;
						if (j < 0) j = 0; if(j>45) j=45;
						j = 45 - j;
						k = 0;
						if (control.currentbox > -1) {
							if (control.musicbox[control.currentbox].recordfilter == 1) {
					      if(control.musicbox[control.currentbox].instr == control.currentinstrument){
								  k = 1;
								}
							}
						}
						if (k == 1) {
							control.musicbox[control.currentbox].volumegraph[control.looptime%control.boxcount] = (j * 256) / 45;
							control.instrument[control.currentinstrument].changevolumeto((j * 256) / 45);
							if (control.instrument[control.currentinstrument].type > 0) {
								control.drumkit[control.instrument[control.currentinstrument].type-1].updatevolume((j * 256) / 45);
							}
						}else{
							control.instrument[control.currentinstrument].setvolume((j * 256) / 45);
							control.instrument[control.currentinstrument].updatefilter();
							if (control.instrument[control.currentinstrument].type > 0) {
								control.drumkit[control.instrument[control.currentinstrument].type-1].updatevolume((j * 256) / 45);
							}
						}
					}
				}
			}
		}
		
		if (key.rightpress) {
			if (control.my > gfx.linesize && control.my < gfx.pianorollposition+gfx.linesize) {
				if (control.currenttab == control.MENUTAB_FILE) {
					//Files
				}else if (control.currenttab == control.MENUTAB_ARRANGEMENTS) {
					//Arrangements
					//Timeline
					if(key.rightclick){
						if (control.timelinecurx > -1) {
							j = control.arrange.viewstart + control.timelinecurx;
							if (j > -1) {
								//Insert blank pattern
								control.arrange.deletebar(j);
							}
						}
					}
					//Pattern Manager
					//Arrangements
					if (control.arrangecurx > -1 && control.arrangecury > -1) {
						//Delete pattern from position
						control.dragaction = 0;
						if (control.arrange.bar[control.arrangecurx + control.arrange.viewstart].channel[control.arrangecury] > -1) {
							control.arrange.removepattern(control.arrangecurx + control.arrange.viewstart, control.arrangecury);
						}
					}
				}else if (control.currenttab == control.MENUTAB_INSTRUMENTS) {
					//Instruments
				}
			}
		}
		
		if (key.middleclick) {
			if (control.my > gfx.linesize && control.my < gfx.pianorollposition + gfx.linesize) {
				if (control.currenttab == control.MENUTAB_FILE) {
					//Files
				}else if (control.currenttab == control.MENUTAB_ARRANGEMENTS) {
					//Arrangements
					//Timeline
					if (control.timelinecurx > -1) {
						j = control.arrange.viewstart + control.timelinecurx;
						if (j > -1) {
							//Insert blank pattern
							control.arrange.insertbar(j);
						}
					}
					//Pattern Manager
					//Arrangements
					if (control.arrangecurx > -1 && control.arrangecury > -1) {
						//Make variation pattern!
						j = control.arrange.bar[control.arrangecurx + control.arrange.viewstart].channel[control.arrangecury];
						if (j > -1) {
							control.addmusicbox();
							control.copymusicbox(control.numboxes - 1, j);
			        control.musicbox[control.numboxes - 1].setnotespan();
							control.patternmanagerview = control.numboxes - 6;
							control.changemusicbox(control.numboxes - 1);
							
							if (control.patternmanagerview < 0) control.patternmanagerview = 0;
							control.dragaction = 1;
							control.dragpattern = control.numboxes - 1;
							control.dragx = control.mx; control.dragy = control.my;
						}
					}
				}else if (control.currenttab == control.MENUTAB_INSTRUMENTS) {
					//Instruments
				}
			}
		}
	}
	
	if (key.hasreleased || key.hasmiddlereleased) {
		//Check for click releases: deal with immediately
		key.hasreleased = false; key.hasmiddlereleased = false;
		
		if (control.dragaction == 1 || control.dragaction == 2) {
			control.dragaction = 0;
			if (control.arrangecurx > -1 && control.arrangecury > -1) {
				control.arrange.addpattern(control.arrangecurx + control.arrange.viewstart, control.arrangecury, control.dragpattern);
			}else {
				if (control.mx > gfx.screenwidth - 60 && control.my > gfx.screenheight - 20) {
					control.deletemusicbox(control.dragpattern);
				}
			}
		}else if (control.dragaction == 3) {
			control.dragaction = 0;
			
			control.arrange.loopstart = control.dragx;
			control.arrange.loopend = control.arrange.viewstart + control.timelinecurx + 1;
			if (control.arrange.loopend <= control.arrange.loopstart) {
				i = control.arrange.loopend;
				control.arrange.loopend = control.arrange.loopstart+1;
				control.arrange.loopstart = i-1;
			}
			if (control.arrange.currentbar < control.arrange.loopstart) control.arrange.currentbar = control.arrange.loopstart;
			if (control.arrange.currentbar >= control.arrange.loopend) control.arrange.currentbar = control.arrange.loopend - 1;
			if (control.arrange.loopstart < 0) control.arrange.loopstart = 0;
		}
	}
	
	if (control.my > gfx.pianorollposition) {
		if (key.mousewheel < 0) {
			control.notelength--;
			if (control.notelength < 1) control.notelength = 1;
			key.mousewheel = 0;
		}else if (key.mousewheel > 0) {
			control.notelength++;
			key.mousewheel = 0;
		}
	}else {
		if (key.mousewheel < 0 || (key.shiftheld && (control.press_down || control.press_left))) {
			gfx.zoom--; if (gfx.zoom < 1) gfx.zoom = 1;
			gfx.setzoomlevel(gfx.zoom);
			key.mousewheel = 0;
		}else if (key.mousewheel > 0  || (key.shiftheld && (control.press_up||control.press_right))) {
			gfx.zoom++; if (gfx.zoom > 4) gfx.zoom = 4;
			gfx.setzoomlevel(gfx.zoom);
			key.mousewheel = 0;
		}
	}
	
	if (control.keydelay <= 0) {	
		if (control.currentbox > -1) {
			if (!key.shiftheld) {
				if (control.press_down) {
					control.musicbox[control.currentbox].start--;
					if (control.musicbox[control.currentbox].start < -1) control.musicbox[control.currentbox].start = -1;
					control.keydelay = 4;
				}else if (control.press_up) {
					control.musicbox[control.currentbox].start++;
					if (control.musicbox[control.currentbox].start > control.pianorollsize-12) control.musicbox[control.currentbox].start =  control.pianorollsize-12;
					if (control.instrument[control.musicbox[control.currentbox].instr].type > 0) {
						//Also check for drumkit ranges
						if (control.musicbox[control.currentbox].start > control.drumkit[control.instrument[control.musicbox[control.currentbox].instr].type-1].size-12) control.musicbox[control.currentbox].start = control.drumkit[control.instrument[control.musicbox[control.currentbox].instr].type-1].size-12;
						if (control.musicbox[control.currentbox].start < 0) control.musicbox[control.currentbox].start = 0;
					}
					control.keydelay = 4;
				}
			}else {
				if (control.press_down || control.press_left) {
					control.notelength--;
					if (control.notelength < 1) control.notelength = 1;
					control.keydelay = 4;
				}else if (control.press_up || control.press_right) {
					control.notelength++;
					control.keydelay = 4;
				}
			}
		}
		
		if(!key.shiftheld){
			if (control.press_left) {
				control.arrange.viewstart--;
				if (control.arrange.viewstart < 0) control.arrange.viewstart = 0;
				control.keydelay = 4;
			}else if (control.press_right) {
				control.arrange.viewstart++;
				if (control.arrange.viewstart > 1000) control.arrange.viewstart = 1000;
				control.keydelay = 4;
			}
		}
	}else {
		control.keydelay--;
	}
	
	if (control.currentbox > -1) {
	  if (!control.press_down && control.musicbox[control.currentbox].start == -1) {
			control.musicbox[control.currentbox].start = 0;
		}	
	}
	
	if (!control.keyheld) {
		if (control.press_space || control.press_enter) {
			if (!control.musicplaying) {
				control.startmusic();
			}else {
			  control.stopmusic();	
			}
			control.keyheld = true;
		}
	}
	
	CONFIG::desktop {
		if (key.isDown(Keyboard.ESCAPE)) {
			NativeApplication.nativeApplication.exit(0);
		}
	}
}