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

	/**
	 */
	public class ChannelItem extends MessageItem{
		public var _channel:uint;
		public var _command:uint;
		public var _data1:uint;
		public var _data2:*;

		public function ChannelItem():void{
			super();
		}
		
		public function get channel():uint{
			return _channel;
		}
		
		public function set channel(c:uint):void{
			_channel = c&0x0F;
		}
		
		public function get command():uint{
			return _command;
		}
		
		public function set command(c:uint):void{
			_command = c&0xF0;
			kind = _command;
		}
		

		
		public function get data1():uint{
			return _data1;
		}
		
		public function set data1(d:uint):void{
			_data1 = d;
		}
		
		public function get data2():*{
			return _data2;
		}
		
		public function set data2(d:*):void{
			_data2 = d;
		}
		
		override public function clone():MessageItem{
			var item:ChannelItem = new ChannelItem();
			item.kind = this.kind;
			item.timeline = this.timeline;
			item.channel = this.channel;
			item.command = this.command;
			item.data1 = this.data1;
			item.data2 = this.data2;
			return item;
		}
	}
	
}
