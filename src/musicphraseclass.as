package {
	import flash.display.*;
	import flash.geom.*;
  import flash.events.*;
  import flash.net.*;
	
	public class musicphraseclass  {
		public function musicphraseclass():void {
			for (var i:int = 0; i < 129; i++) {
				notes.push(new Rectangle(-1, 0, 0, 0));
			}
			for (i = 0; i < 16; i++) {
				cutoffgraph.push(128);
				resonancegraph.push(0);
				volumegraph.push(256);
			}
			clear();
		}
		
		public function clear():void {
			for (var i:int = 0; i < 128; i++) {
				notes[i].setTo(-1, 0, 0, 0);
			}
			
			for (i = 0; i < 16; i++) {
				cutoffgraph[i] = 128;
				resonancegraph[i] = 0;
				volumegraph[i] = 256;
			}
			start = 48; //start at c4
			numnotes = 0;
			instr = 0;
			scale = 0; key = 0;
			
			palette = 0;
			isplayed = false;
			
			recordfilter = 0;
			topnote = -1; bottomnote = 250;
			
			hash = 0;
		}
		
		public function findtopnote():void {
			topnote = -1;
			for (var i:int = 0; i < numnotes; i++) {
				if (notes[i].x > topnote) {
					topnote = notes[i].x;
				}
			}
		}
		
		public function findbottomnote():void {
			bottomnote = 250;
			for (var i:int = 0; i < numnotes; i++) {
				if (notes[i].x < bottomnote) {
					bottomnote = notes[i].x;
				}
			}
		}
		
		public function transpose(amount:int):void {
			for (var i:int = 0; i < numnotes; i++) {
				if (notes[i].x != -1) {
					if (control.invertpianoroll[notes[i].x] + amount != -1) {
						notes[i].x = control.pianoroll[control.invertpianoroll[notes[i].x] + amount];
					}
				}
				if (notes[i].x < 0) notes[i].x = 0;
				if (notes[i].x > 104) notes[i].x = 104;
			}
		}
		
		public function addnote(noteindex:int, note:int, time:int):void {
			if (numnotes < 128) {
				notes[numnotes].setTo(note, time, noteindex, 0);
				numnotes++;
			}
			
			if (note > topnote) topnote = note;
			if (note < bottomnote) bottomnote = note;
			notespan = topnote - bottomnote;
			
			hash = (hash + (note * time)) % 2147483647;
		}
		
		public function noteat(noteindex:int, note:int):Boolean {
			//Returns true if there is a note that intersects the cursor position
			for (var i:int = 0; i < numnotes; i++) {
				if (notes[i].x == note) {
					if (noteindex >= notes[i].width && noteindex < notes[i].width + notes[i].y) {
						return true;
					}
				}
			}
			return false;
		}
		
		public function removenote(noteindex:int, note:int):void {
			//Remove any note that intersects that cursor position!
			for (var i:int = 0; i < numnotes; i++) {
				if (notes[i].x == note) {
					if (noteindex >= notes[i].width && noteindex < notes[i].width + notes[i].y) {
						deletenote(i);
						i--;
					}
				}
			}
			
			findtopnote(); findbottomnote(); notespan = topnote-bottomnote;
		}
		
		public function setnotespan():void {
			findtopnote(); findbottomnote(); notespan = topnote-bottomnote;
		}
		
		public function deletenote(t:int):void {
			//Remove note t, rearrange note vector
			for (var i:int = t; i < numnotes; i++) {
				notes[i].x = notes[i + 1].x;
        notes[i].y = notes[i + 1].y;
        notes[i].width = notes[i + 1].width;
        notes[i].height = notes[i + 1].height;
			}
			numnotes--;
		}
		
		public var notes:Vector.<Rectangle> = new Vector.<Rectangle>;
		public var start:int;
		public var numnotes:int;
		
		public var cutoffgraph:Vector.<int> = new Vector.<int>;
    public var resonancegraph:Vector.<int> = new Vector.<int>;
		public var volumegraph:Vector.<int> = new Vector.<int>;
		public var recordfilter:int;
		
		public var topnote:int, bottomnote:int, notespan:Number;
		
		public var key:int, scale:int;
		
		public var instr:int;
		
		public var palette:int;
		
		public var isplayed:Boolean;
		
		public var hash:int; //massively simplified thing
	}
}
