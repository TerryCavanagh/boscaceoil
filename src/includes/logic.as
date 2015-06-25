public function logic(key:KeyPoll):void {
	var i:int, j:int, k:int;
	
	if (control.messagedelay > 0) control.messagedelay--;
  if (control.doubleclickcheck > 0) control.doubleclickcheck--;
	if (gfx.buttonpress > 0) gfx.buttonpress--;
	
	if (control.minresizecountdown > 0) {
		control.minresizecountdown--;
		if (control.minresizecountdown == 0) {
			if (gfx.windowwidth < gfx.min_windowwidth && gfx.windowheight < gfx.min_windowheight) {
				gfx.changewindowsize(gfx.min_windowwidth, gfx.min_windowheight);
			}else if (gfx.windowwidth < gfx.min_windowwidth) {
				gfx.changewindowsize(gfx.min_windowwidth, gfx.windowheight);
			}else if (gfx.windowheight < gfx.min_windowheight) {
				gfx.changewindowsize(gfx.windowwidth, gfx.min_windowheight);
			}
		}
	}
	
	if (control.savescreencountdown > 0) {
		control.savescreencountdown--;
		if (control.savescreencountdown <= 0) control.savescreensettings();
	}
	
	if (control.dragaction == 2) {
		control.trashbutton++;
		if (control.trashbutton > 10) control.trashbutton = 10;
	}else {
		if (control.trashbutton > 0) control.trashbutton--;
	}
	
	if (control.followmode) {
		if (control.arrange.currentbar < control.arrange.viewstart) {
			control.arrange.viewstart = control.arrange.currentbar;
		}
		if (control.arrange.currentbar > control.arrange.viewstart+5) {
			control.arrange.viewstart = control.arrange.currentbar;
		}
	}
}
