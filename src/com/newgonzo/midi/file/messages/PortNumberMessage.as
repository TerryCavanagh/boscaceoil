package com.newgonzo.midi.file.messages
{
	public class PortNumberMessage extends MetaEventMessage
	{
		private var portNum:uint;
		
		public function PortNumberMessage(port:uint)
		{
			super(MetaEventMessageType.MIDI_PORT);
		
			portNum = port;
		}
		
		public function get port():uint
		{
			return portNum;
		}
		
		override public function toString():String
		{
			return "[PortNumberMessage(port=" + portNum + ")]";
		}
	}
}