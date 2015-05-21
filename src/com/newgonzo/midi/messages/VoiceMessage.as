package com.newgonzo.midi.messages
{
	import com.newgonzo.midi.MIDINote;
	
	public class VoiceMessage extends ChannelMessage
	{
		public function VoiceMessage(status:int, channel:int, data1:int = 0, data2:int = 0)
		{
			super(status, channel, data1, data2);
		}
		
		public function get octave():int
		{
			return Math.floor(data1 / 12) - 1;
		}
		
		public function get pitch():uint
		{
			return uint(data1);
		}
		
		public function get note():uint
		{
			return pitch % 12;
		}
		
		public function get velocity():uint
		{
			return uint(data2);
		}
		
		override public function toString():String
		{
			return "[VoiceMessage(status=" + MessageStatus.toString(status) + " channel=" + channel + " note=" + MIDINote.toString(note) + " octave=" + octave + " velocity=" + velocity + ")]";
		}
	}
}