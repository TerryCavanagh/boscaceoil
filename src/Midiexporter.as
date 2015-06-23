package {
	import flash.display.*;
	import flash.geom.*;
  import flash.events.*;
	import flash.utils.*;
  import flash.net.*;
	import ocean.midi.*;
	import ocean.midi.event.*;
	import ocean.midi.model.*;
	
	//Taking Midias library calls away from midicontrol
	public class Midiexporter {
		//MidiFile
		//MidiTrack
		//MetaItem
		//NoteItem
		//ChannelItem
		public function Midiexporter() {
			midifile = new MidiFile;
		}
		
		public function addnewtrack():void {
			midifile.addTrack(new MidiTrack());
		}
		
		public  function nexttrack():void {
			addnewtrack();
			currenttrack = midifile.track(midifile._trackArray.length - 1);
		}
		
		public function writetimesig():void {
			currenttrack._msgList.push(new MetaItem());
			var t:int = currenttrack._msgList.length - 1;
			currenttrack._msgList[t].type = 0x58; // Time Signature
			var myba:ByteArray = new ByteArray();
			myba.writeByte(0x04);
			myba.writeByte(0x02);
			myba.writeByte(0x18);
			myba.writeByte(0x08);
			currenttrack._msgList[t].text = myba;
		}
		
		public function writetempo(tempo:int):void {
			currenttrack._msgList.push(new MetaItem());
			var t:int = currenttrack._msgList.length - 1;
			currenttrack._msgList[t].type = 0x51; // Set Tempo
			var tempoinmidiformat:int = 60000000 / tempo;
			
			var byte1:int = (tempoinmidiformat >> 16) & 0xFF;
			var byte2:int = (tempoinmidiformat >> 8) & 0xFF;
			var byte3:int = tempoinmidiformat & 0xFF;
			
			var myba:ByteArray = new ByteArray();
			myba.writeByte(byte1);
			myba.writeByte(byte2);
			myba.writeByte(byte3);
			currenttrack._msgList[t].text = myba;
		}
		
		
		public function writeinstrument(instr:int, channel:int):void {
			currenttrack._msgList.push(new ChannelItem());
			var t:int = currenttrack._msgList.length - 1;
			currenttrack._msgList[t]._kind = 0xC0; // Program Change
			currenttrack._msgList[t]._command = 192 + channel;
			currenttrack._msgList[t]._data1 = instr;
		}
		
		public function writenote(channel:int, pitch:int, time:int, length:int, volume:int):void {
			volume = volume / 2;
			if (volume > 127) volume = 127;
			
			currenttrack._msgList.push(new NoteItem(channel, pitch, volume, length, time)); 
		}
		
		public var midifile:MidiFile;
		public var currenttrack:MidiTrack;
	}
}