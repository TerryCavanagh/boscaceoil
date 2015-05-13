package{
	import flash.display.*;
	import flash.geom.*;
  import flash.events.*;
  import flash.net.*;
	import flash.text.*;
	import flash.display.NativeWindow;
	
	public class gfxbaseclass extends Sprite {
		//Initialise arrays here
		public function gfxbaseclass() {
			
		}
		
		public function initgfx():void {
			//We initialise a few things
			screenscale = 2;
			
			screenwidth = 384; screenheight = 240;
			screenwidthmid = screenwidth / 2; screenheightmid = screenheight / 2;
			screenviewwidth = screenwidth; screenviewheight = screenheight;
			linesize = 10; patternheight = 12; patterncount = 54;
			setzoomlevel(4);
			pianorollposition = linesize * 10;
			
			fontsize.push(0); fontsize.push(0); fontsize.push(0); fontsize.push(0);		
			fontsize.push(0); fontsize.push(0); fontsize.push(0); fontsize.push(0);		
		
			fontsize[0] = 8;
			fontsize[1] = 16;
			fontsize[2] = 24;
			fontsize[3] = 32;
			fontsize[4] = 48;
			
			icons_rect = new Rectangle(0, 0, 16, 16);
			trect = new Rectangle; tpoint = new Point();
			tbuffer = new BitmapData(1, 1, true);
			ct = new ColorTransform(0, 0, 0, 1, 255, 255, 255, 1); //Set to white
			tempicon = new BitmapData(16, 16, false, 0x000000);
			
			backbuffer = new BitmapData(384, 240, false, 0x000000);
			screenbuffer = new BitmapData(384, 240, false, 0x000000);
			
			for (i = 0; i < 400; i++) {
				pal.push(new paletteclass());
			}
			
			buttonpress = 0;
			
			screen = new Bitmap(screenbuffer);
			screen.width = screenwidth * 2;
			screen.height = screenheight * 2; 
			screen.x = 0;
			screen.y = 0; 
			addChild(screen);
		}
		
		public function setzoomlevel(t:int):void {
			zoom = t;
			patternwidth = 22 + (zoom * 8);
		}
		
		public function changewindowsize(t:int):void {
			screenscale = t;
			if (stage && stage.nativeWindow) {
				stage.nativeWindow.width = (screenwidth * t) + 18;
				stage.nativeWindow.height = (screenheight * t) + 45;
			}
		}

		public function settrect(x:int, y:int, w:int, h:int):void {
			trect.x = x;
			trect.y = y;
			trect.width = w;
			trect.height = h;
		}

		public function settpoint(x:int, y:int):void {
			tpoint.x = x;
			tpoint.y = y;
		}
		
		public function makeiconarray():void {
			for (var i:int = 0; i < 6; i++) {
				var t:BitmapData = new BitmapData(16, 16, true, 0x000000);
				var temprect:Rectangle = new Rectangle(i * 16, 0, 16, 16);	
				t.copyPixels(buffer, temprect, tl);
				icons.push(t);
			}
		}	
		
		// Draw Primatives
		public function drawline(x1:int, y1:int, x2:int, y2:int, col:int):void {
			if (x1 > x2) {
				drawline(x2, y1, x1, y2, col);
			}else if (y1 > y2) {
				drawline(x1, y2, x2, y1, col);
			}else {
				tempshape.graphics.clear();
				tempshape.graphics.lineStyle(1, RGB(pal[col].r, pal[col].g, pal[col].b));
				tempshape.graphics.lineTo(x2 - x1, y2 - y1);
				
				shapematrix.translate(x1, y1);
				backbuffer.draw(tempshape, shapematrix);
				shapematrix.translate(-x1, -y1);
			}
		}

		public function drawbox(x1:int, y1:int, w1:int, h1:int, col:int):void {
			settrect(x1, y1, w1, 1); backbuffer.fillRect(trect, RGB(pal[col].r, pal[col].g, pal[col].b));
			settrect(x1, y1 + h1 - 1, w1, 1); backbuffer.fillRect(trect, RGB(pal[col].r, pal[col].g, pal[col].b));
			settrect(x1, y1, 1, h1); backbuffer.fillRect(trect, RGB(pal[col].r, pal[col].g, pal[col].b));
			settrect(x1 + w1 - 1, y1, 1, h1); backbuffer.fillRect(trect, RGB(pal[col].r, pal[col].g, pal[col].b));
		}

		public function cls():void {
			fillrect(0, 0, 384, 240, 1);
		}

		public function fillrect(x1:int, y1:int, w1:int, h1:int, t:int):void {
			settrect(x1, y1, w1, h1);
			backbuffer.fillRect(trect, RGB(pal[t].r, pal[t].g, pal[t].b));
		}
		
		public function drawbuffericon(x:int, y:int, t:int):void {
			buffer.copyPixels(icons[t], icons_rect, new Point(x, y));
		}

		public function drawicon(x:int, y:int, t:int):void {
			backbuffer.copyPixels(icons[t], icons_rect, new Point(x, y));
		}
		
		//Text Functions
		public function initfont():void {			
		  tf_1.embedFonts = true;
			tf_1.defaultTextFormat = new TextFormat("FFF Aquarius Bold Condensed",fontsize[0],0,true);
			tf_1.width = screenwidth; tf_1.height = 48;
			tf_1.antiAliasType = AntiAliasType.NORMAL;
			
		  tf_2.embedFonts = true;
			tf_2.defaultTextFormat = new TextFormat("FFF Aquarius Bold Condensed",fontsize[1],0,true);
			tf_2.width = screenwidth; tf_2.height = 100;
			tf_2.antiAliasType = AntiAliasType.NORMAL;
			
		  tf_3.embedFonts = true;
			tf_3.defaultTextFormat = new TextFormat("FFF Aquarius Bold Condensed",fontsize[2],0,true);
			tf_3.width = screenwidth; tf_3.height = 100;
			tf_3.antiAliasType = AntiAliasType.NORMAL;
			
		  tf_4.embedFonts = true;
			tf_4.defaultTextFormat = new TextFormat("FFF Aquarius Bold Condensed",fontsize[3],0,true);
			tf_4.width = screenwidth; tf_4.height = 100;
			tf_4.antiAliasType = AntiAliasType.NORMAL;
			
		  tf_5.embedFonts = true;
			tf_5.defaultTextFormat = new TextFormat("FFF Aquarius Bold Condensed",fontsize[4],0,true);
			tf_5.width = screenwidth; tf_5.height = 100;
			tf_5.antiAliasType = AntiAliasType.NORMAL;
		}

		public function rprint(x:int, y:int, t:String, col:int, shadow:Boolean = false):void {
			x = x - len(t);
			print(x, y, t, col, false, shadow);
		}

		public function print(x:int, y:int, t:String, col:int, cen:Boolean = false, shadow:Boolean=false):void {
			y -= 3;
			
			tf_1.textColor = RGB(pal[col].r, pal[col].g, pal[col].b);
			tf_1.text = t;
			if (cen) x = screenwidthmid - (tf_1.textWidth / 2) + x;
			
			if (shadow) {
				shapematrix.translate(x+1, y+1);
				tf_1.textColor = RGB(0, 0, 0);
				backbuffer.draw(tf_1, shapematrix);
				
				shapematrix.translate(-x-1, -y-1);
			}
			
			shapematrix.translate(x, y);
			tf_1.textColor = RGB(pal[col].r, pal[col].g, pal[col].b);
			backbuffer.draw(tf_1, shapematrix);
			
			shapematrix.translate(-x, -y);
		}
		
		public function len(t:String, sz:int = 1):int {
			if(sz==1){
				tf_1.text = t;
				return tf_1.textWidth;
			}else if (sz == 2) {
				tf_2.text = t;
				return tf_2.textWidth;
			}else if (sz == 3) {
				tf_3.text = t;
				return tf_3.textWidth;
			}else if (sz == 4) {
				tf_4.text = t;
				return tf_4.textWidth;
			}else if (sz == 5) {
				tf_5.text = t;
				return tf_5.textWidth;
			}
			
			tf_1.text = t;
			return tf_1.textWidth;
		}
		public function hig(t:String, sz:int = 1):int {
			if(sz==1){
				tf_1.text = t;
				return tf_1.textHeight;
			}else if (sz == 2) {
				tf_2.text = t;
				return tf_2.textHeight;
			}else if (sz == 3) {
				tf_3.text = t;
				return tf_3.textHeight;
			}else if (sz == 4) {
				tf_4.text = t;
				return tf_4.textHeight;
			}else if (sz == 5) {
				tf_5.text = t;
				return tf_5.textHeight;
			}
			
			tf_1.text = t;
			return tf_1.textHeight;
		}

		public function rbigprint(x:int, y:int, t:String, r:int, g:int, b:int, cen:Boolean = false, sc:Number = 2):void {
			x = x - len(t, sc);
			bigprint(x, y, t, r, g, b, cen, sc);
		}

		public function bigprint(x:int, y:int, t:String, r:int, g:int, b:int, cen:Boolean = false, sc:Number = 2):void {
			if (r < 0) r = 0; if (g < 0) g = 0; if (b < 0) b = 0;
			if (r > 255) r = 255; if (g > 255) g = 255; if (b > 255) b = 255;
			
			y -= 3;
			
			if (sc == 2) {
				tf_2.text = t;
				if (cen) x = screenwidthmid - (tf_2.textWidth / 2);
				
				shapematrix.translate(x, y);
				tf_2.textColor = RGB(r, g, b);
				backbuffer.draw(tf_2, shapematrix);
				
				shapematrix.translate(-x, -y);
			}else if (sc == 3) {
				tf_3.text = t;
				if (cen) x = screenwidthmid - (tf_3.textWidth / 2);
				
				shapematrix.translate(x, y);
				tf_3.textColor = RGB(r, g, b);
				backbuffer.draw(tf_3, shapematrix);
				
				shapematrix.translate(-x, -y);
			}else if (sc == 4) {
				tf_4.text = t;
				if (cen) x = screenwidthmid - (tf_4.textWidth / 2);
				
				shapematrix.translate(x, y);
				tf_4.textColor = RGB(r, g, b);
				backbuffer.draw(tf_4, shapematrix);
				
				shapematrix.translate(-x, -y);
			}else if (sc == 5) {
				tf_5.textColor = RGB(r, g, b);
				tf_5.text = t;
				if (cen) x = screenwidthmid - (tf_5.textWidth / 2);
				
				shapematrix.translate(x, y);
				backbuffer.draw(tf_5, shapematrix);
				shapematrix.translate(-x, -y);
			}
		}
		
		public function RGB(red:Number,green:Number,blue:Number):Number{
			return (blue | (green << 8) | (red << 16))
		}
		
		//Render functions
		public function normalrender():void {
			backbuffer.unlock();
			
			screenbuffer.lock();
			screenbuffer.copyPixels(backbuffer, backbuffer.rect, tl, null, null, false);
			screenbuffer.unlock();
			
			backbuffer.lock();
		}

		public function render(control:controlclass):void {
			if (control.test) {
				backbuffer.fillRect(new Rectangle(0, 0, screenwidth, 10), 0x000000);
				print(5, 0, control.teststring, 2, false);
			}
			
			normalrender();
		}
		  
		public var icons:Vector.<BitmapData> = new Vector.<BitmapData>;
		public var ct:ColorTransform;
	  public var icons_rect:Rectangle;
	  public var tl:Point = new Point(0, 0);
		public var trect:Rectangle, tpoint:Point, tbuffer:BitmapData;
		public var i:int, j:int, k:int, l:int, mbi:int, mbj:int;
		
		public var screenwidth:int, screenheight:int;
		public var screenwidthmid:int, screenheightmid:int;
		public var screenviewwidth:int, screenviewheight:int;
		public var screenscale:int;
		public var linesize:int, patternheight:int, patternwidth:int, patterncount:int;
		public var pianorollposition:int;
		
		public var temp:int, temp2:int, temp3:int;
		public var alphamult:uint;
		public var stemp:String;
		public var buffer:BitmapData;
		public var temppal:int;
		
		public var zoom:int, zoomoffset:Number;
		
		public var tempicon:BitmapData;
		//Actual backgrounds
		public var backbuffer:BitmapData;
		public var screenbuffer:BitmapData;
		public var screen:Bitmap;
		//Tempshape
		public var tempshape:Shape = new Shape();
		public var shapematrix:Matrix = new Matrix();
		
		[Embed(source = "graphics/font.swf", symbol = "FFF Aquarius Bold Condensed")]
		public var ttffont:Class;
		public var tf_1:TextField = new TextField();
		public var tf_2:TextField = new TextField();
		public var tf_3:TextField = new TextField();
		public var tf_4:TextField = new TextField();
		public var tf_5:TextField = new TextField();
		public var fontsize:Vector.<int> = new Vector.<int>;
		
		public var pal:Vector.<paletteclass> = new Vector.<paletteclass>;
		
		public var buttonpress:int;
	}
}