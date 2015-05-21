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
		public static function init():void {
			for (var i:int; i < 16; i++) {
				channelinstrument.push(0);
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
			
			var track:MIDITrack;
			var event:MIDITrackEvent;
			
			trace("midifile.division = " + String(midifile.division));
			trace("midifile.format = " + String(midifile.format));
			trace("midifile.numTracks = " + String(midifile.numTracks));
			
			var v:VoiceMessage;
			var c:ChannelMessage; 
			var d:DataMessage; 
			
			
			clearnotes();
			
			for each(track in midifile.tracks) {
				for each(event in track.events){
					if (event.message.status == MessageStatus.NOTE_ON) {
						v = event.message as VoiceMessage;
						trace(event.message.toString());
						addnote(event.time, v.pitch, v.channel);
						//trace(event.time, event.message.toString() + ", pitch = " + String(v.pitch));
					}else if (event.message.status == MessageStatus.NOTE_OFF) {
						v = event.message as VoiceMessage;
						//trace(event.time, event.message.toString() + ", pitch = " + String(v.pitch));
					}else if (event.message.status == MessageStatus.PROGRAM_CHANGE) {
						d = event.message as DataMessage;
						c = event.message as ChannelMessage;
						channelinstrument[c.channel] = d.data1;
					}
				}
			} 
			
			
			convertmiditoceol();
			
			control.showmessage("MIDI IMPORTED");
			control.fixmouseclicks = true;
		}
		
		public static function clearnotes():void {
			midinotes = new Vector.<Rectangle>;
		}
		
		public static function addnote(time:int, note:int, instr:int):void {
			midinotes.push(new Rectangle(time, note, 1, instr));
			trace("adding note: ", time, note, instr);
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
			
			//control._driver.setBeatCallbackInterval(1);
			//control._driver.setTimerInterruption(1, null);
      //control._driver.play(smfData, false);
			
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
		
		public static function convertmiditoceol():void {
			control.newsong();
			control.bpm = (smfData.bpm - (smfData.bpm % 5));
			control._driver.bpm = control.bpm;
			
			control.voicelist.index = channelinstrument[0];
			control.changeinstrumentvoice(control.voicelist.name[control.voicelist.index]);
			
			control.addmusicbox(); control.arrange.addpattern(1, 0, 1);
			
			control.numinstrument++;
			control.currentinstrument = 1;
			
			control.voicelist.index = channelinstrument[1];
			control.changeinstrumentvoice(control.voicelist.name[control.voicelist.index]);
			
			control.addmusicbox(); control.arrange.addpattern(0, 1, 2);
			control.addmusicbox(); control.arrange.addpattern(1, 1, 3);
			
			var boxsize:int = (96 * 4);
			
			for (var i:int = 0; i < midinotes.length; i++) {
				//x = time
				//y = note
				//w = length
				//h = instrument
				if(midinotes[i].height == 0){
					var t:Number = ((midinotes[i].x * 16) / boxsize);
					var currentbox:int = int((midinotes[i].x  - (midinotes[i].x % boxsize)) / boxsize);
					control.musicbox[currentbox].addnote(t - (16 * currentbox), midinotes[i].y, midinotes[i].width);
				}else {
					t = ((midinotes[i].x * 16) / boxsize);
					currentbox = int((midinotes[i].x  - (midinotes[i].x % boxsize)) / boxsize);
					control.musicbox[currentbox + 2].addnote(t - (16 * currentbox), midinotes[i].y, midinotes[i].width);
				}
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
		
		public static var midinotes:Vector.<Rectangle> = new Vector.<Rectangle>;
		public static var channelinstrument:Vector.<int> = new Vector.<int>;
	}
}

}