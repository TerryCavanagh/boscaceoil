package com.newgonzo.midi.file.messages
{
	import com.newgonzo.midi.messages.Message;
	import com.newgonzo.midi.messages.SystemMessageType;

	public class MetaEventMessage extends Message
	{
		private var eventType:uint;
		
		public function MetaEventMessage(type:uint)
		{
			super(SystemMessageType.SYSTEM_RESET);
		
			eventType = type;
		}
		
		public function get type():uint
		{
			return eventType;
		}
	}
}