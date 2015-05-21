package com.newgonzo.midi.file
{
	import com.newgonzo.midi.messages.Message;
	
	public class MIDITrackEvent
	{
		private var eventTime:uint;
		private var eventMessage:Message;
		
		public function MIDITrackEvent(time:uint, message:Message)
		{
			eventTime = time;
			eventMessage = message;
		}

		public function get time():uint
		{
			return eventTime;
		}
		
		public function get message():Message
		{
			return eventMessage;
		}
		
		public function toString():String
		{
			return "[MIDITrackEvent(time=" + eventTime + " message=" + eventMessage + ")]";
		}
	}
}