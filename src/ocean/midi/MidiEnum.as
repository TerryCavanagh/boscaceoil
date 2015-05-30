/**
 * Copyright(C) 2008 Efishocean
 * 
 * This file is part of Midias.
 *
 * Midias is an ActionScript3 midi lib developed by Efishocean.
 * Midias was extracted from my project 'ocean' which purpose to 
 * impletement a commen audio formats libray. 
 * More infos might appear on my blog http://www.tan66.cn 
 * 
 * Midias is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 * 
 * Midias is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>
 */

package ocean.midi {
	import flash.utils.Dictionary;

	/**
	 * MidiEnum class
	 */
	public class MidiEnum {
		/**
		* Channel message
		*/
		public static const NOTE_OFF:int  	 			=	0x80;		//	????
		public static const NOTE_ON:int   				=	0x90;		//	????
		public static const POLY_PRESSURE:int 			=	0xA0;		//	???????(??)
		public static const CONTROL_CHANGE:int   		=	0xB0;		//	??????
		public static const PROGRAM_CHANGE:int   		=	0xC0;		//	??(??)??
		public static const CHANNEL_PRESSURE:int   		=	0xD0;		//	?????
		public static const PITCH_BEND:int   			=	0xE0;		//	??
		/**
		* Meta message
		*/
		public static const	META:int   			=	0xFF;		//	Meta tag
		public static const	SEQ_NUM:int   		=	0x00;		//  Sequence number
		public static const	TEXT:int   			=	0x01;		//  Text
		public static const	COPY_RIGHT:int   	=	0x02;		//  Copyright notice
		public static const	SEQ_TRK_NAME:int  	= 	0x03;		//  Sequence or track name
		public static const	INSTRUMENT_NAME:int =	0x04;		//  Instrument name
		public static const	LYRIC_TXT:int   	=	0x05;		//  Lyric text
		public static const	MARKER_TXT:int   	=	0x06;		//  Marker text
		public static const	CUE_POINT :int   	=	0x07;		//  Cue point
		public static const	PROGRAM_NAME:int  	= 	0x08;		//  Program name
		public static const	DEVICE_NAME:int  	= 	0x09;		//  Device name
		public static const	CHANNEL_PREFIX:int  = 	0x20;		//  MIDI channel prefix assignment
		public static const	END_OF_TRK:int   	=	0x2F;		//  End of track
		public static const	SET_TEMPO:int   	=	0x51;		//  1/4 Tempo setting
		public static const	SMPTE_OFFSET:int  	= 	0x54;		//  SMPTE offset
		public static const	TIME_SIGN:int   	=	0x58;		//  Time signature
		public static const	KEY_SIGN:int   		=	0x59;		//  Key signature
		public static const	SEQ_SPEC:int   		=	0x7F;		//  Sequencer specific event
		/**
		* System Real Time Message----
		*/
		public static const	TIMING_CLOCK:int  		= 	0xF8;		//  ????
		public static const	RESERVED_0xF9:int  		= 	0xF9;		//	??
		public static const SYS_START:int  			=	0xFA;		//	?????????(????????????????)
		public static const	SYS_CONTINUE:int  		= 	0xFB;		//	???????????????
		public static const SYS_STOP:int  			=	0xFC;		//	??????
		public static const	RESERVED_0xFD:int  		= 	0xFD;		//	??
		public static const	ACTIVE_SENDING:int  	= 	0xFE;		//	??????
		//public static const	SYS_RESET:int  			=	0xFF;		//	????
		/**
		* System message
		*/
		public static const SYSTEM_EXCLUSIVE:int	=	0xF0;		//	???????,????????
		public static const MIDI_TIME_CODE:int  	= 	0xF1;		//	midi???
		public static const SONG_POSITION:int  		= 	0xF2;		//	????
		public static const SONG_SELECT:int  		=	0xF3;		//	??
		public static const	RESERVED_0xF4:int  		= 	0xF4;		//	??
		public static const RESERVED_0xF5:int  		=	0xF5;		//	??
		public static const TUNE_REQUEST:int  		= 	0xF6;		//	??
		public static const	END_OF_SYS_EX:int  		= 	0xF7;		//	??????????
		
		public static const NOTE:int				=	0x00;		// zero can be presents the note kind
		
		private static const _message:Dictionary = new Dictionary(true);
		
		//Initialize the static block
		{
			_message[NOTE_OFF]="NOTE_OFF";
			_message[NOTE_ON]="NOTE_ON";
			_message[POLY_PRESSURE]="POLY_PRESSURE";
			_message[CONTROL_CHANGE]="CONTROL_CHANGE";
			_message[PROGRAM_CHANGE]="PROGRAM_CHANGE";
			_message[CHANNEL_PRESSURE]="CHANNEL_PRESSURE";
			_message[PITCH_BEND]="PITCH_BEND";
			
			_message[META]="META";
			_message[SEQ_NUM]="SEQ_NUM";
			_message[TEXT]="TEXT";
			_message[COPY_RIGHT]="COPY_RIGHT";
			_message[SEQ_TRK_NAME]="SEQ_TRK_NAME";
			_message[INSTRUMENT_NAME]="INSTRUMENT_NAME";
			_message[LYRIC_TXT]="LYRIC_TXT";
			_message[MARKER_TXT]="MARKER_TXT";
			_message[CUE_POINT]="CUE_POINT";
			_message[PROGRAM_NAME]="PROGRAM_NAME";
			_message[DEVICE_NAME]="DEVICE_NAME";
			_message[CHANNEL_PREFIX]="CHANNEL_PREFIX";
			_message[END_OF_TRK]="END_OF_TRK";
			_message[SET_TEMPO]="SET_TEMPO";
			_message[SMPTE_OFFSET]="SMPTE_OFFSET";
			_message[TIME_SIGN]="TIME_SIGN";
			_message[KEY_SIGN]="KEY_SIGN";
			_message[SEQ_SPEC]="SEQ_SPEC";
			
			_message[TIMING_CLOCK]="TIMING_CLOCK";
			_message[RESERVED_0xF9]="RESERVED_0xF9";
			_message[SYS_START]="SYS_START";
			_message[SYS_CONTINUE]="SYS_CONTINUE";
			_message[SYS_STOP]="SYS_STOP";
			_message[RESERVED_0xFD]="RESERVED_0xFD";
			_message[ACTIVE_SENDING]="ACTIVE_SENDING";
			//_message[SYS_RESET]="SYS_RESET";
			
			_message[SYSTEM_EXCLUSIVE]="SYSTEM_EXCLUSIVE";
			_message[MIDI_TIME_CODE]="MIDI_TIME_CODE";
			_message[SONG_POSITION]="SONG_POSITION";
			_message[SONG_SELECT]="SONG_SELECT";
			_message[RESERVED_0xF4]="RESERVED_0xF4";
			_message[RESERVED_0xF5]="RESERVED_0xF5";
			_message[TUNE_REQUEST]="TUNE_REQUEST";
			_message[END_OF_SYS_EX]="END_OF_SYS_EX";
			
			_message[NOTE]="NOTE";
			//_message[]="";
			//_message[]="";
			//_message[]="";
			//_message[]="";
			//_message[]="";
		}
		/**
		* Initializes the static dictionary.
		*/
		public function MidiEnum():void{
			undefined;
		}
		
		/**
		 * @param n message value.
		 * @return message name. 
		 */
		public static function getMessageName(n:int):String{
			return _message[n];
		}
		
		
	}
	
}
