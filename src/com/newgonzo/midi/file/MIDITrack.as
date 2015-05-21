package com.newgonzo.midi.file
{
	public class MIDITrack
	{
		private var trackEvents:Array;
		
		public function MIDITrack(events:Array)
		{
			trackEvents = events;
		}
		
		public function get events():Array
		{
			return trackEvents;
		}
		
		public function toString():String
		{
			return "[MIDITrack(events=\n\t" + trackEvents.join("\n\t") + ")]";
		}
	}
}