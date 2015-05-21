package com.newgonzo.midi.file.messages
{
	import com.newgonzo.midi.messages.Message;

	public class EndTrackMessage extends MetaEventMessage
	{
		public static const END_OF_TRACK:Message = new EndTrackMessage(MetaEventMessageType.END_OF_TRACK);
		
		public function EndTrackMessage(type:uint)
		{
			super(type);
		}
	}
}