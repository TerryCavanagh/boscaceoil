package com.newgonzo.midi.filters
{
	import com.newgonzo.midi.messages.*;
	
	public class ChannelFilter extends AbstractFilter implements IMessageFilter
	{
		private var acceptedChannels:Array;
		
		public function ChannelFilter(channels:Array = null, filter:IMessageFilter = null)
		{
			super(filter);
			acceptedChannels = channels;
		}
		
		public function get channels():Array
		{
			return acceptedChannels;
		}
		
		public function set channels(value:Array):void
		{
			acceptedChannels = value;
		}
		
		override public function accepts(message:Message):Boolean
		{
			var channelMsg:ChannelMessage = message as ChannelMessage;
			
			return channelMsg && (!acceptedChannels || acceptedChannels.indexOf(channelMsg.channel) != -1) && super.accepts(channelMsg);
		}
	}
}