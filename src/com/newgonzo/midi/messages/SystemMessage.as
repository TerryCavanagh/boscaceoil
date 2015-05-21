package com.newgonzo.midi.messages
{
	public class SystemMessage extends DataMessage
	{
		private var messageType:int;
		
		public function SystemMessage(type:int, data1:int = 0, data2:int = 0)
		{
			super(MessageStatus.SYSTEM, data1, data2);
			messageType = type;
		}
		
		public function get type():int
		{
			return messageType;
		}
		
		override public function toString():String
		{
			return "[SystemMessage(status=" + MessageStatus.toString(status) + " type=" + SystemMessageType.toString(type) + " data1=" + data1 + " data2=" + data2 + ")]";
		}
	}
}