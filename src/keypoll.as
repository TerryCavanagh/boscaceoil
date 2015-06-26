public function generickeypoll():void {
	control.press_up = false; control.press_down = false; 
  control.press_left = false; control.press_right = false; 
	control.press_space = false; control.press_enter = false;
		
	if (key.isDown(Keyboard.LEFT) || key.isDown(Keyboard.A)) control.press_left = true;
	if (key.isDown(Keyboard.RIGHT) || key.isDown(Keyboard.D)) control.press_right = true;
	if (key.isDown(Keyboard.UP) || key.isDown(Keyboard.W)) control.press_up= true;
	if (key.isDown(Keyboard.DOWN) || key.isDown(Keyboard.S)) control.press_down = true;
	if (key.isDown(Keyboard.SPACE)) control.press_space = true;
	if (key.isDown(Keyboard.ENTER)) control.press_enter = true;
	
  control.keypriority = 0;
	
	if (control.keypriority == 3) {control.press_up = false; control.press_down = false;
	}else if (control.keypriority == 4) { control.press_left = false; control.press_right = false; }
	
	if ((key.isDown(15) || key.isDown(17)) && key.isDown(70) && !control.fullscreentoggleheld) {
		//Toggle fullscreen
		control.fullscreentoggleheld = true;
		if (control.fullscreen) {control.fullscreen = false;
		}else { control.fullscreen = true; }
		updategraphicsmode();
	}
	
	if (control.fullscreentoggleheld) {
	  if (!key.isDown(15) && !key.isDown(17) && !key.isDown(70)) {
			control.fullscreentoggleheld = false;
		}
	}
	
	if (control.keyheld) {
		if (control.press_space || control.press_right || control.press_left || control.press_enter ||
		    control.press_down || control.press_up) {
			control.press_space = false;
			control.press_enter = false;
			control.press_up = false;
			control.press_down = false;
			control.press_left = false;
			control.press_right = false;
		}else {
			control.keyheld = false;
		}
	}
	
	if (control.press_space || control.press_right || control.press_left || control.press_enter ||
		  control.press_down || control.press_up) {
		//Update screen when there is input.
		gfx.updatebackground = 5;
	}
}