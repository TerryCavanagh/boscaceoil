public function logic(key:KeyPoll, gfx:graphicsclass, control:controlclass):void {
	var i:int, j:int, k:int;
	
	if (control.messagedelay > 0) control.messagedelay--;
  if (control.doubleclickcheck > 0) control.doubleclickcheck--;
	if (gfx.buttonpress > 0) gfx.buttonpress--;
	
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
