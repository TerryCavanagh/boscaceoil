package com.newgonzo.midi.messages
{
	import flash.utils.ByteArray;
	
	public class SystemExclusiveMessage extends Message
	{
		private var messageData:ByteArray;
		private var messageType:uint;
		
		public function SystemExclusiveMessage(type:uint, data:ByteArray)
		{
			super(MessageStatus.SYSTEM);
			
			messageType = type;
			messageData = data;
		}
		
		public function get type():uint
		{
			return messageType;
		}
		
		public function get data():ByteArray
		{
			return messageData;
		}
		
		override public function toString():String
		{
			return "[SystemExclusiveMessage(type=" + messageType + " data=" + messageData + ")]";
		}
	}
}