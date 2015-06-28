public function render(key:KeyPoll):void {
	var i:int, j:int, k:int;
	
	if (gfx.updatebackground > 0) {
		gfx.changeframerate(30);
		//Background
		gfx.fillrect(0, 0, gfx.screenwidth, gfx.screenheight, 1);
		
		//Tabs
		CONFIG::desktop {
			j = (gfx.screenwidth - 40) / 4;
		}
		CONFIG::web {
			j = (gfx.screenwidth) / 4;
		}
		if (control.currenttab == control.MENUTAB_HELP) {
			gfx.fillrect(0, 0, j, gfx.linesize, 5);
			gfx.print(14, 0, "HELP", control.currenttab == control.MENUTAB_HELP?0:2, false, true);
		}else if (control.currenttab == control.MENUTAB_CREDITS) {
			gfx.fillrect(0, 0, j, gfx.linesize, 5);
			gfx.print(14, 0, "CREDITS", control.currenttab == control.MENUTAB_CREDITS?0:2, false, true);
		}else{
			gfx.fillrect(control.currenttab * j, 0, j, gfx.linesize, 5);
			gfx.print(14, 0, "FILE", control.currenttab == control.MENUTAB_FILE?0:2, false, true);
		}
		gfx.print(j + 14, 0, "ARRANGEMENT", control.currenttab==control.MENUTAB_ARRANGEMENTS?0:2, false, true);
		gfx.print((j * 2) + 14, 0, "INSTRUMENT", control.currenttab == control.MENUTAB_INSTRUMENTS?0:2, false, true);
		gfx.print((j * 3) + 14, 0, "ADVANCED", control.currenttab == control.MENUTAB_ADVANCED?0:2, false, true);
		CONFIG::desktop {
			gfx.fillrect((j * 4), 0, 42, 20, 3);
			gfx.drawicon((j * 4) + 12, 1, control.fullscreen?5:4);
		}
		
		if (control.nowexporting) {
			gfx.updatebackground = 5;
			gfx.fillrect(0, gfx.pianorollposition + gfx.linesize, gfx.screenwidth, gfx.screenheight - (gfx.pianorollposition + gfx.linesize), 14);
			if (control.arrange.currentbar % 2 == 0) {
				guiclass.tx = int(gfx.screenwidth / 64) + 1;
				for (i = -1; i < guiclass.tx; i++) {
					gfx.fillrect((i * 64) + help.slowsine, gfx.pianorollposition + gfx.linesize, 32,  gfx.screenheight - (gfx.pianorollposition + gfx.linesize), 1);
				}
			}else {
				guiclass.tx = int(gfx.screenheight - (gfx.pianorollposition + gfx.linesize) / 64) + 1;
				for (i = 0; i < guiclass.tx; i++) {
					gfx.fillrect(0, gfx.pianorollposition + gfx.linesize + (i * 64) + help.slowsine, gfx.screenwidth, 32, 1);
				}
				if (help.slowsine >= 32) {
					gfx.fillrect(0, gfx.pianorollposition + gfx.linesize, gfx.screenwidth, help.slowsine-32, 1);
				}
			}
			if (help.slowsine < 32) {
				gfx.print(gfx.screenwidthmid - (gfx.len("NOW EXPORTING AS WAV, PLEASE WAIT") / 2), (gfx.pianorollposition + gfx.linesize)+ (gfx.screenheight - gfx.hig("WAV") - (gfx.pianorollposition + gfx.linesize))/2, "NOW EXPORTING AS WAV, PLEASE WAIT", 0, false, true);
			}
		}else if(control.currentbox>-1){
			gfx.drawpatterneditor();
		}else {
			gfx.fillrect(0, gfx.pianorollposition + gfx.linesize, gfx.screenwidth, gfx.screenheight - gfx.pianorollposition, 14);
		}
		
		//Draw menu area
		gfx.fillrect(0, gfx.linesize, gfx.screenwidth, gfx.linesize * 10, 5);
		for (j = 0; j < gfx.linesize * 10; j++) {
			if (j % 4 == 0) {
				gfx.fillrect(0, gfx.linesize + j, gfx.screenwidth, 2, 1);
			}
		}
		
		switch(control.currenttab) {
			case control.MENUTAB_FILE:
				guiclass.tx = (gfx.screenwidth - 768) / 4;
				gfx.fillrect(guiclass.tx, gfx.linesize, 408, gfx.linesize * 10, 5);
				gfx.fillrect(gfx.screenwidth - guiclass.tx - 408+24, gfx.linesize, 408, gfx.linesize * 10, 5);
			break;
			case control.MENUTAB_CREDITS:
				guiclass.tx = (gfx.screenwidth - 768) / 4;
				gfx.fillrect(guiclass.tx, gfx.linesize, 408, gfx.linesize * 10, 5);
				gfx.fillrect(gfx.screenwidth - guiclass.tx - 408+24, gfx.linesize, 408, gfx.linesize * 10, 5);
			break;
			case control.MENUTAB_HELP:
				guiclass.tx = (gfx.screenwidth - 768) / 2;
				gfx.fillrect(guiclass.tx, gfx.linesize, 768, gfx.linesize * 10, 5);
			break;
			case control.MENUTAB_ARRANGEMENTS:
				gfx.drawarrangementeditor();
				gfx.drawtimeline();
				gfx.drawpatternmanager();
			break;
			case control.MENUTAB_INSTRUMENTS:
				gfx.drawinstrumentlist();
				gfx.drawinstrument();
			break;
			case control.MENUTAB_ADVANCED:
				guiclass.tx = (gfx.screenwidth - 768) / 4;
				gfx.fillrect(guiclass.tx, gfx.linesize, 408, gfx.linesize * 10, 5);
				gfx.fillrect(gfx.screenwidth - guiclass.tx - 408+24, gfx.linesize, 408, gfx.linesize * 10, 5);
			break;
		}
		
		//Cache bitmap at this point
		gfx.updatebackground--;
		if (gfx.updatebackground == 0) {
			gfx.settrect(gfx.backbuffer.rect.x, gfx.backbuffer.rect.y, gfx.backbuffer.rect.width, gfx.backbuffer.rect.height);
			gfx.backbuffercache.copyPixels(gfx.backbuffer, gfx.trect, gfx.tl);
		}
	}else {
		if(!control.musicplaying) gfx.changeframerate(15); //If there's no music playing, drop the framerate!
		//Draw from cache
		gfx.settrect(gfx.backbuffercache.rect.x, gfx.backbuffercache.rect.y, gfx.backbuffercache.rect.width, gfx.backbuffercache.rect.height);
		gfx.backbuffer.copyPixels(gfx.backbuffercache, gfx.trect, gfx.tl);
	}
	
	if (control.currenttab == control.MENUTAB_ARRANGEMENTS) {
		gfx.drawarrangementcursor();
		if (control.mx > gfx.patternmanagerx - 108) {
			gfx.drawpatternmanager();
		}
		gfx.drawtimeline_cursor();
		gfx.drawpatternmanager_cursor();
	}
	
	if (!control.nowexporting) {
		if (control.currentbox > -1) {
		  gfx.drawpatterneditor_cursor();
		}
	}
	
	guiclass.drawbuttons();
	
	if (control.messagedelay > 0) {
		i = control.messagedelay > 10?10:control.messagedelay;
		gfx.fillrect(0, gfx.screenheight - (i * 2), gfx.screenwidth, 20, 16);
		gfx.print(gfx.screenwidthmid - (gfx.len(control.message) / 2), gfx.screenheight - (i * 2), control.message, 0, false, true);
	}
	
	//Draw pop up lists over all that
	gfx.drawlist();
	
	//Draw mouse dragging stuff over everything
	if (control.dragaction == 1 || control.dragaction == 2) {
		if (Math.abs(control.mx - control.dragx) > 4 || Math.abs(control.my - control.dragy) > 4) {
			gfx.drawmusicbox(control.mx, control.my, control.dragpattern);
		}
	}
	
	gfx.render();
}