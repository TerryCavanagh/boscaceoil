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
	
	import com.newgonzo.midi.MIDIDecoder;
	import com.newgonzo.midi.messages.*;
	import com.newgonzo.midi.file.*;
	
	public class midicontrol {
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
		
    public static var smfData:SMFData = new SMFData();
		public static function openfile():void {
			control.stopmusic();	
			
			file = File.desktopDirectory.resolvePath("");
		  file.addEventListener(Event.SELECT, onloadmidi);
			file.browseForOpen("Load .mid File", [midiFilter]);
		}
		
		private static function onloadmidi(e:Event):void {  
			midiData = new ByteArray();
			file = e.currentTarget as File;
			
			stream = new FileStream();
			stream.open(file, FileMode.READ);
			stream.readBytes(midiData);
			stream.close();
			
			decoder = new MIDIDecoder();
      midifile = decoder.decodeFile(midiData);
			
			smfData.loadBytes(midiData);
			
			var track:MIDITrack;
			var event:MIDITrackEvent;
			
			trace("midifile.division = " + String(midifile.division));
			trace("midifile.format = " + String(midifile.format));
			trace("midifile.numTracks = " + String(midifile.numTracks));
			
			var v:VoiceMessage;
			var c:ChannelMessage; 
			var d:DataMessage; 
			
			clearnotes();
			resetinstruments();
			
			for each(track in midifile.tracks) {
				for each(event in track.events) {
					if (event.message.status == MessageStatus.NOTE_ON) {
						v = event.message as VoiceMessage;
						//trace(event.message.toString());
						if(v.velocity == 0) {
							//This is *actually* a note off event in disguise
							changenotelength(event.time, v.pitch, v.channel);
						}else{
							addnote(event.time, v.pitch, v.channel);
							if (v.velocity > channelvolume[v.channel]) {
								channelvolume[v.channel] = v.velocity;
							}
						}
						//trace(event.time, event.message.toString() + ", pitch = " + String(v.pitch));
					}else if (event.message.status == MessageStatus.NOTE_OFF) {
						v = event.message as VoiceMessage;
						changenotelength(event.time, v.pitch, v.channel);
						//trace(event.time, event.message.toString() + ", pitch = " + String(v.pitch));
					}else if (event.message.status == MessageStatus.PROGRAM_CHANGE) {
						d = event.message as DataMessage;
						c = event.message as ChannelMessage;
						channelinstrument[c.channel] = d.data1;
					}
				}
			} 
			
			convertmiditoceol();
			
			control.arrange.currentbar = 0; control.arrange.viewstart = 0;
			control.changemusicbox(0);
			
			control.showmessage("MIDI IMPORTED");
			control.fixmouseclicks = true;
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
			
			if (unmatchednotes[unmatchednotes.length - 1].width == -1) {
				unmatchednotes.pop();
			}
		}
		
		private static function siononloadmidi(e:Event):void {  
			midiData = new ByteArray();
			file = e.currentTarget as File;
			
			stream = new FileStream();
			stream.open(file, FileMode.READ);
			stream.readBytes(midiData);
			stream.close();
			
			smfData.loadBytes(midiData);
			
			trace(smfData.toString());
			
			var track:SMFTrack;
			var event:SMFEvent;
			/*
			clearnotes();
			
			for each(track in smfData.tracks) {
				for each(event in track.sequence) {
					if (event.type == SMFEvent.NOTE_ON) {
					  trace("NOTE ON", event.note, event.channel, event.type, event.time);
						addnote(event.time, event.note, event.type);
					}else if (event.type == SMFEvent.NOTE_OFF) {
					  trace("NOTE OFF", event.note, event.channel, event.type, event.time);
					}
				}
			} 
			
			convertmiditoceol();
			*/
			control._driver.setBeatCallbackInterval(1);
			control._driver.setTimerInterruption(1, null);
      control._driver.play(smfData, false);
			
      //control._driver.addEventListener(SiONMIDIEvent.NOTE_ON, onNoteOn);
			
			
			/*
			decoder = new MIDIDecoder();
			
      midifile = decoder.decodeFile(midiData);
			
			// a MIDI file has an array of tracks that each contain an array of track events
			var track:MIDITrack;
			var event:MIDITrackEvent;
			
			for each(track in midifile.tracks){
				for each(event in track.events){
					trace("event.time: " + event.time);
					trace("event.message: " + event.message); // [Message(status=...]
				}
			} */
			/*
			loadfilestring(filestring);
			_driver.play(null, false);
			
			*/
			control.showmessage("MIDI IMPORTED");
			control.fixmouseclicks = true;
		}
		
		public static var resolution:Number;
		public static var signature:Number;
		public static var numnotes:int;
		public static var numpatterns:int;
		
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
		
		public static function convertmiditoceol():void {
			control.newsong();
			control.numboxes = 0;
			control.bpm = (smfData.bpm - (smfData.bpm % 5));
			control._driver.bpm = control.bpm;
			control._driver.play(null, false);
			
			for (var tst:int = 0; tst < 16; tst++) {
				trace("channel " + String(tst) + " uses instrument " + String(channelinstrument[tst]) + " at volume " + String(channelvolume[tst]));
			}
			
			//trace(smfData.resolution);
			/*
			trace(smfData.toString());
			trace(smfData.signature_n, smfData.signature_d);
			trace(smfData.measures);
			*/
			
			resolution = smfData.resolution;
			signature = smfData.signature_d;
			numnotes = smfData.signature_d * smfData.signature_n;
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
				var notelength:int = (((midinotes[i].width - midinotes[i].x) * numnotes) / boxsize) + 1;
				var currentpattern:int = int((midinotes[i].x  - (midinotes[i].x % boxsize)) / boxsize);
				
				addnotetoceol(currentpattern, note - (numnotes * currentpattern), midinotes[i].y, notelength, midinotes[i].height);
			}
			
			control.arrange.loopstart = 0;
			control.arrange.loopend = control.arrange.lastbar;	
			if (control.arrange.loopend <= control.arrange.loopstart) {
				control.arrange.loopend = control.arrange.loopstart + 1;
			}
		}
		
		CONFIG::desktop {
			public static var file:File, stream:FileStream;
		}
		
		public static var midifile:MIDIFile;
		public static var decoder:MIDIDecoder;
		public static var midiData:ByteArray;
		
		public static function onNoteOn(e:SiONMIDIEvent):void {
			trace(e.midiChannelNumber, e.note);
    }
		
		public static var midiFilter:FileFilter = new FileFilter("Midi", "*.mid");
		
		public static var unmatchednotes:Vector.<Rectangle> = new Vector.<Rectangle>;
		public static var midinotes:Vector.<Rectangle> = new Vector.<Rectangle>;
		public static var channelinstrument:Vector.<int> = new Vector.<int>;
		public static var channelvolume:Vector.<int> = new Vector.<int>;
	}
}

}