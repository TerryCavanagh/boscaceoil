package com.newgonzo.midi.messages
{
	public class SystemMessageType 
	{
		public static const SYS_EX_START:int = 0x0;
		public static const MIDI_TIME_CODE:int = 0x1;
		public static const SONG_POSITION:int = 0x2;
		public static const SONG_SELECT:int = 0x3;
		public static const TUNE_REQUEST:int = 0x6;
		public static const SYS_EX_END:int = 0x7;
		public static const TIMING_CLOCK:int = 0x8;
		public static const START:int = 0xA;
		public static const CONTINUE:int = 0xB;
		public static const STOP:int = 0xC;
		public static const ACTIVE_SENSING:int = 0xE;
		public static const SYSTEM_RESET:int = 0xF;
		
		public static function toString(value:int):String
		{
			switch(value)
			{
				case SYS_EX_START: return "SYS_EX_START";
				case MIDI_TIME_CODE: return "MIDI_TIME_CODE";
				case SONG_POSITION: return "SONG_POSITION";
				case SONG_SELECT: return "SONG_SELECT";
				case TUNE_REQUEST: return "TUNE_REQUEST";
				case SYS_EX_END: return "SYS_EX_END";
				case TIMING_CLOCK: return "TIMING_CLOCK";
				case START: return "START";
				case CONTINUE: return "CONTINUE";
				case STOP: return "STOP";
				case ACTIVE_SENSING: return "ACTIVE_SENSING";
				case SYSTEM_RESET: return "SYSTEM_RESET";
			}
			
			return "UNKNOWN";
		}
	}
}