package com.newgonzo.midi.io
{
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;

	public interface IMIDIConnection extends IEventDispatcher
	{
		function sendBytes(value:ByteArray):void
		function receiveBytes(value:ByteArray):void
		
		function get connected():Boolean
		function connect(...args):void
		function close():void
	}
}