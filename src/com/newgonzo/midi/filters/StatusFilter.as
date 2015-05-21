package com.newgonzo.midi.filters
{
	import com.newgonzo.midi.messages.Message;
	
	public class StatusFilter extends AbstractFilter implements IMessageFilter
	{
		private var allowStatus:Array;
		
		public function StatusFilter(allowStatus:Array, filter:IMessageFilter = null)
		{
			super(filter);
			this.allowStatus = allowStatus;
		}
		
		public function get status():Array
		{
			return allowStatus;
		}
		
		public function set status(value:Array):void
		{
			allowStatus = value;
		}
		
		override public function accepts(message:Message):Boolean
		{
			return allowStatus.indexOf(message.status) != -1 && super.accepts(message);
		}
	}
}