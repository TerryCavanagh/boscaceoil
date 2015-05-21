package com.newgonzo.midi.file
{
	public class MIDIFile
	{
		private var fileFormat:uint;
		private var midiDivision:uint;
		private var midiTracks:Array;
		
		public function MIDIFile(format:uint, division:uint, tracks:Array = null)
		{
			fileFormat = format;
			midiDivision = division;
			
			midiTracks = tracks ? tracks : new Array();
		}

		public function get format():uint
		{
			return fileFormat;
		}
		
		public function get division():uint
		{
			return midiDivision;
		}
		
		public function get numTracks():uint
		{
			return midiTracks.length;
		}
		
		public function get tracks():Array
		{
			return midiTracks;
		}
		
		public function toString():String
		{
			return "[MIDIFile(format=" + fileFormat + " division=" + midiDivision + " numTracks=" + numTracks + " tracks=\n\t" + midiTracks.join("\n\t") + ")]";
		}
	}
}