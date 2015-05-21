package com.newgonzo.midi.errors
{
	public class InvalidFormatError extends Error
	{
		public function InvalidFormatError(message:String="", id:int=0)
		{
			super(message, id);
		}
	}
}