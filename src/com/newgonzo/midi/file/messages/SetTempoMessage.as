package com.newgonzo.midi.file.messages
{
	public class SetTempoMessage extends MetaEventMessage
	{
		private var microsPerQuarter:uint;
		
		public function SetTempoMessage(microsecondsPerQuarter:uint)
		{
			super(MetaEventMessageType.SET_TEMPO);
		
			microsPerQuarter = microsecondsPerQuarter;
		}
		
		public function get microsecondsPerQuarter():uint
		{
			return microsPerQuarter;
		}
		
		public function get tempo():uint
		{
			return 0;
		}
		
		override public function toString():String
		{
			return "[SetTempoMessage(microsPerQuarter=" + microsPerQuarter + ")]";
		}
	}
}