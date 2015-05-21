package com.newgonzo.midi.io
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	public class MIDISocketConnection extends MIDIConnection
	{
		private var midiSocket:Socket;
		
		public function MIDISocketConnection()
		{
			super();
		}
		
		override public function get connected():Boolean
		{
			return midiSocket ? midiSocket.connected : super.connected;
		}
		
		override public function connect(...args):void
		{
			var host:String = String(args[0]);
			var port:uint = uint(args[1]);
			
			midiSocket = new Socket();
			midiSocket.addEventListener(Event.CONNECT, socketConnected, false, 0, true);
			midiSocket.addEventListener(Event.CLOSE, socketClosed, false, 0, true);
			midiSocket.addEventListener(ProgressEvent.SOCKET_DATA, socketData, false, 0, true);
			midiSocket.addEventListener(IOErrorEvent.IO_ERROR, socketError, false, 0, true);
			midiSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, socketError, false, 0, true);
			midiSocket.connect(host, port);
		}
		
		override public function close():void
		{
			releaseSocket();
			super.close();
		}
		
		protected function releaseSocket():void
		{
			if(!midiSocket)
			{
				return;
			}	
			
			midiSocket.removeEventListener(Event.CONNECT, socketConnected);
			midiSocket.removeEventListener(Event.CLOSE, socketClosed);
			midiSocket.removeEventListener(ProgressEvent.SOCKET_DATA, socketData);
			midiSocket.removeEventListener(IOErrorEvent.IO_ERROR, socketError);
			midiSocket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, socketError);
			
			try
			{
				midiSocket.close();
			}
			catch(e:Error)
			{
				
			}
			
			midiSocket = null;
		}
		
		private function socketConnected(event:Event):void
		{
			super.connect();
			dispatchEvent(event);
		}
		
		private function socketClosed(event:Event):void
		{
			close();
			dispatchEvent(event);
		}
		
		private function socketData(event:ProgressEvent):void
		{
			var data:ByteArray = new ByteArray();
			midiSocket.readBytes(data);
			receiveBytes(data);
		}
		
		private function socketError(event:ErrorEvent):void
		{
			close();
			dispatchEvent(event);
		}
	}
}