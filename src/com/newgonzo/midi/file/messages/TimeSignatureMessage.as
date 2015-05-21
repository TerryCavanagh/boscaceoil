package com.newgonzo.midi.file.messages
{
	import com.newgonzo.midi.messages.Message;

	public class TimeSignatureMessage extends MetaEventMessage
	{
		private var timeSigNumerator:uint;
		private var timeSigDenominator:uint;
		
		private var midiClocksPerBeat:uint;
		private var midiThirtySecondthsPerQuarter:uint;
		
		public function TimeSignatureMessage(numerator:uint, denominator:uint, clocksPerBeat:uint, thirtySecondthsPerQuarter:uint)
		{
			super(MetaEventMessageType.TIME_SIGNATURE);
			
			timeSigNumerator = numerator;
			timeSigDenominator = denominator;
			midiClocksPerBeat = clocksPerBeat;
			midiThirtySecondthsPerQuarter = thirtySecondthsPerQuarter;
		}
		
		public function get numerator():uint
		{
			return timeSigNumerator;
		}
		
		public function get denominator():uint
		{
			return timeSigDenominator;
		}
		
		public function get clocksPerBeat():uint
		{
			return midiClocksPerBeat;
		}
		
		public function get thirtySecondthsPerQuarter():uint
		{
			return midiThirtySecondthsPerQuarter;
		}
		
		override public function toString():String
		{
			return "[TimeSignatureMessage(numerator=" + timeSigNumerator + " denominator=" + timeSigDenominator + " clocksPerBeat=" + midiClocksPerBeat + " thirtySecondthsPerQuarter=" + midiThirtySecondthsPerQuarter + ")]";
		}
	}
}