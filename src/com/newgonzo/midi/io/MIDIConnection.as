package com.newgonzo.midi.io
{
	import com.newgonzo.midi.MIDIDecoder;
	import com.newgonzo.midi.events.MessageEvent;
	import com.newgonzo.midi.messages.Message;
	
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	public class MIDIConnection extends EventDispatcher implements IMIDIConnection
	{
		protected var decoder:MIDIDecoder;
		protected var isConnected:Boolean = false;
		
		public function MIDIConnection()
		{
		}
		
		public function get connected():Boolean
		{
			return isConnected;
		}
		
		public function connect(...args):void
		{
			decoder = new MIDIDecoder();
			isConnected = true;
		}
		
		public function receiveBytes(data:ByteArray):void
		{
			receiveMessages(decoder.decodeMessages(data));
		}
		
		public function sendBytes(data:ByteArray):void
		{
			//sendMessages(encoder.encodeBytes(data));
		}
		
		public function close():void
		{
			decoder = null;
			isConnected = false;
		}
		
		public function receiveMessages(messages:Array):void
		{
			var message:Message;
			
			for each(message in messages)
			{
				dispatchEvent(new MessageEvent(MessageEvent.MESSAGE, message));
			}	
		}
	}
}