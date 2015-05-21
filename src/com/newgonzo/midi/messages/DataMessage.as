package com.newgonzo.midi.messages
{
	public class DataMessage extends Message
	{
		private var midiData1:int;
		private var midiData2:int;
		
		public function DataMessage(status:int, data1:int = 0, data2:int = 0)
		{
			super(status);
			midiData1 = data1;
			midiData2 = data2;
		}
		
		public function get data1():int
		{
			return midiData1;
		}
		
		public function get data2():int
		{
			return midiData2;
		}
		
		public function get combinedData():int
		{
			var combined:int = data2;
			combined <<= 7;
			combined |= data1;
			return combined;
		}
	}
}