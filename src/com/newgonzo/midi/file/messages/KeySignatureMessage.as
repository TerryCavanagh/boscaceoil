package com.newgonzo.midi.file.messages
{
	import com.newgonzo.midi.messages.Message;

	public class KeySignatureMessage extends MetaEventMessage
	{
		private var numAccidentals:int;
		private var isMinor:Boolean;
		
		public function KeySignatureMessage(accidentals:int, minor:Boolean)
		{
			super(MetaEventMessageType.KEY_SIGNATURE);
			
			numAccidentals = accidentals;
			isMinor = minor;
		}
		
		public function get key():uint
		{
			return 0;
		}
		
		public function get sharps():uint
		{
			return numAccidentals > 0 ? numAccidentals : 0;
		}
		
		public function get flats():uint
		{
			return numAccidentals < 0 ? -numAccidentals : 0;
		}
		
		public function get minor():Boolean
		{
			return isMinor;
		}
		
		override public function toString():String
		{
			return "[KeySignatureMessage(key=" + key + " sharps=" + sharps + " flats=" + flats + " minor=" + isMinor + ")]";
		}
	}
}