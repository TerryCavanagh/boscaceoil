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
	public class NoteItem extends MessageItem{
		private var _pitch:uint;
		private var _velocity:uint;
		private var _duration:uint;
		private var _channel:uint;
		private static const _pitchName:Array = ["C","Db","D","Eb","E","F","F#","G","G#","A","Bb","B"];
		
		public function NoteItem( c:uint=0 , p:uint=67 , v:uint=127 , d:uint=120, t:int=0 ):void{
			super();
			_channel = c&0x0F;
			_pitch = p&0x7F;
			_velocity = v&0x7F;
			_duration = d;
			
			_timeline = t;
		}
		
		public function get channel():uint{
			return _channel;
		}
		
		public function set channel(c:uint):void{
			_channel = c;
		}
		
		public function get pitch():uint{
			return _pitch;
		}
		
		public function get pitchName():String{
			var level:uint = (_pitch/12>>0);
			var str:String = _pitchName[_pitch%12] + (level?level:"");
			return str;
		}
		
		public function set pitch(p:uint):void{
			_pitch = p;
		}
		
		public function get duration():uint{
			return _duration;
		}
		
		public function set duration(d:uint):void{
			_duration = d;
		}
		
		public function get velocity():uint{
			return _velocity;
		}
		
		public function set velocity(v:uint):void{
			_velocity = v;
		}
		
		override public function clone():MessageItem{
			var item:NoteItem = new NoteItem();
			item.kind = this.kind;
			item.timeline = this.timeline;
			item.channel = this.channel;
			item.duration = this.duration;
			item.pitch = this.pitch;
			item.velocity = this.velocity;
			return item;
		}
	}
	
}
