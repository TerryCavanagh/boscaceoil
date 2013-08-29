public function render(key:KeyPoll, gfx:graphicsclass, control:controlclass):void {
	var i:int, j:int, k:int;
	
	//Background
	gfx.fillrect(0, 0, gfx.screenwidth, gfx.screenheight, 1);
	
	//Tabs
	j = (gfx.screenwidth-40) / 3;
	gfx.fillrect(control.currenttab * j, 0, j, gfx.linesize, 5);
	gfx.print(12, 0, "FILE", control.currenttab==0?0:2, false, true);
	gfx.print(j+ 2, 0, "ARRANGEMENT", control.currenttab==1?0:2, false, true);
	gfx.print((j * 2) + 2, 0, "INSTRUMENT", control.currenttab == 2?0:2, false, true);
	gfx.fillrect((j * 3), 0, 21, 10, 4);
	if (control.fullscreen) {
		gfx.print((j * 3) + 6, 0, "F", 2, false, true);
	}else{
	  gfx.print((j * 3) + 2, 0, "x" + String(gfx.screenscale), 2, false, true);
	}
	gfx.fillrect((j * 3) + 20, 0, 21, 10, 3);
	gfx.drawicon((j * 3) + 26, 1, control.fullscreen?5:4);
	
	gfx.fillrect(0, gfx.linesize, gfx.screenwidth, gfx.linesize * 10, 5);
	
	switch(control.currenttab) {
		case 3:
			gfx.drawadvancedmenu(control);
		break;
		case 0:
			gfx.drawmenu(control);
		break;
		case 1:
			gfx.drawarrangementeditor(control);
			gfx.drawtimeline(control);
			gfx.drawpatternmanager(control);
		break;
	  case 2:
		  gfx.drawinstrumentlist(control);
			gfx.drawinstrument(control);
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
	  gfx.drawpatterneditor(control);
	}else {
		gfx.fillrect(0, gfx.pianorollposition + gfx.linesize, gfx.screenwidth, gfx.linesize * 13, 14);
	}
	
	//Draw pop up lists over all that
	gfx.drawlist(control);
	
	//Draw mouse dragging stuff over everything
	if (control.dragaction == 1 || control.dragaction == 2) {
		if (Math.abs(control.mx - control.dragx) > 4 || Math.abs(control.my - control.dragy) > 4) {
			gfx.drawmusicbox(control, control.mx, control.my, control.dragpattern);
		}
	}
	
	gfx.render(control);
}