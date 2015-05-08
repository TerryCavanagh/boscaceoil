﻿/*
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
	import flash.desktop.NativeApplication;
	import flash.external.ExternalInterface;

	public class Main extends Sprite{
  	include "keypoll.as";
  	include "includes/logic.as";
  	include "includes/input.as";
  	include "includes/render.as";
		
		public function Main():void {
			CONFIG::desktop {
			NativeApplication.nativeApplication.setAsDefaultApplication("ceol");
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvokeEvent);
			}
			
			key = new KeyPoll(stage);
			control = new controlclass();
			gfx.init();
			var tempbmp:Bitmap;
			tempbmp = new im_icons();	gfx.buffer = tempbmp.bitmapData;	gfx.makeiconarray();
			gfx.buffer = new BitmapData(384, 240, false, 0x000000);
			control.voicelist.fixlengths(gfx);
			stage.fullScreenSourceRect = new Rectangle(0, 0, 768, 480);
			addChild(gfx);
			
			control.loadscreensettings(gfx);
			updategraphicsmode(control);
			
			if (CONFIG::desktop) {
				_timer.addEventListener(TimerEvent.TIMER, mainloop);
				_timer.start();
			} else {
				if (ExternalInterface.available) {
					if (_isContainerReady()) {
						_startMainLoop();
					} else {
						// If the container is not ready, set up a Timer to call the
						// container at 100ms intervals. Once the container responds that
						// it's ready, the timer will be stopped.
						var pageReadyTimer:Timer = new Timer(100);
						pageReadyTimer.addEventListener(TimerEvent.TIMER, function (e:TimerEvent):void {
							if (_isContainerReady()) {
								Timer(e.target).stop();
								_startMainLoop();
							}
						});
						pageReadyTimer.start();
					}
				}
			}
		}

		private function _isContainerReady():Boolean {
			return ExternalInterface.call("Bosca._isReady");
		}

		private function _startMainLoop():void {
			_setupContainerCallbacks();
			control.invokeCeolWeb(ExternalInterface.call("Bosca._getStartupCeol"));
			_timer.addEventListener(TimerEvent.TIMER, mainloop);
			_timer.start();
		}

		private function _setupContainerCallbacks():void {
			ExternalInterface.addCallback("getCeolString", control.getCeolString);
			ExternalInterface.addCallback("invokeCeolWeb", control.invokeCeolWeb);
			ExternalInterface.addCallback("newSong", control.newsong);
			ExternalInterface.addCallback("exportWav", control.exportwav);
		}
			
		public function _input():void {
			control.mx = (mouseX / 2);
			control.my = (mouseY / 2);
				
			input(key, gfx, control);
		}
		
    public function _logic():void {
			logic(key, gfx, control);
			help.updateglow();
		}
		
		public function _render():void {
			gfx.backbuffer.lock();
			render(key, gfx, control);			
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
		
		public function updategraphicsmode(control:controlclass):void {
		 	if (control.fullscreen) {
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			}else {
				stage.displayState = StageDisplayState.NORMAL;
			}
			
			control.savescreensettings(gfx);
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
		
		public var gfx:graphicsclass = new graphicsclass();
		public var control:controlclass;
		public var key:KeyPoll;
		
		// Timer information (a shout out to ChevyRay for the implementation)
		public static const TARGET_FPS:Number = 60; // the fixed-FPS we want the control to run at
		private var	_rate:Number = 1000 / TARGET_FPS; // how long (in seconds) each frame is
		private var	_skip:Number = _rate * 10; // this tells us to allow a maximum of 10 frame skips
		private var	_last:Number = -1;
		private var	_current:Number = 0;
		private var	_delta:Number = 0;
		private var	_timer:Timer = new Timer(4);
		
		//Embedded resources:		
		[Embed(source = 'graphics/icons.png')]	private var im_icons:Class;
	}
}