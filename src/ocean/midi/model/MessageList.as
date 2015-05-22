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

package ocean.midi.model {
	import ocean.midi.MidiTrack;
	
	/**
	 */
	public dynamic class MessageList extends Array{
				
		public function MessageList():void{
			super();
		}

		/**
		* Export event list as midi track. Will optimize data, as well as filter unkown message.
		* @return
		*/
		public function output():MidiTrack{
			var mt:MidiTrack = new MidiTrack();
			mt.msgList = this.clone();
			return mt;
		}
		
		/**
		* Parse the midi Track, cache as event list in array
		* @param	mt
		* @return
		*/
		public function input(mt:MidiTrack):void{
			for each( var item:* in mt.msgList ){
				this.push( item.clone() );
			}
		}
		
		/**
		* new instance with the same identical contents
		* @return a clone
		*/
		public function clone():MessageList{
			var msgList:MessageList = new MessageList();
			for each( var item:* in this ){
				msgList.push(item.clone());
			}
			return msgList;
		}
		
		
	}
	
}

