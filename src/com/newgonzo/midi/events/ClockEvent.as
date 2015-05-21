package com.newgonzo.midi.events
{
	import flash.events.Event;

	// TODO: Fill this out to reflect the current properties of the MIDIClock instance it came from
	public class ClockEvent extends Event
	{
		public static const CLOCK:String = "midiClock";
		public static const BEAT:String = "midiBeat";
		public static const START:String = "midiStart";
		public static const STOP:String = "midiStop";
		public static const POSITION:String = "midiPosition";
		
		public function ClockEvent(type:String)
		{
			super(type, false, true);
		}
		
		override public function clone():Event
		{
			return new ClockEvent(type);
		}
		
		override public function toString():String
		{
			return formatToString("ClockEvent", "type");
		}
	}
}