/**
 * Copyright (c) Michael Baczynski 2007
 * http://lab.polygonal.de/ds/
 *
 * This software is distributed under licence. Use of this software
 * implies agreement with all terms and conditions of the accompanying
 * software licence.
 */
package de.polygonal.ds
{
	import flash.utils.Dictionary;
	import de.polygonal.ds.Collection;
	
	/**
	 * A priority queue.
	 * 
	 * <p>The priority queue is based on the heap structure and
	 * manages prioritized data.</p>
	 */
	public class PriorityQueue implements Collection
	{
		private var _heap:Array;
		private var _size:int;
		private var _count:int;
		private var _posLookup:Dictionary;
		
		/**
		 * Initializes a priority queue with a given size.
		 * 
		 * @param size The size of the priority queue.
		 */
		public function PriorityQueue(size:int)
		{
			_heap = new Array(_size = size + 1);
			_posLookup = new Dictionary(true);
			_count = 0;
		}
		
		/**
		 * The priority queue's front item.
		 */
		public function get front():Prioritizable
		{
			return _heap[1];
		}
		
		/**
		 * Enqueues a prioritized object.
		 * 
		 * @param obj The prioritized data.
		 */
		public function enqueue(obj:Prioritizable):void
		{
			_count++;
			_heap[_count] = obj;
			_posLookup[obj] = _count;
			walkUp(_count);
		}
		
		/**
		 * Dequeues the front item, which is the item
		 * with the highest priority.
		 */
		public function dequeue():void
		{
			if (_count >= 1)
			{
				delete _posLookup[_heap[1]];
				
				_heap[1] = _heap[_count];
				walkDown(1);
				delete _heap[_count];
				_count--;
			}
		}
		
		/**
		 * Reprioritizes an item.
		 * 
		 * @param obj         The object whose priority is changed.
		 * @param newPriority The new priority.
		 * @return True if the repriorization succeeded, otherwise false.
		 */
		public function reprioritize(obj:Prioritizable, newPriority:int):Boolean
		{
			if (!_posLookup[obj]) return false;
			
			var oldPriority:int = obj.priority;
			
			//App.tr("old priority=", obj.priority);
			
			obj.priority = newPriority;
			
			//App.tr("new priority=", obj.priority);
			
			var pos:int = _posLookup[obj];
			
			//App.tr("current pos=", pos);
			
			//App.tr("now ", newPriority > p ? "Walkup" : "WalkDown");
			
			newPriority > oldPriority ? walkUp(pos) : walkDown(pos);
			
			return true;
		}
		
		/**
		 * Removes an item.
		 * 
		 * @param obj The object to remove.
		 * @return True if removal succeeded, otherwise false.
		 */
		public function remove(obj:Prioritizable):Boolean
		{
			if (!_posLookup[obj]) return false;
			
			var pos:int = _posLookup[obj];
			delete _posLookup[obj];
			
			_heap[pos] = _heap[_count];
			delete _heap[_count];
			
			walkDown(pos);
			_count--;
			
			return true;
		}
		
		/**
		 * Checks if a given item exists.
		 * 
		 * @return True if the item is found, otherwise false.
		 */
		public function contains(obj:*):Boolean
		{
			for (var i:int = 1; i <= _count; i++)
			{
				if (_heap[i] === obj)
					return true;
			}
			return false;
		}
		
		/**
		 * Clears all items.
		 */
		public function clear():void
		{
			_heap = new Array(_size);
			_posLookup = new Dictionary(true);
			_count = 0;
		}
		
		/**
		 * Returns an iterator object pointing to the front
		 * item.
		 * 
		 * @return An iterator object.
		 */
		public function getIterator():Iterator
		{
			return new PriorityQueueIterator(this);
		}
		
		/**
		 * The total number of items in the priority queue.
		 */
		public function get size():int
		{
			return _count;
		}
		
		/**
		 * Checks if the priority queue is empty.
		 */
		public function isEmpty():Boolean
		{
			return false;
		}
		
		/**
		 * The maximum allowed size of the queue.
		 */
		public function get maxSize():int
		{
			return _size;
		}
		
		/**
		 * Converts the priority queue into an array.
		 * 
		 * @return An array containing all values.
		 */
		public function toArray():Array
		{
			return _heap.slice(1, _count);
		}
		
		private function walkUp(index:int):void
		{
			var parent:int = index >> 1;
			var parentObj:Prioritizable;
			
			var tmp:Prioritizable = _heap[index];
			var p:int = tmp.priority;
			
			while (parent > 0)
			{
				parentObj = _heap[parent];
				
				if (p - parentObj.priority > 0)
				{
					_heap[index] = parentObj;
					_posLookup[parentObj] = index;
					
					index = parent;
					parent >>= 1;
				}
				else break;
			}
			
			_heap[index] = tmp;
			_posLookup[tmp] = index;
		}
		
		private function walkDown(index:int):void
		{
			var child:int = index << 1;
			var childObj:Prioritizable;
			
			var tmp:Prioritizable = _heap[index];
			var p:int = tmp.priority;
			
			while (child < _count)
			{
				if (child < _count - 1)
				{
					if (_heap[child].priority - _heap[int(child + 1)].priority < 0)
						child++;
				}
				
				childObj = _heap[child];
				
				if (p - childObj.priority < 0)
				{
					_heap[index] = childObj;
					_posLookup[childObj] = child;
					
					index = child;
					child <<= 1;
				}
				else break;
			}
			_heap[index] = tmp;
			_posLookup[tmp] = index;
		}
    }
}

import de.polygonal.ds.Iterator;
import de.polygonal.ds.PriorityQueue;

internal class PriorityQueueIterator implements Iterator
{
	private var _values:Array;
	private var _length:int;
	private var _cursor:int;
	
	public function PriorityQueueIterator(pq:PriorityQueue)
	{
		_values = pq.toArray();
		_length = _values.length;
		_cursor = 0;
	}
	
	public function get data():*
	{
		return _values[_cursor];
	}
	
	public function set data(obj:*):void
	{
		_values[_cursor] = obj;
	}
	
	public function start():void
	{
		_cursor = 0;
	}
	
	public function hasNext():Boolean
	{
		return _cursor < _length;
	}
	
	public function next():*
	{
		return _values[_cursor++];
	}
}