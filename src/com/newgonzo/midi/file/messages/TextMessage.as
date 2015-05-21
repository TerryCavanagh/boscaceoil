package com.newgonzo.midi.file.messages
{
	public class TextMessage extends MetaEventMessage
	{
		private var textValue:String;
		
		public function TextMessage(type:int, text:String)
		{
			super(type);
			
			textValue = text;
		}
		
		public function get text():String
		{
			return textValue;
		}
		
		override public function toString():String
		{
			return "[TextMessage(type=" + type + " text=" + textValue + ")]";
		}
	}
}