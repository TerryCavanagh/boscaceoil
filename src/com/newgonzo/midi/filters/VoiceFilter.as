package com.newgonzo.midi.filters
{
	import com.newgonzo.midi.messages.Message;
	import com.newgonzo.midi.messages.VoiceMessage;
	
	public class VoiceFilter extends AbstractFilter implements IMessageFilter
	{
		public function VoiceFilter(filter:IMessageFilter = null)
		{
			super(filter);
		}
		
		override public function accepts(message:Message):Boolean
		{
			var voiceMsg:VoiceMessage = message as VoiceMessage;
			
			return voiceMsg && super.accepts(voiceMsg);
		}
	}
}