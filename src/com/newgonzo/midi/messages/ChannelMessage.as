package com.newgonzo.midi.messages
{
	public class ChannelMessage extends DataMessage
	{
		private var midiChannel:int;
		
		public function ChannelMessage(status:int, channel:int, data1:int = 0, data2:int = 0)
		{
			super(status, data1, data2);
			midiChannel = channel;
		}
		
		public function get channel():int
		{
			return midiChannel;
		}
		
		override public function toString():String
		{
			return "[ChannelMessage(status=" + MessageStatus.toString(status) + " channel=" + midiChannel + " data1=" + data1.toString(16) + " data2=" + data2.toString(16) + ")]";
		}
	}
}