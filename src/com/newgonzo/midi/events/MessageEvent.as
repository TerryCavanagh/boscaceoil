package com.newgonzo.midi.events
{
	import com.newgonzo.midi.messages.Message;
	
	import flash.events.Event;
	
	public class MessageEvent extends Event
	{
		public static const MESSAGE:String = "midiMessage";
		
		private var midiMessage:Message;
		
		public function MessageEvent(type:String, message:Message = null)
		{
			super(type, false, false);
			midiMessage = message;
		}
		
		public function get message():Message
		{
			return midiMessage;
		}
		
		override public function clone():Event
		{
			return new MessageEvent(type, message);
		}
		
		override public function toString():String
		{
			return formatToString("MessageEvent", "message");
		}
	}
}