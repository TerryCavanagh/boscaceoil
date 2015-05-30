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
	public class MessageItem {
		public var _timeline:uint;
		public var _kind:uint;
		/**
		 * @default true Means this is an active item while false means to be erased.
		 */
		public var mark:Boolean;
		
		public function MessageItem():void{
			mark = true;
		}
		
		public function set kind(k:uint):void{
			_kind = k;
		}
		
		public function get kind():uint{
			return _kind;
		}
		
		public function get timeline():uint{
			return _timeline;
		}
		
		public function set timeline(t:uint):void{
			_timeline = t;
		}
			
		public function clone():MessageItem{
			var msgItem:MessageItem = new MessageItem();
			msgItem.kind = this.kind;
			msgItem.timeline = this.timeline;
			return msgItem;
		}
	}
	
}
