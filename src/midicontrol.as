// temporary: ignore the entire contents of this file when building for web
CONFIG::desktop {
package {
	import flash.display.*;
	import flash.geom.*;
  import flash.events.*;
	import flash.utils.*;
  import flash.net.*;
	import flash.filesystem.*;
	import org.si.sion.midi.*;
	import org.si.sion.events.*;
	
	import ocean.midi.*;
	import ocean.midi.event.*;
	import ocean.midi.model.*;
	
	public class midicontrol {
		public static function openfile():void {
			control.stopmusic();	
			
			file = File.desktopDirectory.resolvePath("");
		  file.addEventListener(Event.SELECT, onloadmidi);
			file.browseForOpen("Load .mid File", [midiFilter]);
			
			control.fixmouseclicks = true;
		}
		
		public static function savemidi():void {
			control.stopmusic();	
			
			file = File.desktopDirectory.resolvePath("*.mid");
      file.addEventListener(Event.SELECT, onsavemidi);
			file.browseForSave("Save .mid File");
			
			control.fixmouseclicks = true;
		}
		
		private static function onsavemidi(e:Event):void {    
			file = e.currentTarget as File;
			
			if (!control.fileHasExtension(file, "mid")) {
				control.addExtensionToFile(file, "mid");
			}
			
			convertceoltomidi();
			
			tempbytes = new ByteArray();
			tempbytes = clone(midifile.output());
			
			stream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(tempbytes, 0, tempbytes.length);
			stream.close();
			
			control.fixmouseclicks = true;
			control.showmessage("SONG EXPORTED AS MIDI");
		}
		
		private static function onloadmidi(e:Event):void {  
			mididata = new ByteArray();
			file = e.currentTarget as File;
			
			stream = new FileStream();
			stream.open(file, FileMode.READ);
			stream.readBytes(mididata);
			stream.close();
			
			tempbytes = new ByteArray;
			tempbytes = clone(mididata);
			midifile = new MidiFile;
			midifile.input(tempbytes);
			
			smfData.loadBytes(mididata);
			
			var track:SMFTrack;
			var event:SMFEvent;
			
			clearnotes();
			resetinstruments();
			
			trace(smfData.toString());
			
			for (var trackn:int = 0; trackn < smfData.numTracks; trackn++) {
				trace("Reading track " + String(trackn) + ": " + String(smfData.tracks[trackn].sequence.length));
				for each(event in smfData.tracks[trackn].sequence) {
					trace("msg: " + String(event.time) + ": " + event.toString());
					switch (event.type & 0xf0) {
						case SMFEvent.NOTE_ON:
							if(event.velocity == 0) {
								//This is *actually* a note off event in disguise
								changenotelength(event.time, event.note, event.channel);
							}else{
								addnote(event.time, event.note, event.channel);
								if (event.velocity > channelvolume[event.channel]) {
									channelvolume[event.channel] = event.velocity;
								}
							}
						break;
						case SMFEvent.NOTE_OFF:
							changenotelength(event.time, event.note, event.channel);
						break;
						case SMFEvent.PROGRAM_CHANGE:
							channelinstrument[event.channel] = event.value;
						break;
					}
				}
			} 
			
			channelinstrument[9] = 142;
			
			convertmiditoceol();
			
			control.arrange.currentbar = 0; control.arrange.viewstart = 0;
			control.changemusicbox(0);
			
			/*
			control._driver.setBeatCallbackInterval(1);
			control._driver.setTimerInterruption(1, null);
      control._driver.play(smfData, false);
			*/
      
			control.showmessage("MIDI IMPORTED");
			control.fixmouseclicks = true;
		}
		
		public static function clone(source:Object):* { 
			var myBA:ByteArray = new ByteArray(); 
			myBA.writeObject(source); 
			myBA.position = 0; 
			return(myBA.readObject()); 
		}
		
		public static function resetinstruments():void {
			if (channelinstrument.length == 0) {
				for (var i:int = 0; i < 16; i++) {
					channelinstrument.push(-1);
					channelvolume.push(0);
				}
			}else {
				for (i = 0; i < 16; i++) {
					channelinstrument[i] = -1;
					channelvolume[i] = 0;
				}
			}
		}
		
		public static function clearnotes():void {
			unmatchednotes = new Vector.<Rectangle>;
			midinotes = new Vector.<Rectangle>;
		}
		
		public static function addnote(time:int, note:int, instr:int):void {
			unmatchednotes.push(new Rectangle(time, note, 0, instr));
			//trace("adding note: ", time, note, instr);
		}
		
		public static function changenotelength(time:int, note:int, instr:int):void {
			//Find the first note of that pitch and instrument BEFORE given time.
			var timedist:int = -1;
			var currenttimedist:int = 0;
			var matchingnote:int = -1;
			for (var i:int = 0; i < unmatchednotes.length; i++) {
				if (unmatchednotes[i].y == note && unmatchednotes[i].height == instr) {
					currenttimedist = time - unmatchednotes[i].x;
					if (currenttimedist >= 0) {
						if (timedist == -1) {
							timedist = currenttimedist;
							matchingnote = i;
						}else {
							if (currenttimedist < timedist) {
								timedist = currenttimedist;
								matchingnote = i;
							}
						}
					}
				}
			}
			
			if (matchingnote != -1) {
				unmatchednotes[matchingnote].width = -1;
			  midinotes.push(new Rectangle(unmatchednotes[matchingnote].x, 
																		 unmatchednotes[matchingnote].y, 
																		 time, 
																		 unmatchednotes[matchingnote].height));
				
        //Swap matching note with last note, and pop it off
				if (matchingnote != unmatchednotes.length - 1) {					
					var swp:int;
					
					swp = unmatchednotes[matchingnote].x;
					unmatchednotes[matchingnote].x = unmatchednotes[unmatchednotes.length - 1].x;
					unmatchednotes[unmatchednotes.length - 1].x = swp;
					
					swp = unmatchednotes[matchingnote].y;
					unmatchednotes[matchingnote].y = unmatchednotes[unmatchednotes.length - 1].y;
					unmatchednotes[unmatchednotes.length - 1].y = swp;
					
					swp = unmatchednotes[matchingnote].width;
					unmatchednotes[matchingnote].width = unmatchednotes[unmatchednotes.length - 1].width;
					unmatchednotes[unmatchednotes.length - 1].width = swp;
					
					swp = unmatchednotes[matchingnote].height;
					unmatchednotes[matchingnote].height = unmatchednotes[unmatchednotes.length - 1].height;
					unmatchednotes[unmatchednotes.length - 1].height = swp;
				}
			}
			
			if (unmatchednotes.length > 0) {
				if (unmatchednotes[unmatchednotes.length - 1].width == -1) {
					unmatchednotes.pop();
				}
			}
		}
		
		public static function getsonglength():int {
			return int(smfData.measures);
		}
		
		public static function reversechannelinstrument(t:int):int {
			//Given instrument number t, return first channel using it.
			for (var i:int = 0; i < 16; i++) {
				if (channelinstrument[i] == t) return i;
			}
			return -1;
		}
		
		public static function gettopbox(currentpattern:int, chan:int):int {
			//return the first musicbox to either match instrument or be empty
			if (chan == 9) {
				//Drums, put it on the last row
				if(control.arrange.bar[currentpattern].channel[7] == -1) {
					return 7;
				}else {
					if (reversechannelinstrument(channelinstrument[control.musicbox[control.arrange.bar[currentpattern].channel[7]].instr]) == reversechannelinstrument(channelinstrument[chan])) {
						return 7;
					}	
				}
			}
			
			
			for (var i:int = 0; i < 8; i++) {
				if(control.arrange.bar[currentpattern].channel[i] == -1) {
					return i;
				}else {
					if (channelinstrument[chan] != -1) {
						if (reversechannelinstrument(channelinstrument[control.musicbox[control.arrange.bar[currentpattern].channel[i]].instr]) == reversechannelinstrument(channelinstrument[chan])) {
							return i;
						}	
					}					
				}
			}
			return -1;
		}
		
		public static function getmusicbox(currentpattern:int, chan:int):int {
			//Find (or create a new) music box at the position we're placing the note.
			var top:int = gettopbox(currentpattern, chan);
			
			if (top > -1) {
				if (control.arrange.bar[currentpattern].channel[top] == -1) {
					control.currentinstrument = chan;
					if (channelinstrument[chan] > -1) {
						control.voicelist.index = channelinstrument[chan];
						control.changeinstrumentvoice(control.voicelist.name[control.voicelist.index]);
					}else {
						control.voicelist.index = 0;
						control.changeinstrumentvoice(control.voicelist.name[control.voicelist.index]);
					}
					control.addmusicbox();
					control.arrange.addpattern(currentpattern, top, control.numboxes - 1);
					return control.numboxes - 1;
				}else {
					return control.arrange.bar[currentpattern].channel[top];
				}
			}
			
			return -1;
		}
		
		public static function addnotetoceol(currentpattern:int, time:int, pitch:int, notelength:int, chan:int):void {
			//control.musicbox[currentpattern + (instr * numpatterns)].addnote(time, pitch, notelength);
			currentpattern = getmusicbox(currentpattern, chan);
			if(currentpattern>-1){
				control.musicbox[currentpattern].addnote(time, pitch, notelength);
			}
		}
		
		public static function replaceontimeline(_old:int, _new:int):void {
			for (var i:int = 0; i < numpatterns; i++) {
				for (var j:int = 0; j < 8; j++) {
					if (control.arrange.bar[i].channel[j] == _old) {
						control.arrange.bar[i].channel[j] = _new;
					}
				}
			}
		}
		
		public static function musicboxmatch(a:int, b:int):Boolean {
			if (control.musicbox[a].numnotes == control.musicbox[b].numnotes) {
				if (control.musicbox[a].instr == control.musicbox[b].instr) {
					for (var i:int = 0; i < control.musicbox[a].numnotes; i++) {
						if (control.musicbox[a].notes[i].x != control.musicbox[b].notes[i].x) {
							return false;
						}
					}
					return true;
				}
			}
			return false;
		}
		
		
		public static function convertmiditoceol():void {
			control.newsong();
			control.numboxes = 0;
			control.bpm = (smfData.bpm - (smfData.bpm % 5));
			if (control.bpm <= 10) control.bpm = 120;
			control._driver.bpm = control.bpm;
			control._driver.play(null, false);
			
			//for (var tst:int = 0; tst < 16; tst++) {
			//	trace("channel " + String(tst) + " uses instrument " + String(channelinstrument[tst]) + " at volume " + String(channelvolume[tst]));
			//}
			
			resolution = smfData.resolution;
			signature = smfData.signature_d;
			numnotes = smfData.signature_d * smfData.signature_n;
			if (signature == 0 || numnotes == 0) {
				signature = 4;
				numnotes = 16;
			}
			if (numnotes > 16) control.doublesize = true;
			
			var boxsize:int = resolution;
			numpatterns = getsonglength();
			control.numboxes = 0;
			control.arrange.bar[0].channel[0] = -1;
			
			control.numinstrument = 16;
			for (var j:int = 0; j < 16; j++) {
			  control.currentinstrument = j;
				control.voicelist.index = 132; //Set to chiptune noise if not used
				control.changeinstrumentvoice(control.voicelist.name[control.voicelist.index]);
					
				if (channelinstrument[j] > -1) {
					control.voicelist.index = channelinstrument[j];
					control.changeinstrumentvoice(control.voicelist.name[control.voicelist.index]);
					
					control.instrument[control.currentinstrument].setvolume((channelvolume[j] * 256) / 128);
					control.instrument[control.currentinstrument].updatefilter();
					if (control.instrument[control.currentinstrument].type > 0) {
						control.drumkit[control.instrument[control.currentinstrument].type-1].updatevolume((channelvolume[j] * 256) / 128);
					}
				}
			}
			
			for (var i:int = 0; i < midinotes.length; i++) {
				//x = time
				//y = note
				//w = length
				//h = instrument
				var note:int = ((midinotes[i].x * numnotes) / boxsize);
				var notelength:int = (((midinotes[i].width - midinotes[i].x - 1) * numnotes) / boxsize) + 1;
				var currentpattern:int = int((midinotes[i].x  - (midinotes[i].x % boxsize)) / boxsize);
				
				addnotetoceol(currentpattern, note - (numnotes * currentpattern), midinotes[i].y, notelength, midinotes[i].height);
			}
			
			//Optimising stage: Check for duplicate patterns and remove unused ones.
			for (i = 0; i < control.numboxes; i++) {
				var currenthash:int = control.musicbox[i].hash;
				if (currenthash != -1) {
					for (j = i + 1; j < control.numboxes; j++) {
						if (control.musicbox[j].hash == currenthash) {
							//Probably a match! Let's compare and remove if so
							if (musicboxmatch(i, j)) {
								replaceontimeline(j, i);
								control.musicbox[j].hash = -1;
							}
						}
					}
				}
			}
			
			//Delete unused boxes
			i = control.numboxes;
			while (i >= 0) {
				if (i < control.numboxes) {
					if (control.musicbox[i].hash == -1) {
						control.deletemusicbox(i);
					}
				}
			  i--;	
			}
			
			control.arrange.loopstart = 0;
			control.arrange.loopend = control.arrange.lastbar;	
			if (control.arrange.loopend <= control.arrange.loopstart) {
				control.arrange.loopend = control.arrange.loopstart + 1;
			}
		}
		
		public static function convertceoltomidi():void {
		  //Export the song currently loaded as a midi.
			//midifile = new MidiFile();
			/*
			trace("num tracks:" + midifile.tracks);
			for (var sel:int = 0 ; sel < midifile.tracks ; sel++) {
				trace("track " + String(sel + 1) + ", data:" + String(midifile.track(sel).trackChannel) + ", channel:" + String(midifile.track(sel).trackChannel));
				for (var i:int = 0 ; i < midifile.track(sel).msgList.length ; i++) {
					if (midifile.track(sel).msgList[i] is ChannelItem) {
						trace(i, "command: " + String(midifile.track(sel).msgList[i]._command) + ", data1:" + String(midifile.track(sel).msgList[i]._data1));
					}
					var index:uint = i+1;
					var time:uint = midifile.track(sel).msgList[i].timeline;
					var len:uint = midifile.track(sel).msgList[i] is NoteItem? midifile.track(sel).msgList[i].duration : null;
					var channel:uint = midifile.track(sel).msgList[i] is NoteItem?midifile.track(sel).msgList[i].channel+1 : midifile.track(sel).trackChannel+1;
					var type:String = MidiEnum.getMessageName(midifile.track(sel).msgList[i].kind);
					var param:String = midifile.track(sel).msgList[i] is NoteItem? midifile.track(sel).msgList[i].pitchName : "else";
					var value:uint = midifile.track(sel).msgList[i] is NoteItem? midifile.track(sel).msgList[i].velocity : null;
					trace("index:" + String(index) + ", time:" + String(time) + ", len:+" + String(len) + ", channel:" + String(channel) + ", event:" + String(type) + ", param:" + String(param) + ", value:" + String(value));
				}				
			}
			*/
			midifile = new MidiFile();
			midifile.addTrack(new MidiTrack());
			currenttrack = midifile.track(0);
			settimesig(4, 4);
			settempo(120);
			
			midifile.addTrack(new MidiTrack());
			currenttrack = midifile.track(1);
			writeinstrument(1, 0);
			writenote(0, 60, 0, 120, 255);
			writenote(0, 63, 120, 120, 255);
			writenote(0, 67, 240, 120, 255);
			writenote(0, 72, 360, 120, 255);
			
			for (var j:int = 0; j < 4; j++) {
				writenote(0, 60 - 24, 0 + (120 * j), 30, 255);
				writenote(0, 63 - 24, 30 + (120 * j), 30, 255);
				writenote(0, 67 - 24, 60 + (120 * j), 30, 255);
				writenote(0, 72 - 24, 90 + (120 * j), 30, 255);
				writenote(0, 60 + 12, 0 + (120 * j), 30, 255);
				writenote(0, 63 + 12, 30 + (120 * j), 30, 255);
				writenote(0, 60 + 12, 60 + (120 * j), 30, 255);
				writenote(0, 67 + 12, 90 + (120 * j), 30, 255);
			}
			
			midifile.addTrack(new MidiTrack());
			currenttrack = midifile.track(1);
			writeinstrument(20, 1);
			
			writenote(1, 48, 0, (120 * 2), 255);
			writenote(1, 55, 240, (120 * 2), 255);
			writenote(1, 48, 480, (120 * 2), 255);
			writenote(1, 55, 620, (120 * 2), 255);
			
			
			midifile.addTrack(new MidiTrack());
			currenttrack = midifile.track(2);
			writeinstrument(40, 2);
			
			writenote(2, 36, 0, (120 * 8), 255);
			
			
			//currenttrack._msgList.push(new NoteItem(1, 67, 127, 120));
			
			//midifile._trackArray[0].list.push(new NoteItem(0, 67, 127, 120));
			//midifile.addTrack(new MidiTrack());
		}
		
		public static function settimesig(numerator:int, denominator:int):void {
			currenttrack._msgList.push(new MetaItem());
			var t:int = currenttrack._msgList.length - 1;
			currenttrack._msgList[t].type = MidiEnum.TIME_SIGN;
			var myba:ByteArray = new ByteArray();
			myba.writeByte(0x04);
			myba.writeByte(0x02);
			myba.writeByte(0x18);
			myba.writeByte(0x08);
			currenttrack._msgList[t].text = myba;
		}
		
		public static function settempo(tempo:int):void {
			currenttrack._msgList.push(new MetaItem());
			var t:int = currenttrack._msgList.length - 1;
			currenttrack._msgList[t].type = MidiEnum.SET_TEMPO;
			var tempoinmidiformat:int = 60000000 / tempo;
			
			var byte1:int = (tempoinmidiformat >> (8 * 2)) & 0xff;
			var byte2:int = (tempoinmidiformat >> (8 * 1)) & 0xff;
			var byte3:int = (tempoinmidiformat >> (8 * 0)) & 0xff;
			
			var myba:ByteArray = new ByteArray();
			myba.writeByte(byte1);
			myba.writeByte(byte2);
			myba.writeByte(byte3);
			currenttrack._msgList[t].text = myba;
		}
		
		public static function writeinstrument(instr:int, channel:int):void {
			currenttrack._msgList.push(new ChannelItem());
			var t:int = currenttrack._msgList.length - 1;
			currenttrack._msgList[t]._kind = MidiEnum.PROGRAM_CHANGE;
			currenttrack._msgList[t]._command = 192 + channel;
			currenttrack._msgList[t]._data1 = instr;
		}
		
		public static function writenote(channel:int, pitch:int, time:int, length:int, volume:int):void {
			volume = volume / 2;
			if (volume > 127) volume = 127;
			
			currenttrack._msgList.push(new NoteItem(channel, pitch, volume, length, time)); 
		}
		
		CONFIG::desktop {
			public static var file:File, stream:FileStream;
		}
		
		public static var mididata:ByteArray;
		public static var resolution:Number;
		public static var signature:Number;
		public static var numnotes:int;
		public static var numpatterns:int;
		
		public static var midiFilter:FileFilter = new FileFilter("Standard MIDI File", "*.mid;*.midi;");
		
		public static var unmatchednotes:Vector.<Rectangle> = new Vector.<Rectangle>;
		public static var midinotes:Vector.<Rectangle> = new Vector.<Rectangle>;
		public static var channelinstrument:Vector.<int> = new Vector.<int>;
		public static var channelvolume:Vector.<int> = new Vector.<int>;
    public static var smfData:SMFData = new SMFData();
		
		//Stuff for exporting
		public static var midifile:MidiFile;
		public static var tempbytes:ByteArray;
		public static var currenttrack:MidiTrack;
	}
}
}