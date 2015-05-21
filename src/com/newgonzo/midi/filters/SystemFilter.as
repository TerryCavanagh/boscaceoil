package com.newgonzo.midi.filters
{
	import com.newgonzo.midi.messages.Message;
	import com.newgonzo.midi.messages.SystemMessage;
	
	public class SystemFilter extends AbstractFilter implements IMessageFilter
	{
		private var allowTypes:Array;
		
		public function SystemFilter(allowTypes:Array = null, filter:IMessageFilter = null)
		{
			super(filter);
			this.allowTypes = allowTypes;
		}
		
		public function get types():Array
		{
			return allowTypes;
		}
		
		public function set types(value:Array):void
		{
			allowTypes = value;
		}
		
		override public function accepts(message:Message):Boolean
		{
			var sysMsg:SystemMessage = message as SystemMessage;

			return sysMsg && (!allowTypes || allowTypes.indexOf(sysMsg.type) != -1) && super.accepts(sysMsg);
		}
	}
}