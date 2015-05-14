public function render(key:KeyPoll):void {
	var i:int, j:int, k:int;
	
	//Background
	gfx.fillrect(0, 0, gfx.screenwidth, gfx.screenheight, 1);
	
	//Tabs
	j = (gfx.screenwidth-40) / 4;
	gfx.fillrect(control.currenttab * j, 0, j, gfx.linesize, 5);
	gfx.print(12, 0, "FILE", control.currenttab==control.MENUTAB_FILE?0:2, false, true);
	gfx.print(j+ 2, 0, "ARRANGEMENT", control.currenttab==control.MENUTAB_ARRANGEMENTS?0:2, false, true);
	gfx.print((j * 2) + 2, 0, "INSTRUMENT", control.currenttab == control.MENUTAB_INSTRUMENTS?0:2, false, true);
	gfx.print((j * 3) + 2, 0, "ADVANCED", control.currenttab == control.MENUTAB_ADVANCED?0:2, false, true);
	gfx.fillrect((j * 4), 0, 21, 10, 4);
	if (control.fullscreen) {
		gfx.print((j * 4) + 6, 0, "F", 2, false, true);
	}else{
	  gfx.print((j * 4) + 2, 0, "x" + String(gfx.screenscale), 2, false, true);
	}
	gfx.fillrect((j * 4) + 20, 0, 21, 10, 3);
	gfx.drawicon((j * 4) + 26, 1, control.fullscreen?5:4);
	
	gfx.fillrect(0, gfx.linesize, gfx.screenwidth, gfx.linesize * 10, 5);
	
	switch(control.currenttab) {
		case control.MENUTAB_FILE:
			gfx.drawmenu();
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
			gfx.drawadvancedmenu();
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
	
	guiclass.drawbuttons();
	
	gfx.render();
}