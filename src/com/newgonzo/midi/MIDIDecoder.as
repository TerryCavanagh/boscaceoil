package com.newgonzo.midi
{
	import com.newgonzo.midi.errors.InvalidFormatError;	import com.newgonzo.midi.file.MIDIFile;	import com.newgonzo.midi.file.MIDITrack;	import com.newgonzo.midi.file.MIDITrackEvent;	import com.newgonzo.midi.file.messages.EndTrackMessage;	import com.newgonzo.midi.file.messages.KeySignatureMessage;	import com.newgonzo.midi.file.messages.MetaEventMessageType;	import com.newgonzo.midi.file.messages.PortNumberMessage;	import com.newgonzo.midi.file.messages.SequenceNumberMessage;	import com.newgonzo.midi.file.messages.SetTempoMessage;	import com.newgonzo.midi.file.messages.TextMessage;	import com.newgonzo.midi.file.messages.TimeSignatureMessage;	import com.newgonzo.midi.messages.*;		import flash.utils.ByteArray;	
	public class MIDIDecoder
	{
		public static const MIDI_FILE_HEADER_TAG:uint = 0x4D546864; // MThd
		public static const MIDI_FILE_HEADER_SIZE:uint = 0x00000006;
		public static const MIDI_TRACK_HEADER_TAG:uint = 0x4D54726B; // MTrk
		
		
		public function MIDIDecoder()
		{
		}
		
		public function decodeFile(data:ByteArray):MIDIFile
		{
			if(data.readInt() != MIDI_FILE_HEADER_TAG)
			{
				throw new InvalidFormatError("Invalid MIDI header tag: expected 0x4D546864 (MThd)");
			}
			
			if(data.readInt() != MIDI_FILE_HEADER_SIZE)
			{
				throw new InvalidFormatError("Invalid MIDI header size: expected 0x00000006");
			}
			
			var format:uint = data.readShort();
			var numTracks:uint = data.readShort();
			var timingDivision:uint = data.readShort();
			
			var tracks:Array = new Array();
			var track:MIDITrack;
			var trackHeader:int;
			var trackSize:uint;
			var trackEnd:uint;
			var trackTime:uint;
			
			var events:Array;
			var event:MIDITrackEvent;
			var eventDelta:uint;
			
			var messageBytes:ByteArray;
			var message:Message;
			
			// for midi running status
			var previousStatusByte:uint;
			
			// decode tracks
			var i:uint = 0;
			
			for(; i < numTracks; i++)
			{
				events = new Array();
				
				trackHeader = data.readInt();
				
				// last byte might be a null byte
				if(!data.bytesAvailable) break;
				
				if(trackHeader != MIDI_TRACK_HEADER_TAG)
				{
					throw new InvalidFormatError("Invalid MIDI track header tag at track "  + i + ": expected 0x4D54726B (MTrk)");
				}
				
				trackSize = data.readInt();
				trackEnd = data.position + trackSize;
				trackTime = 0;
				
				while(data.position < trackEnd)
				{
					eventDelta = readVariableLengthUint(data);
					
					trackTime += eventDelta;
					
					if(MessageStatus.isStatus(data[data.position] & 0xF0))
					{
						previousStatusByte = data[data.position];
					}
					
					message = decodeMessage(data, true, previousStatusByte);
					
					if(!message || message == EndTrackMessage.END_OF_TRACK)
					{
						// don't add null or end-of-track messages
						continue;
					}
					
					event = new MIDITrackEvent(trackTime, message);
					events.push(event);
				}
				
				track = new MIDITrack(events);
				tracks.push(track);
			}
			
			var file:MIDIFile = new MIDIFile(format, timingDivision, tracks);
			
			return file;
		}
		
		public function decodeMessages(data:ByteArray):Array
		{
			var messages:Array = new Array();
			var message:Message;
			
			while(data.bytesAvailable)
			{
				message = decodeMessage(data);
				
				if(message)
				{
					messages.push(message);
				}
			}
			
			return messages;
		}
		
		public function decodeMessage(data:ByteArray, inFile:Boolean = false, previousStatusByte:uint = 0):Message
		{
			var byte:uint;
			var status:uint;
			var lsb:uint;
			
			// Need to use the bytes as unsigned. This can be done
			// by using ByteArray's readUnsignedByte() or by masking 
			// the bits we care about: readByte() & OxFF
			byte = data.readUnsignedByte();
			
			// isolate the first and second 4-bits
			status = byte & 0xF0;
			
			// for midi running status: see http://everything2.com/user/arfarf/writeups/MIDI+running+status
			if(inFile && !MessageStatus.isStatus(status))
			{
				// back up the data stream
				data.position--;
				byte = previousStatusByte;
				status = byte & 0xF0;
			}
			
			// channel or system message type
			lsb = byte & 0x0F;
			
			var message:Message;
			
			// MIDI Realtime messages can appear ANYWHERE, even
			// between the two data bytes of a Voice message.
			// TODO: set up handling of real time messages
			
			switch(status)
			{
				case MessageStatus.NOTE_ON:
				case MessageStatus.NOTE_OFF:
				case MessageStatus.KEY_PRESSURE:
				
					message = new VoiceMessage(status, lsb, data.readUnsignedByte(), data.readUnsignedByte());
					break;
					
				case MessageStatus.CONTROL_CHANGE:
				case MessageStatus.PITCH_BEND:
				
					message = new ChannelMessage(status, lsb, data.readUnsignedByte(), data.readUnsignedByte());
					break;
				
				case MessageStatus.PROGRAM_CHANGE:
				case MessageStatus.CHANNEL_PRESSURE:
				
					message = new ChannelMessage(status, lsb, data.readUnsignedByte());
					break;
					
				case MessageStatus.SYSTEM:
					
					message = createSystemMessage(lsb, data, inFile);
					break;
					
				default:
					// not supported or some major problem
					message = new InvalidMessage(status);
					break;
			}
			
			return message;
		}
		
		protected function createSystemMessage(type:int, data:ByteArray, inFile:Boolean = false):Message
		{
			var message:Message;
			
			switch(type)
			{
				case SystemMessageType.SONG_POSITION:
					return new SystemMessage(type, data.readUnsignedByte(), data.readUnsignedByte());
				
				case SystemMessageType.SONG_SELECT:
					return new SystemMessage(type, data.readUnsignedByte());
					
				case SystemMessageType.SYSTEM_RESET:
					return inFile ? createMetaEventMessage(data) : new SystemMessage(type);
					
				case SystemMessageType.SYS_EX_START:
					return createSystemExclusiveMessage(type, data);
					
				default:
					return new SystemMessage(type);
			}
			
			return null;
		}
		
		protected function createMetaEventMessage(data:ByteArray):Message
		{
			var type:uint = data.readUnsignedByte();
			var len:uint = readVariableLengthUint(data);
			
			switch(type)
			{
				case MetaEventMessageType.TEXT:
				case MetaEventMessageType.COPYRIGHT:
				case MetaEventMessageType.TRACK_NAME:
				case MetaEventMessageType.INSTRUMENT_NAME:
				case MetaEventMessageType.LYRIC:
				case MetaEventMessageType.MARKER:
				case MetaEventMessageType.CUE_POINT:
				case MetaEventMessageType.PROGRAM_NAME:
				case MetaEventMessageType.DEVICE_NAME:
					return new TextMessage(type, data.readUTFBytes(len));
				
				case MetaEventMessageType.MIDI_PORT:
					return new PortNumberMessage(data.readUnsignedByte());
					
				case MetaEventMessageType.SET_TEMPO:
					return createSetTempoMessage(data);
					
				case MetaEventMessageType.KEY_SIGNATURE:
					return createKeySignatureMessage(data);
					
				case MetaEventMessageType.TIME_SIGNATURE:
					return createTimeSignatureMessage(data);
					
				case MetaEventMessageType.END_OF_TRACK:
					return EndTrackMessage.END_OF_TRACK;
					
				case MetaEventMessageType.SEQUENCE_NUM:
					return new SequenceNumberMessage(data.readUnsignedByte(), data.readUnsignedByte());
			}
			
			return null;
		}
		
		protected function createSetTempoMessage(data:ByteArray):Message
		{
			var a:uint = data.readUnsignedByte();
			var b:uint = data.readUnsignedByte();
			var c:uint = data.readUnsignedByte();
			
			var micros:uint = a | (b << 8) | (c << 16);
			
			return new SetTempoMessage(micros);
		}
		
		protected function createSystemExclusiveMessage(type:uint, data:ByteArray):Message
		{
			var len:uint = readVariableLengthUint(data);
			var bytes:ByteArray = new ByteArray();
			
			// read all but the last 0xF7 into the data bytes for this SysEx
			data.readBytes(bytes, 0, len - 1);
			
			// gobble the trailing 0xF7
			if(data.readUnsignedByte() != 0xF7)
			{
				throw new InvalidFormatError("SysEx messages must be terminated by 0xF7");
			}
			
			return new SystemExclusiveMessage(type, bytes);
		}
		
		protected function createKeySignatureMessage(data:ByteArray):Message
		{
			var numAccidentals:int = data.readByte();
			
			// 0 for major, 1 for minor
			var isMinor:Boolean = data.readUnsignedByte() == 1;
			
			return new KeySignatureMessage(numAccidentals, isMinor);
		}
		
		protected function createTimeSignatureMessage(data:ByteArray):Message
		{
			var numerator:uint = data.readUnsignedByte();
			
			// time sig denominator is represented as the power to which 2 should be raised
			var denominator:uint = Math.pow(2, data.readUnsignedByte());
			
			var clocksPerClick:uint = data.readUnsignedByte();
			var thirtySecondthsPerQuarter:uint = data.readUnsignedByte();
			
			return new TimeSignatureMessage(numerator, denominator, clocksPerClick, thirtySecondthsPerQuarter);
		}
		
		protected function readVariableLengthUint(data:ByteArray):uint
		{
			var temp:ByteArray = new ByteArray();
			var byte:int;
			
			do
			{
				byte = data.readByte();
				temp.writeByte(byte);
			}
			while(byte & 0x80);
			
			var value:uint = 0;
			var e:int = temp.length - 1;
			
			temp.position = 0;
			
			while(e >= 0)
			{
				value += (temp.readByte() & 0x7F) << (7*e);
				e--;
			}
			
			return value;
		}
	}
}