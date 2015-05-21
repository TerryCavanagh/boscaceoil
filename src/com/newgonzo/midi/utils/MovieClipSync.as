package com.newgonzo.midi.utils
{
	import com.newgonzo.midi.MIDIClock;
	import com.newgonzo.midi.events.ClockEvent;
	
	import flash.display.MovieClip;
	
	/**
	 * This class can be used to sync a MovieClip timeline to MIDI clock.
	 */
	public class MovieClipSync
	{
		// 24 is a good default b/c there are 24 MIDI clocks per quarter note beat
		public static const DEFAULT_FRAMES_PER_BEAT:uint = 24;
		
		private var midiClock:MIDIClock;
		
		private var clipTimeline:MovieClip;
		private var clipFrameRate:uint = 0;
		
		private var midiPositionOffset:Number = 0;
		private var clipFrameOffset:uint = 0;
		
		private var synced:Boolean = true;
		
		public function MovieClipSync(clock:MIDIClock, timeline:MovieClip = null, framesPerBeat:uint = 0, positionOffset:Number = 0, frameOffset:uint = 0)
		{
			midiClock = clock;
			clipTimeline = timeline;
			clipFrameRate = framesPerBeat ? framesPerBeat : DEFAULT_FRAMES_PER_BEAT;
			
			midiPositionOffset = positionOffset;
			clipFrameOffset = frameOffset;
			
			initSync();
			updateSync();
		}
		
		public function get clock():MIDIClock
		{
			return midiClock;
		}
		
		public function get timeline():MovieClip
		{
			return clipTimeline;
		}
		public function set timeline(value:MovieClip):void
		{
			clipTimeline = value;
			updateSync();
		}
		
		public function get syncEnabled():Boolean
		{
			return synced;
		}
		public function set syncEnabled(value:Boolean):void
		{
			synced = value;
		}

		protected function initSync():void
		{
			midiClock.addEventListener(ClockEvent.CLOCK, handleMidiClock, false, 0, true);
			midiClock.addEventListener(ClockEvent.POSITION, handleMidiPosition, false, 0, true);
		}
		
		protected function updateSync():void
		{
			if(!clipTimeline) return;
			
			var pos:Number = (midiClock.position + 1) + midiPositionOffset;
			var frame:Number = 1 + Math.round((pos * clipFrameRate) + clipFrameOffset);
			
			if(frame > clipTimeline.totalFrames)
			{
				frame %= clipTimeline.totalFrames;
			}
			
			if(synced && clipTimeline.currentFrame != frame)
			{
				clipTimeline.gotoAndStop(frame);
			}
		}
		
		private function handleMidiClock(event:ClockEvent):void
		{
			updateSync();
		}
		
		private function handleMidiPosition(event:ClockEvent):void
		{
			updateSync();
		}
	}
}