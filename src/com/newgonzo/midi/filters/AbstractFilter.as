package com.newgonzo.midi.filters
{
	import com.newgonzo.midi.messages.*;
	
	public class AbstractFilter
	{
		private var innerFilter:IMessageFilter;
		
		public function AbstractFilter(filter:IMessageFilter = null)
		{
			innerFilter = filter;
		}
		
		public function accepts(message:Message):Boolean
		{
			if(!innerFilter || innerFilter.accepts(message))
			{
				return true;
			}
			
			return false;
		}
	}
}