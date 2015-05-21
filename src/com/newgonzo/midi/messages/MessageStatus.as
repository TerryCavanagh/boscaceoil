package com.newgonzo.midi.messages
{
	import flash.utils.Dictionary;
	
	public class MessageStatus 
	{
		public static const NOTE_OFF:int = 0x80;
		public static const NOTE_ON:int = 0x90;
		public static const KEY_PRESSURE:int = 0xA0;
		public static const CONTROL_CHANGE:int = 0xB0;
		public static const PROGRAM_CHANGE:int = 0xC0;
		public static const CHANNEL_PRESSURE:int = 0xD0;
		public static const PITCH_BEND:int = 0xE0;
		public static const SYSTEM:int = 0xF0;
		public static const INVALID:int = 0x00;
		
		protected static const STRING_TABLE:Dictionary = new Dictionary();
		STRING_TABLE[NOTE_OFF] = "NOTE_OFF";
		STRING_TABLE[NOTE_ON] = "NOTE_ON";
		STRING_TABLE[KEY_PRESSURE] = "KEY_PRESSURE";
		STRING_TABLE[CONTROL_CHANGE] = "CONTROL_CHANGE";
		STRING_TABLE[PROGRAM_CHANGE] = "PROGRAM_CHANGE";
		STRING_TABLE[CHANNEL_PRESSURE] = "CHANNEL_PRESSURE";
		STRING_TABLE[PITCH_BEND] = "PITCH_BEND";
		STRING_TABLE[SYSTEM] = "SYSTEM";
		STRING_TABLE[INVALID] = "INVALID";
		
		public static function isStatus(value:uint):Boolean
		{
			return value != INVALID && STRING_TABLE[value] != null;
		}
		
		public static function toString(value:uint):String
		{
			return STRING_TABLE[value];
		}
	}
}