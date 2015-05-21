package com.newgonzo.midi.filters
{
	import com.newgonzo.midi.messages.Message;
	
	public interface IMessageFilter
	{
		function accepts(message:Message):Boolean
	}
}