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

	import flash.utils.ByteArray;
	import ocean.midi.model.ChannelItem;
	import ocean.midi.model.MessageItem;
	import ocean.midi.model.MessageList;
	import ocean.midi.model.MetaItem;
	import ocean.midi.model.NoteItem;
	import ocean.midi.model.RawItem;
	import ocean.utils.GreedyUINT;
	import ocean.midi.MidiEnum;
	import ocean.midi.model.SysxItem;

	/**
	 * This class handles midi track data serializition and unserializition.
	 * Also provides track header operations.
	 * @author EfishOcean
	 * @version 0.1 2007-7-23 15:21 refact 2007-8-10 1:12
	 * @link http://www.tan66.com
	 * @link http://www.tan66.cn
	 */
	public class MidiTrack {
		/**
		* Track header tag
		*/
		private static const MTrk:int = 0x4D54726B; //[ 0x4D , 0x54 , 0x72 , 0x6B ];
		
		private var _size:uint;
		private var _trackChannel:uint;
		private var _trackPatch:uint;
		/**
		* stores midi events as message list, contents each note with a duration value, that is editable convenience.
		*/
		//private var _msgList:MessageList;
		public var _msgList:MessageList;
		
		/**
		 * Stores the midi event messages as list data structure.
		 * @see ocean.midi.model.MessageList
		 */
		public function get msgList():MessageList{
			return _msgList;
		}
		
		/**
		* @private
		* setter return reference of stored message list
		*/
		public function set msgList(ml:MessageList):void{
			_msgList = ml;
			for each( var item:* in _msgList ){
				if( (item is ChannelItem) && (item.command == MidiEnum.PROGRAM_CHANGE) ){
					_trackChannel = item.channel;
					_trackPatch = item.data1;
					break;
				}
			}
		}
		
		/**
		* Unserializes the incoming stream data to message list.
		* Stream's position will forwards during the process.
		* @param stream A track data comes from midi file. 
		* Creates empty midi track when this param is null by default.
		*/
		public function MidiTrack( stream:ByteArray=null ):void{
			if(stream==null){
				_msgList = new MessageList();
				_size = 0;
			}
			else if( stream.bytesAvailable ){
				_msgList = createList( stream );
			}
		}
		
		/**
		* stable sort. depend on the original index
		* @param a 
		* @param b
		* @return result
		*/
		private function sortCase(a:RawItem,b:RawItem):int{
			if( a.timeline < b.timeline ){
				return -1;
			}
			else if( a.timeline > b.timeline ){
				return 1;
			}
			else if( a.timeline==b.timeline ){
				if( a.index < b.index ){
					return -1;
				}
				else{
					return 1;
				}
			}
			return 0;
		}
		
		/**
		* Converts message list to bytes.
		* Dumps bytes into stream, the stream will forward.
		* @param stream will write serialized bytes, and moving forward.
		* @see #getRawData()
		*/
		public function serialize( stream:ByteArray ):void{
			stream.writeInt( MTrk );
			stream.writeInt( _size );
			var start:uint = stream.position;	//track data start point excluding MTrk and tracksize
			var rawArray:Array = new Array();	//cache the raw items
			var rawItem:RawItem;				//raw item reference
			var guint:GreedyUINT = new GreedyUINT(); //a greedyuint to deal with delta-time
			var kind:uint;
			var index:uint=0;

			//through the message list
			for each( var item:* in _msgList ){
				//reads active item
				if( !item.mark ){
					continue;
				}
				if( item.kind == MidiEnum.META ){
					rawItem = new RawItem();
					rawItem.timeline = item.timeline;		//unfixed deltatime
					rawItem.raw.writeByte( MidiEnum.META );	//meta tag
					rawItem.raw.writeByte( item.type );		//meta type
					guint.value = item.size;				//data size
					rawItem.raw.writeBytes(guint.rawBytes);	//write size as greedy uint
					rawItem.raw.writeBytes(item.text);		//write contents
					if( item.type==MidiEnum.END_OF_TRK )
						rawItem.index = 0xFFFFFF;		//big enough for keep the end-of-track at the end of list
					else
						rawItem.index = index++;		//index is utilized when stably sort rawitems.
					rawArray.push(rawItem);
				}
				else if( item.kind == MidiEnum.NOTE ){
					
					//create note on
					rawItem = new RawItem();
					rawItem.timeline = item.timeline;
					rawItem.noteOn = (item.channel | MidiEnum.NOTE_ON);	//noteOn is utilized when divide note-on and note-off
					rawItem.raw.writeByte( item.pitch );
					rawItem.raw.writeByte( item.velocity );
					rawItem.index = index++;
					rawArray.push(rawItem);

						
					//create note off
					rawItem = new RawItem();
					rawItem.timeline = item.timeline + item.duration;	//note-off carries the duration time.
					rawItem.noteOn = (item.channel | MidiEnum.NOTE_ON);
					rawItem.raw.writeByte( item.pitch );
					rawItem.raw.writeByte( 0x00 );						//note-off has a 0 velocity
					rawItem.index = index++;
					rawArray.push(rawItem);
				}
				else if( item.kind == MidiEnum.SYSTEM_EXCLUSIVE ){
					rawItem = new RawItem();
					rawItem.timeline = item.timeline;
					rawItem.raw.writeByte( MidiEnum.SYSTEM_EXCLUSIVE );
					rawItem.raw.writeByte( item.size );
					rawItem.raw.writeBytes( item.data );
					rawItem.index = index++;
					rawArray.push(rawItem);
					
				}
				else{

					// program-change and channel-pressure only has one data
					if( item.data2==undefined ){
						rawItem = new RawItem();
						rawItem.timeline = item.timeline;
						rawItem.raw.writeByte( item.command | item.channel );
						rawItem.raw.writeByte( item.data1 );	//only one data
						rawItem.index = index++;
						rawArray.push(rawItem);
					}
					// channel event
					else{
						rawItem = new RawItem();
						rawItem.timeline = item.timeline;
						rawItem.noteOn = (item.channel | item.command);
						rawItem.raw.writeByte( item.data1 );
						rawItem.raw.writeByte( item.data2 );
						rawItem.index = index++;
						rawArray.push(rawItem);
						kind = item.kind;
					}
				}
			}
			//sort
			rawArray.sort( sortCase );
			
			//loop write byte
			guint.value = 0;
			var note_on:uint = 0;

			for( var i:uint=0 ; i< rawArray.length ; i++ ){
				guint.value = rawArray[i].timeline - guint.value;
				
				//write proper delta-time
				stream.writeBytes(guint.rawBytes);
				
				//if noteOn is difference, means the sequence is interrupt,*non-note's noteOn is 0.
				if( note_on != rawArray[i].noteOn && rawArray[i].noteOn!=0 ){
					stream.writeByte( rawArray[i].noteOn );
				}
				
				//write message data
				stream.writeBytes(rawArray[i].raw);
				
				//fresh
				guint.value = rawArray[i].timeline;
				note_on = rawArray[i].noteOn;
			}
			
			//write an end of track;
			stream.writeUnsignedInt(0x00FF2F00);
			
			//get the track data size;
			_size = stream.position - start;
			
			//fix the size value
			stream[start-4]=(_size&0xFF000000)>>24;
			stream[start-3]=(_size&0xFF0000)>>16;
			stream[start-2]=(_size&0xFF00)>>8;
			stream[start-1]= (_size&0xFF);
		}
		
		/**
		* Gets a new midi track data. Differs to serialize(), 
		* getRawData() shouldn't be utilized as midi file stream.
		* @return a new byteArray presents the rawData of a midi track.
		* @see #serialize()
		*/
		public function getRawData():ByteArray{
			var rawData:ByteArray = new ByteArray();
			serialize(rawData);
			rawData.position = 0;
			return rawData;
		}
		
		/**
		* Creates midi event messages list from stream. This is an unserialization method.
		* @param stream Reads forward with bytes converted to message.
		* @return New messagelist contents midi events.
		* @see ocean.midi.model.MessageList
		* @see #MidiTrack()
		*/
		public function createList(stream:ByteArray ):MessageList{
			//check MTrk
			if( stream.readInt() != MTrk ){
				throw new InvalidMidiError("MTrk header tag is incorrect, loads file error!");
			}
			
			//get size
			_size = stream.readInt();
			
			//the end position of this track in the stream
			var end:uint = stream.position + _size;
			
			//new message list
			var list:MessageList = new MessageList();
			var metaItem:MetaItem;
			var noteItem:NoteItem;
			var chItem:ChannelItem;
			var queue:Array = new Array();				// not a queue, just a basket for picking unclosed note.
			var guint:GreedyUINT = new GreedyUINT();
			var timeline:uint = 0;
			var byte:uint;								//read one byte
			var char:uint;								//cache byte&0xF0
			var channel:uint;
			var command:uint;
			//loop reading
			while( stream.position < end ){
				
				//get delta time
				guint.stream(stream);
				
				//increasing timeline
				timeline += guint.value;
				
				//get event kind
				byte = stream.readByte()&0xff;
				char = byte&0xF0;
				
				// mete item
				if( byte == MidiEnum.META ){
					metaItem = new MetaItem();	//new
					metaItem.timeline = timeline;	//timeline
					metaItem.kind = byte;
					byte = stream.readByte()&0xff;
					metaItem.type = byte;	//type
					guint.stream(stream);	//size
					
					
					//pass a 0 to readBytes means entire byteArray, be careful!!
					if( guint.value>0 )
						stream.readBytes(metaItem.text,0,guint.value);	//content
					
					//Don't push end of track item.
					if( metaItem.type != MidiEnum.END_OF_TRK )
						list.push(metaItem);
				}
				// program-change and channel-pressure has only one byte of content.
				else if( char == MidiEnum.PROGRAM_CHANGE || char == MidiEnum.CHANNEL_PRESSURE ){
					command = char;
					channel = byte&0x0F;
					chItem = new ChannelItem();
					chItem.timeline = timeline;
					chItem.kind = byte;
					chItem.channel = channel;
					chItem.command = command;
					chItem.data1 = stream.readByte()&0xff;
					list.push(chItem);
					
					//get track's instrument patch
					if( char == MidiEnum.PROGRAM_CHANGE ){
						_trackPatch = chItem.data1;
					}
				}
				// note-on message
				else if( char == MidiEnum.NOTE_ON ){
					command = char;
					channel = byte&0x0F;
					noteItem = new NoteItem();
					noteItem.timeline = timeline;
					noteItem.channel = channel;
					noteItem.kind = MidiEnum.NOTE;
					noteItem.pitch = stream.readByte()&0xff;
					noteItem.velocity = stream.readByte()&0xff;
					if( noteItem.velocity == 0){	//meets a note-off, should pick a conrespond note-on in queue
						for( var i:uint=0 ; i<queue.length ; i++ ){
							if( queue[i].pitch == noteItem.pitch && queue[i].channel == noteItem.channel ){
								//get duration value
								queue[i].duration = noteItem.timeline - queue[i].timeline ;
								queue.splice(i,1);
								break;
							}
						}
					}
					else{
						noteItem.duration = 0;
						list.push(noteItem);
						queue.push(noteItem);
					}
				}
				// note message
				else if( byte < 0x80 ){

					noteItem = new NoteItem();
					noteItem.timeline = timeline;
					noteItem.channel = channel;
					noteItem.kind = MidiEnum.NOTE;
					noteItem.pitch = byte;	//current byte is the pitch
					noteItem.velocity = stream.readByte()&0xff;
					if( command == MidiEnum.NOTE_ON ){
						if( noteItem.velocity == 0){
							for( i=0 ; i<queue.length ; i++ ){
								if( queue[i].pitch == noteItem.pitch && queue[i].channel == noteItem.channel ){
									queue[i].duration = noteItem.timeline - queue[i].timeline ;
									queue.splice(i,1);
									break;
								}
							}
						}
						else{
							noteItem.duration = 0;
							list.push(noteItem);
							queue.push(noteItem);
						}
					}
					//other command
					else{
						chItem = new ChannelItem();
						chItem.timeline = timeline;
						chItem.channel = channel;
						chItem.command = command;
						chItem.data1 = noteItem.pitch;
						chItem.data2 = noteItem.velocity;
						chItem.kind = command|channel;
						list.push(chItem);
					}
					
				}
				// note-off message
				else if	( char == MidiEnum.NOTE_OFF ){
					command = char;
					channel = byte&0x0F;
					
					noteItem = new NoteItem();
					noteItem.timeline = timeline;
					noteItem.channel = channel;
					noteItem.kind = MidiEnum.NOTE;
					noteItem.pitch = stream.readByte()&0xff;	//read the pitch
					noteItem.velocity = stream.readByte()&0xff;
					
					for( i=0 ; i<queue.length ; i++ ){
						if( queue[i].pitch == noteItem.pitch && queue[i].channel == noteItem.channel ){
							queue[i].duration = noteItem.timeline - queue[i].timeline ;
							queue.splice(i,1);
							break;
						}
					}
				}
				// other channel message
				else if ( char == MidiEnum.CONTROL_CHANGE || char == MidiEnum.POLY_PRESSURE || char == MidiEnum.PITCH_BEND ){
					command = char;
					channel = byte&0x0F;
					chItem = new ChannelItem();
					chItem.timeline = timeline;
					chItem.channel = channel;
					chItem.command = command;
					chItem.data1 = stream.readByte()&0xff;
					chItem.data2 = stream.readByte()&0xff;
					//chItem.kind = byte;
					list.push(chItem);
				}
				//sys_ex message
				else if ( byte == MidiEnum.END_OF_SYS_EX || byte == MidiEnum.SYSTEM_EXCLUSIVE){
					//the byte following the 1st 0xF0 is the size of sys_ex.
					//and the sys_ex can end with 0xF7 as well as a certain size.
					// i don't know why this is not specificated in books. Damn it!
					var sysExSize:uint = stream.readByte()&0xff;
					var sysx:SysxItem = new SysxItem();
					sysx.timeline = timeline;
					if( sysExSize > 0 ){
						stream.readBytes(sysx.data,0,sysExSize);
					}
					list.push(sysx);
				}
				//sys message if it was
				else{
					throw new Error("meet system message, strange");
				}
			}
			_msgList = list;
			_trackChannel = channel;
			return list;
		}
		
		/**
		 * method
		 */
		public function dispose():void{
			_size = 0;
			_msgList = new MessageList();
		}
		
		/**
		 * Channel number of this track
		 */
		public function get trackChannel():uint{
			return _trackChannel;
		}
		
		/**
		 * Patch of this track.
		 */
		public function get trackPatch():uint{
			return _trackPatch;
		}
		
		/**
		 * 
		 */
		public function set trackChannel(ch:uint):void{
			for each( var item:* in _msgList ){
				if( (item is ChannelItem) || (item is NoteItem) ){
					item.channel = ch;
				}
			}
		}
		
		public function set trackPatch(ph:uint):void{
			for each( var item:* in _msgList ){
				if( (item is ChannelItem) && (item.command == MidiEnum.PROGRAM_CHANGE) ){
					item.data1 = ph;
					break;
				}
			}
		}
		//public function get 节奏，音调，速度
		//是否需要加入一些对track的乐器，节奏，音调等的操作呢？这些操作是否适合放在轨道0位置初始？
	}
	
}
