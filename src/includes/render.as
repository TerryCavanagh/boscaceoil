public function render(key:KeyPoll):void {
	var i:int, j:int, k:int;
	
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
	
	gfx.fillrect(0, gfx.linesize, gfx.screenwidth, gfx.linesize * 10, 5);
	
	switch(control.currenttab) {
		case control.MENUTAB_ARRANGEMENTS:
			gfx.drawarrangementeditor();
			gfx.drawtimeline();
			gfx.drawpatternmanager();
		break;
	  case control.MENUTAB_INSTRUMENTS:
		  gfx.drawinstrumentlist();
			gfx.drawinstrument();
		break;
	}
	
	if (control.nowexporting) {
		gfx.fillrect(0, gfx.pianorollposition + gfx.linesize, gfx.screenwidth, gfx.linesize * 13, 14);
		if (control.arrange.currentbar % 2 == 0) {
			for (i = -1; i < 10; i++) {
				gfx.fillrect((i * 64) + help.slowsine, gfx.pianorollposition + gfx.linesize, 32, gfx.linesize * 13, 1);
			}
		}else {
			for (i = 0; i < 10; i++) {
				gfx.fillrect(0, gfx.pianorollposition + gfx.linesize + (i * 64) + help.slowsine, gfx.screenwidth, 32, 1);
			}
			if (help.slowsine >= 32) {
				gfx.fillrect(0, gfx.pianorollposition + gfx.linesize, gfx.screenwidth, help.slowsine-32, 1);
			}
		}
		if (help.slowsine < 32) {
		  gfx.print(0, 170, "NOW EXPORTING AS WAV, PLEASE WAIT", 0, true, true);
		}
	}else if(control.currentbox>-1){
	  gfx.drawpatterneditor();
	}else {
		gfx.fillrect(0, gfx.pianorollposition + gfx.linesize, gfx.screenwidth, gfx.linesize * 13, 14);
	}
	
	guiclass.drawbuttons();
	
	if (control.messagedelay > 0) {
		i = control.messagedelay > 10?10:control.messagedelay;
		gfx.fillrect(0, gfx.screenheight - i, gfx.screenwidth, 10, 16);
		gfx.print(0, gfx.screenheight - i, control.message, 0, true, true);
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