public function logic(key:KeyPoll):void {
	var i:int, j:int, k:int;
	
	if (control.arrangescrolldelay > 0) {
		control.arrangescrolldelay--;
	}
	
	if (control.messagedelay > 0) {
		control.messagedelay -= 2;
		if (control.messagedelay < 0) control.messagedelay = 0;
	}
  if (control.doubleclickcheck > 0) {
		control.doubleclickcheck -= 2;
		if (control.doubleclickcheck < 0) control.doubleclickcheck = 0;
	}
	if (gfx.buttonpress > 0) {
		gfx.buttonpress -= 2;
		if (gfx.buttonpress < 0) gfx.buttonpress = 0;
	}
	
	if (control.minresizecountdown > 0) {
		control.minresizecountdown -= 2;
		if (control.minresizecountdown <= 0) {
			control.minresizecountdown = 0;
			gfx.forceminimumsize();
		}
	}
	
	if (control.savescreencountdown > 0) {
		control.savescreencountdown -= 2;
		if (control.savescreencountdown <= 0) {
			control.savescreencountdown = 0;
			control.savescreensettings();
		}
	}
	
	if (control.dragaction == 2) {
		control.trashbutton+=2;
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
