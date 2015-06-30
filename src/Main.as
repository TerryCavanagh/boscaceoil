/*
 * 
BOSCA CEOIL - Terry Cavanagh 2013 / http://www.distractionware.com
 
Available under FreeBSD licence. Have fun!
	
This problem uses the SiON Library by Kei Mesuda.
	
The SiON Library is 

Copyright 2008-2010 Kei Mesuda (keim) All rights reserved.
Redistribution and use in source and binary forms,

with or without modification, are permitted provided that
the following conditions are met: 
1. Redistributions of source code must retain the above copyright notice,
   this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

package{
	import flash.display.*;
	import flash.geom.*;
  import flash.events.*;
  import flash.net.*;
	import flash.media.*;
  import flash.ui.ContextMenu;
  import flash.ui.ContextMenuItem;
	import flash.ui.Keyboard;
	import bigroom.input.KeyPoll;
  import flash.ui.Mouse;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import flash.events.InvokeEvent;
	
	CONFIG::desktop {
		import flash.desktop.NativeApplication;
	}
	CONFIG::web {
		import flash.external.ExternalInterface;
	}

	public class Main extends Sprite{
  	include "keypoll.as";
  	include "includes/logic.as";
  	include "includes/input.as";
  	include "includes/render.as";
		
		public function Main():void {
			control.versionnumber = "v2.0"; // Version number displayed beside logo
			control.version = 3;            // Version number used by file
			control.ctrl = "Ctrl"; //Set this to Cmd on Mac so that the tutorial is correct
			
			CONFIG::desktop {
				NativeApplication.nativeApplication.setAsDefaultApplication("ceol");
				NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvokeEvent);
			}
			
			key = new KeyPoll(stage);
			control.init();
			
			//Working towards resolution independence!
			gfx.init(stage);
			
			CONFIG::desktop {
				stage.addEventListener(Event.RESIZE, handleResize);
			}
			
			var tempbmp:Bitmap;
			tempbmp = new im_icons();	gfx.buffer = tempbmp.bitmapData;	gfx.makeiconarray();
			tempbmp = new im_logo0();	gfx.buffer = tempbmp.bitmapData;	gfx.addimage();
			tempbmp = new im_logo1();	gfx.buffer = tempbmp.bitmapData;	gfx.addimage();
			tempbmp = new im_logo2();	gfx.buffer = tempbmp.bitmapData;	gfx.addimage();
			tempbmp = new im_logo3();	gfx.buffer = tempbmp.bitmapData;	gfx.addimage();
			tempbmp = new im_logo4();	gfx.buffer = tempbmp.bitmapData;	gfx.addimage();
			tempbmp = new im_logo5();	gfx.buffer = tempbmp.bitmapData;	gfx.addimage();
			tempbmp = new im_logo6();	gfx.buffer = tempbmp.bitmapData;	gfx.addimage();
			tempbmp = new im_logo7();	gfx.buffer = tempbmp.bitmapData;	gfx.addimage();
			
			tempbmp = new im_tutorialimage0();	gfx.buffer = tempbmp.bitmapData;	gfx.addimage();
			tempbmp = new im_tutorialimage1();	gfx.buffer = tempbmp.bitmapData;	gfx.addimage();
			tempbmp = new im_tutorialimage2();	gfx.buffer = tempbmp.bitmapData;	gfx.addimage();
			tempbmp = new im_tutorialimage3();	gfx.buffer = tempbmp.bitmapData;	gfx.addimage();
			tempbmp = new im_tutorialimage4();	gfx.buffer = tempbmp.bitmapData;	gfx.addimage();
			gfx.buffer = new BitmapData(1, 1, false, 0x000000);
			
			control.changetab(control.MENUTAB_FILE);
			
			control.voicelist.fixlengths();
			stage.fullScreenSourceRect = null;
			addChild(gfx.screen);
			
			control.loadscreensettings();
			updategraphicsmode();
			
			gfx.changescalemode(gfx.scalemode);
			
			if (guiclass.firstrun) {
				guiclass.changewindow("firstrun");
				control.changetab(control.currenttab); control.clicklist = true;
			}
			
			CONFIG::desktop {
				_startMainLoop();
			}
			
			CONFIG::web {
				if (ExternalInterface.available) {
					if (ExternalInterface.call("Bosca._isReady")) {
						_startMainLoopWeb();
					} else {
						// If the container is not ready, set up a Timer to call the
						// container at 100ms intervals. Once the container responds that
						// it's ready, the timer will be stopped.
						var containerIsReadyTimer:Timer = new Timer(100);
						containerIsReadyTimer.addEventListener(TimerEvent.TIMER, function (e:TimerEvent):void {
							if (ExternalInterface.call("Bosca._isReady")) {
								Timer(e.target).stop();
								_startMainLoopWeb();
							}
						});
						containerIsReadyTimer.start();
					}
				}
			}
		}
		
		CONFIG::desktop {
		private function handleResize(e:Event):void {
			// adjust the gui to fit the new device resolution
			var tempwidth:int, tempheight:int;
			if (e != null) {
				e.preventDefault();
				tempwidth = e.target.stageWidth;
				tempheight = e.target.stageHeight;
			}else {
				tempwidth = gfx.windowwidth;
				tempheight = gfx.windowheight;
			}
			
			control.savescreencountdown = 30; //Half a second after a resize, save the settings
			control.minresizecountdown = 5; //Force a minimum screensize
			gfx.changewindowsize(tempwidth, tempheight);
			
			gfx.patternmanagerx = gfx.screenwidth - 116;
			gfx.patterneditorheight = (gfx.windowheight - (gfx.pianorollposition - (gfx.linesize + 2))) / 12;
			gfx.notesonscreen = ((gfx.screenheight - gfx.pianorollposition - gfx.linesize) / gfx.linesize) + 1;
			gfx.tf_1.width = gfx.windowwidth;
			gfx.updateboxsize();
			
			guiclass.changetab(control.currenttab);
			
			var temp:BitmapData = new BitmapData(gfx.windowwidth, gfx.windowheight, false, 0x000000);
			gfx.updatebackground = 5;
			gfx.backbuffercache = new BitmapData(gfx.windowwidth, gfx.windowheight, false, 0x000000);
			temp.copyPixels(gfx.backbuffer, gfx.backbuffer.rect, gfx.tl);
			gfx.backbuffer = temp;
			//gfx.screen.bitmapData.dispose();
			gfx.screen.bitmapData = gfx.backbuffer;
			if (gfx.scalemode == 1) {
				gfx.screen.scaleX = 1.5;
				gfx.screen.scaleY = 1.5;
			}else {
				gfx.screen.scaleX = 1;
				gfx.screen.scaleY = 1;
			}
		}
		}
		
		private function _startMainLoop():void {
			CONFIG::desktop {
				NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, __activate__);
				NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, __deactivate__);
			}			
			CONFIG::web {
				addEventListener(Event.DEACTIVATE, __activate__);
				addEventListener(Event.ACTIVATE, __deactivate__);
			}
		  
			_timer.addEventListener(TimerEvent.TIMER, mainloop);
			_timer.start();
		}
		
		private function __activate__($event:Event):void {
			gfx.changeframerate(30);
		}
		
		private function __deactivate__($event:Event):void {
		  gfx.changeframerate(1);
		}

		CONFIG::web {
			private function _startMainLoopWeb():void {
				// Expose some functions to external JS
				ExternalInterface.addCallback("getCeolString", control.getCeolString);
				ExternalInterface.addCallback("invokeCeolWeb", control.invokeCeolWeb);
				ExternalInterface.addCallback("newSong", control.newsong);
				ExternalInterface.addCallback("exportWav", control.exportwav);
				
				control.invokeCeolWeb(ExternalInterface.call("Bosca._getStartupCeol"));
				
				_startMainLoop();
			}
		}
			
		public function _input():void {
			if (gfx.scalemode == 1) {
				control.mx = mouseX / 1.5;
				control.my = mouseY / 1.5;
			}else{
				control.mx = mouseX;
				control.my = mouseY;
			}
				
			input(key);
		}
		
    public function _logic():void {
			logic(key);
			help.updateglow();
			CONFIG::desktop {
				if (control.forceresize) {
					control.forceresize = false;
					handleResize(null);
				}
			}
		}
		
		public function _render():void {
			gfx.backbuffer.lock();
			render(key);			
		}
		
		public function mainloop(e:TimerEvent):void {
			_current = getTimer();
			if (_last < 0) _last = _current;
			_delta += _current - _last;
			_last = _current;
			if (_delta >= _rate){
				_delta %= _skip;
				while (_delta >= _rate){
					_delta -= _rate;
					_input();
					_logic();
					if (key.hasclicked) key.click = false;
					if (key.hasrightclicked) key.rightclick = false;
					if (key.hasmiddleclicked) key.middleclick = false;
				}
				_render();
				
				e.updateAfterEvent();
			}
		}
		
		public function updategraphicsmode():void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
		 	if (control.fullscreen) {
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			}else {
				stage.displayState = StageDisplayState.NORMAL;
			}
			
			control.savescreensettings();
		}
		
		CONFIG::desktop {
			public function onInvokeEvent(event:InvokeEvent):void{
				if (event.arguments.length > 0) {
					if (control.startup == 0) {
						//Loading a song at startup, wait until the sound is initilised
						control.invokefile = event.arguments[0];
					}else {
						//Program is up and running, just load now
						control.invokeceol(event.arguments[0]);
					}
				}
			}
		}
		
		public var key:KeyPoll;
		
		// Timer information (a shout out to ChevyRay for the implementation)
		public static const TARGET_FPS:Number = 30; // the fixed-FPS we want the control to run at
		private var	_rate:Number = 1000 / TARGET_FPS; // how long (in seconds) each frame is
		private var	_skip:Number = _rate * 10; // this tells us to allow a maximum of 10 frame skips
		private var	_last:Number = -1;
		private var	_current:Number = 0;
		private var	_delta:Number = 0;
		private var	_timer:Timer = new Timer(4);
		
		//Embedded resources:		
		[Embed(source = 'graphics/icons.png')]	private var im_icons:Class;
		[Embed(source = 'graphics/logo_blue.png')]	private var im_logo0:Class;
		[Embed(source = 'graphics/logo_purple.png')]	private var im_logo1:Class;
		[Embed(source = 'graphics/logo_red.png')]	private var im_logo2:Class;
		[Embed(source = 'graphics/logo_orange.png')]	private var im_logo3:Class;
		[Embed(source = 'graphics/logo_green.png')]	private var im_logo4:Class;
		[Embed(source = 'graphics/logo_cyan.png')]	private var im_logo5:Class;
		[Embed(source = 'graphics/logo_gray.png')]	private var im_logo6:Class;
		[Embed(source = 'graphics/logo_shadow.png')]	private var im_logo7:Class;
		
		[Embed(source = 'graphics/tutorial_longnote.png')]	private var im_tutorialimage0:Class;
		[Embed(source = 'graphics/tutorial_drag.png')]	private var im_tutorialimage1:Class;
		[Embed(source = 'graphics/tutorial_timelinedrag.png')]	private var im_tutorialimage2:Class;
		[Embed(source = 'graphics/tutorial_patterndrag.png')]	private var im_tutorialimage3:Class;
		[Embed(source = 'graphics/tutorial_secret.png')]	private var im_tutorialimage4:Class;
	}
}