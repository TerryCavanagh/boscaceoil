package com.newgonzo.midi.file.messages
{
	public class SequenceNumberMessage extends MetaEventMessage
	{
		private var sequenceValue1:uint;
		private var sequenceValue2:uint;
		
		public function SequenceNumberMessage(value1:uint, value2:uint)
		{
			super(MetaEventMessageType.SEQUENCE_NUM);
		
			sequenceValue1 = value1;
			sequenceValue2 = value2;
		}
		
		override public function toString():String
		{
			return "[SequenceNumberMessage(value1=" + sequenceValue1 + " value2=" + sequenceValue2 + ")]";
		}
	}
}