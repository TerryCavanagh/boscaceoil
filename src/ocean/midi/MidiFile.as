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
	import de.polygonal.ds.Iterator;
	import ocean.midi.model.MetaItem;
	import ocean.midi.model.ChannelItem;
	import ocean.midi.model.MessageItem;
	import ocean.midi.model.MessageList;
	
	
	import flash.utils.ByteArray;
	import ocean.midi.model.NoteItem;

	/**
	 * This class can seralize and unseralize midi file. 
	 * Also provides methods for operating midi header block.
	 * @author Efishocean
	 * @version 1.0.1
	 * @link http://www.tan66.com
	 * @link http://www.tan66.cn
	 */
	public class MidiFile {

		public static const DIV_120:int = 120;
		
		private static const MThd:int = 0x4D546864;
		private static const HDRSIZE:int = 0x00000006;
		
		/**
		* 16bits
		* 0x0000=sigle;  0x0001=multi syn; 0x0002=multi asyn;
		* Indicates the track format of midi
		*/
		private var _format:uint;
		
		/**
		* 16bits
		* Quantity of exist tracks plus one global track,
		*/
		private var _tracks:uint;
		
		/**
		* 16bits
		* Ticks per minute
		*/
		private var _division:uint;
		
		/**
		* Main track in midi file
		*/
		private var _mainTrack:MidiTrack;
		
		/**
		* track array including main track
		*/
		public var _trackArray:Array;
		
		/**
		 * Midi track format, 0/1/2 are available.
		 */
		public function get format():uint{
			return _format&0xFFFF;
		}
		
		/**
		 * @private
		 * @throws InvalidMidiError Shows error message: Midi track format only accept 0,1,2!
		 */
		public function set format(f:uint):void{
			if( 0==f || 1==f || 2==f ){
				_format = f ;
			}
			else{
				throw new InvalidMidiError("Midi track format only accept 0,1,2!");
			}
		}
		
		/**
		 * Property indicates how many tracks in midi file.
		 */
		public function get tracks():uint{
			return _tracks&0xFFFF;
		}
		
		/**
		 * Division of midi.
		 * @default 120
		 */
		public function get division():uint{
			return _division&0xFFFF;
		}
		
		/**
		 * @private
		 * division setter
		 */
		public function set division(d:uint):void{
			_division = d&0xFFFF;
		}
		
		/**
		* Loads midi file or initialize empty midi file for program.
		* @param file Loaded midi file in raw bytes.
		*/
		public function MidiFile(file:ByteArray=null):void{
			_trackArray = new Array();
			if( file ){
				input(file);
			}
			else{
				_format = 1;
				_tracks = 0;
				_division = DIV_120;
			}
		}

		/**
		* Inputs a fileStream to create message list. Stream will forward.
		* @param fileStream Midi file to loaded as stream.
		* @param separate Tries to separate single track to multi-tracks when 'format' is 0
		* with 'separate' set to true. 
		*/
		public function input( fileStream:ByteArray , separate:Boolean=true ):void{
			//check MThd, the midi file header
			if( fileStream.readInt() != MThd ){
				throw new InvalidMidiError("Midi header tag is incorrect, loads file error!");
			}
			
			//check the size of midi header, that is always 0x00000006 now.
			if( fileStream.readInt() != HDRSIZE ){
				throw new InvalidMidiError("Midi header size is incorrect, loads file error!");
			}
			
			//read following infomation
			_format = fileStream.readShort();
			_tracks = fileStream.readShort();
			_division = fileStream.readShort();
			var track:MidiTrack;
			
			//puts every track into track array
			for( var i:uint = 0 ; i<_tracks ; i++ ){
				//unserialize a track data
				track = new MidiTrack( fileStream );
				_trackArray[i] = track;
			}
			
			//separate channels into diffence tracks when the format is 0.
			if( separate && _format==0 ){
				_format = 1;
				//points the main track
				_mainTrack = new MidiTrack();
				var tempArray:Array = new Array();
				var channels:Array = new Array();
				
				for each( var item:MessageItem in _trackArray[0].msgList ){
					if( item is NoteItem ){
						if( channels.indexOf((item as NoteItem).channel)<0 ){
							_tracks++;
							//If the channel is not recorded, create a new track for that channel
							channels.push((item as NoteItem).channel);
							tempArray[(item as NoteItem).channel] = new MessageList();
						}
						tempArray[(item as NoteItem).channel].push(item);
					}
					else if( item is ChannelItem ){
						if( channels.indexOf((item as ChannelItem).channel)<0 ){
							_tracks++;
							//If the channel is not recorded, create a new track for that channel
							channels.push((item as ChannelItem).channel);
							tempArray[(item as ChannelItem).channel] = new MessageList();
						}
						tempArray[(item as ChannelItem).channel].push(item);
					}else{
						_mainTrack.msgList.push(item);
					}
				}
				// set the main track;
				_trackArray[0] = _mainTrack;

				for( i=0 ; i<tempArray.length ; i++ ){
					if( tempArray[i] ){
						track = new MidiTrack();
						track.msgList = tempArray[i];
						_trackArray.push(track);
					}
				}
			}else{
				_mainTrack = _trackArray[0];
			}

		}
		
		/**
		* Outputs a new byte array, presents a valid midi file.
		* @return Midi file data in raw bytes
		*/
		public function output():ByteArray{
			var file:ByteArray = new ByteArray();
			
			// write midi header
			file.writeInt( MThd );
			
			// write midi header size
			file.writeInt( HDRSIZE );
			
			//write following midi infos.
			file.writeShort( _format );
			file.writeShort( _tracks );
			file.writeShort( _division );
			
			//serialize every tracks.
			for( var i:int=0 ; i< _tracks ; i++){
				_trackArray[i].serialize(file);
			}
			
			//get a new bytearray contents the midi file data
			return file;
		}
		
		/**
		* Get a reference of specific track
		* @param num Indicates the track number
		* @return MidiTrack
		* @see MidiTrack
		*/
		public function track(num:uint):MidiTrack{
			if( num >=_tracks )
				return null;
			else
				return _trackArray[num];
		}
		
		/**
		* Add a track to the midi
		* @param track track to be added.
		* @return how many tracks in this midi
		* @see MidiTrack
		*/
		public function addTrack(track:MidiTrack=null):uint{
			
			if( null==track ){
				return addTrack(new MidiTrack());
			}
			else{
				_tracks++;
				return _trackArray.push(track);
			}
		}
		
		/**
		* Delete a track from midi identify by the track no..
		* @param t Indicates whick tracks to be erased.
		* @return Reference of the deleted track.
		* @see MidiTrack
		*/
		public function deleteTrack(t:int):MidiTrack{
			if( t<=0 ){
				//track[0] refers to the main track
				throw new InvalidMidiError("Invalid track number. Can't delete main track.");
			}else if(t>=_tracks){
				throw new InvalidMidiError("Invalid track number. There isn't this track");
			}else{
				//track[t] refers to the t'th track.
				_tracks--;
				return _trackArray.splice(t,1)[0];
			}
		}
		
		/**
		* Sets a track refering to a MidiTrack instance by track num
		* @param t Indicats track number
		* @param track A MidiTrack instance
		* @see MidiTrack
		* @throws InvalidMidiError
		* <p>"Invalid track number. There isn't this track." if appointed track number is overflow.
		* "Should n't set a null midiTrack." when designated midi track is null.</P>
		*/
		public function setTrack(t:int,track:MidiTrack):void{
			if(t>=_tracks || t<0 ){
				throw new InvalidMidiError("Invalid track number. There isn't this track");
			}else if(track==null){
				throw new InvalidMidiError("Should n't set a null midiTrack");
			}else{
				//track[t] refers to the t'th track.
				_trackArray[t]=track;
			}
		}
		
		/**
		* Swaps two track's position
		* @param t1 first track
		* @param t2 second track
		* @throws InvalidMidiError
		* <p>when given track numbers is logical fault.</p>
		*/
		public function swapTrack(t1:int , t2:int ):void{
			if( t1<=0 || t2<=0 ){
				//track[0] refers to the main track
				throw new InvalidMidiError("Invalid track number. Can't swap main track.");
			}else if( t1>=_tracks || t2>=_tracks ){
				throw new InvalidMidiError("Invalid track number. There isn't this track");
			}else{
				var temp:MidiTrack = _trackArray[t1];
				_trackArray[t1] = _trackArray[t2];
				_trackArray[t2] = temp;
				temp = null;
			}
		}
		
		/**
		* Inserts track after special position.
		* @param t Indicates track number
		* @param track A MidiTrack instance to insert. Creates empty track when this param is null by default.
		* @return The amount of tracks after operation.
		* @throws InvalidMidiError
		* <p>when given track number slops over.</p>
		* @see MidiTrack
		*/
		public function insertTrack( t:int , track:MidiTrack=null ):uint{
			if( t>=_tracks || t<0 ){
				throw new InvalidMidiError("Invalid inserting position number.");
			}
			if( null==track ){
				return insertTrack( t, new MidiTrack() );
			}
			else{
				_tracks++;
				_trackArray.splice(t,0,track);
				return _tracks;
			}
		}
		
		/**
		* Disposes the midifile.
		*/
		public function dispose():void{
			for( var i:uint=0 ; i< _trackArray.length ; i++ ){
				_trackArray[i].dispose();
				
			}
			_tracks = 0;
			_division = 0;
			_trackArray = new Array();
		}
		
	}
	
}
