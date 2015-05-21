package com.newgonzo.midi.messages
{
	public class InvalidMessage extends Message
	{
		public static const INVALID:Message = new InvalidMessage(MessageStatus.INVALID);
		
		public function InvalidMessage(status:int)
		{
			super(status);
		}
		
		override public function toString():String
		{
			return "[InvalidMessage(status=" + status.toString(16) + ")]";
		}
	}
}