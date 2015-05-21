package com.newgonzo.midi.file.messages
{
	public class MetaEventMessageType
	{
		public static const SEQUENCE_NUM:uint = 0x00;
		
		public static const TEXT:uint = 0x01;
		public static const COPYRIGHT:uint = 0x02;
		public static const TRACK_NAME:uint = 0x03;
		public static const INSTRUMENT_NAME:uint = 0x04;
		public static const LYRIC:uint = 0x05;
		public static const MARKER:uint = 0x06;
		public static const CUE_POINT:uint = 0x07;
		public static const PROGRAM_NAME:uint = 0x08;
		public static const DEVICE_NAME:uint = 0x09;
		
		public static const CHANNEL_PREFIX:uint = 0x20;
		public static const MIDI_PORT:uint = 0x21;
		public static const END_OF_TRACK:uint = 0x2F;
		public static const SET_TEMPO:uint = 0x51;
		public static const SMPTE_OFFSET:uint = 0x54;
		public static const TIME_SIGNATURE:uint = 0x58;
		public static const KEY_SIGNATURE:uint = 0x59;
		public static const SEQUENCER_SPECIFIC:uint = 0x7F;
	}
}