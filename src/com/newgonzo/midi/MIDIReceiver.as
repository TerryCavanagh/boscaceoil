package com.newgonzo.midi
{
	import com.newgonzo.midi.events.MessageEvent;
	import com.newgonzo.midi.filters.IMessageFilter;
	import com.newgonzo.midi.io.IMIDIConnection;
	import com.newgonzo.midi.messages.Message;
	
	import flash.events.EventDispatcher;
	
	/**
	 * A MIDIReceiver is a filtered view of a MIDI connection.
	 */
	public class MIDIReceiver extends EventDispatcher
	{
		protected var midiConnection:IMIDIConnection;
		protected var messageFilter:IMessageFilter;
		
		public function MIDIReceiver(connection:IMIDIConnection, filter:IMessageFilter = null)
		{
			midiConnection = connection;
			messageFilter = filter;
			
			midiConnection.addEventListener(MessageEvent.MESSAGE, messageReceived, false, 0, true);
		}
		
		public function get connection():IMIDIConnection
		{
			return midiConnection;
		}
		
		public function get filter():IMessageFilter
		{
			return messageFilter;
		}
		
		protected function handleMessage(message:Message):void
		{
			// override
		}
		
		private function messageReceived(event:MessageEvent):void
		{
			var message:Message = event.message;
			
			if(!messageFilter || messageFilter.accepts(message))
			{
				handleMessage(message);
				dispatchEvent(event);
			}
		}
	}
}