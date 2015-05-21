package com.newgonzo.midi
{
	import com.newgonzo.midi.events.ClockEvent;
	import com.newgonzo.midi.filters.SystemFilter;
	import com.newgonzo.midi.io.IMIDIConnection;
	import com.newgonzo.midi.messages.Message;
	import com.newgonzo.midi.messages.SystemMessage;
	import com.newgonzo.midi.messages.SystemMessageType;
	
	import flash.utils.getTimer;
	
	public class MIDIClock extends MIDIReceiver
	{
		// number of tics each
		public static const QUARTERS:int = 24;
		public static const EIGHTHS:int = 12;
		public static const SIXTEENTHS:int = 6;
		public static const THIRTYSECONDTHS:int = 3;
		
		public static const CLOCKS_PER_BEAT:int = 6;
		public static const CLOCKS_PER_QUARTER:int = 24;
		
		public static const TEMPOS_FOR_AVERAGE:int = 15;
		
		private var timingDivision:int = QUARTERS;
		private var count:int = 0;
		
		private var calculatedTempos:Array = new Array();
		private var clockTempo:Number = 0;
		private var averageTempo:Number = 0;
		
		private var previousQuarterTime:Number = 0;
		private var quarterTime:Number = 0;
		
		private var currentBeat:int = 0;
		private var isStopped:Boolean = true;
		
		public function MIDIClock(connection:IMIDIConnection, division:int = QUARTERS)
		{
			super(connection, new SystemFilter([SystemMessageType.TIMING_CLOCK, SystemMessageType.CONTINUE, SystemMessageType.SONG_POSITION, SystemMessageType.START, SystemMessageType.STOP]));
		
			timingDivision = division;
		}
		
		public function set division(value:int):void
		{
			timingDivision = value;
		}
		public function get division():int
		{
			return timingDivision;
		}
		
		public function get tempo():Number
		{
			return averageTempo;
		}
		
		public function get beat():int
		{
			return isStopped ? 1 : 1 + (currentBeat / (timingDivision / CLOCKS_PER_BEAT));
		}
		
		public function get position():Number
		{
			return isStopped ? 1 : beat + (count / CLOCKS_PER_QUARTER);
		}
		
		public function get stopped():Boolean
		{
			return isStopped;
		}
		
		protected function calculateTempo():void
		{
			var quarterDuration:Number = quarterTime - previousQuarterTime;
			clockTempo = 60000 / quarterDuration;
			
			calculatedTempos.push(clockTempo);
			
			var len:int = calculatedTempos.length;
			
			if(len > TEMPOS_FOR_AVERAGE)
			{
				calculatedTempos.shift();
			}
			
			if(len >= TEMPOS_FOR_AVERAGE)
			{
				var tempo:Number = 0;
				var sum:Number = 0;
				
				for each(tempo in calculatedTempos)
				{
					sum += tempo;
				}
				
				averageTempo = sum / calculatedTempos.length;
			}
			else
			{
				averageTempo = clockTempo;
			}
		}
		
		override protected function handleMessage(message:Message):void
		{
			var systemMessage:SystemMessage = message as SystemMessage;
			
			switch(systemMessage.type)
			{
				case SystemMessageType.TIMING_CLOCK:
					handleClock(systemMessage);
					break;
				case SystemMessageType.START:
					handleStart(systemMessage);
					break;
				case SystemMessageType.SONG_POSITION:
					handlePosition(systemMessage);
					break;
				case SystemMessageType.STOP:
					handleStop(systemMessage);
					break;
				case SystemMessageType.CONTINUE:
					handleContinue(systemMessage);
					break;
				default:
					throw new Error("Unrecognized system message: " + systemMessage);
			}
		}
		
		protected function handleClock(message:SystemMessage):void
		{
			count++;
			
			// dispatch clock event
			dispatchEvent(new ClockEvent(ClockEvent.CLOCK));
			
			// update position if not stopped
			if(!isStopped && count % CLOCKS_PER_BEAT == 0)
			{
				currentBeat++;
			}
			
			if(count % timingDivision == 0)
			{
				dispatchEvent(new ClockEvent(ClockEvent.BEAT));
			}
			
			if(count == CLOCKS_PER_QUARTER)
			{
				previousQuarterTime = quarterTime;
				quarterTime = getTimer();//message.time;
				calculateTempo();
				count = 0;
			}
		}

		protected function handleStart(message:SystemMessage):void
		{
			currentBeat = 0;
			count = 0;
			isStopped = false;
			dispatchEvent(new ClockEvent(ClockEvent.START));
		}
		
		protected function handleContinue(message:SystemMessage):void
		{
			isStopped = false;
			dispatchEvent(new ClockEvent(ClockEvent.START));
		}
		
		protected function handlePosition(message:SystemMessage):void
		{
			currentBeat = message.combinedData;
			count = (currentBeat * CLOCKS_PER_BEAT) % CLOCKS_PER_QUARTER;
			
			dispatchEvent(new ClockEvent(ClockEvent.POSITION));
		}
		
		protected function handleStop(message:SystemMessage):void
		{
			isStopped = true;
			dispatchEvent(new ClockEvent(ClockEvent.STOP));
		}
	}
}