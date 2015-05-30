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


package ocean.midi.controller {
	import de.polygonal.ds.DLinkedList;
	import de.polygonal.ds.DListIterator;
	
	/**
	* Histroy is a singleton class. It holds a stack.
	* All local item operations will be recorded into this global stack.
	* Thus, undo and redo features are performed based on it.
	* @author Efishocean
	* @version 1.0.0
	*/
	public class History {
		private static var singleton:History;
		private var _size:uint;
		private var _stack:DLinkedList;
		private var _iterator:DListIterator;
		public static function getHistory():History{
			if( singleton==null ){
				singleton = new History();
				return singleton;
			}
			else
				return singleton;
		}
		public function get size():uint{
			return _size;
		}
		public function set size(s:uint):void{
			_size = s;
		}
		public function get stack():DLinkedList{
			return _stack;
		}
		public function get iterator():DListIterator{
			return _iterator;
		}
		public function History():void{
			if( singleton!=null ){
				throw new Error("History is a singleton class, use getHistory() instead.");
			}else{
				_size = 128;
				_stack = new DLinkedList();
				// head of _stack should always be empty array.
				_stack.append( new Array() );
				_iterator = _stack.getListIterator();
			}
			
		}
	}
	
}
