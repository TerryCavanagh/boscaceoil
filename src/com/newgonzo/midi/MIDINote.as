package com.newgonzo.midi
{
	public class MIDINote
	{
		public static const C:uint = 0;
		public static const C_SHARP:uint = 1;
		public static const D:uint = 2;
		public static const D_SHARP:uint = 3;
		public static const E:uint = 4;
		public static const F:uint = 5;
		public static const F_SHARP:uint = 6;
		public static const G:uint = 7;
		public static const G_SHARP:uint = 8;
		public static const A:uint = 9;
		public static const A_SHARP:uint = 10;
		public static const B:uint = 11;
		
		public static function toString(value:uint):String
		{
			switch(value)
			{
				case C: return "C";
				case C_SHARP: return "C#";
				case D: return "D";
				case D_SHARP: return "D#";
				case E: return "E";
				case F: return "F";
				case F_SHARP: return "F#";
				case G: return "G";
				case G_SHARP: return "G#";
				case A: return "A";
				case A_SHARP: return "A#";
				case B: return "B";
			}
			
			return "UNKNOWN";
		}
	}
}