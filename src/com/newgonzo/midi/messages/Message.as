package com.newgonzo.midi.messages
{
	public class Message
	{
		private var midiStatus:uint;
		
		public function Message(status:uint)
		{
			midiStatus = status;
		}
		
		public function get status():uint
		{
			return midiStatus;
		}
		
		public function toString():String
		{
			return "[Message(status=" + MessageStatus.toString(midiStatus) + ")]";
		}
	}
}