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
	import de.polygonal.ds.Collection;
	import de.polygonal.ds.Iterator;
	
	/**
	 * A heap.
	 * 
	 * <p>A heap is a special kind of binary tree in which every node is
	 * greater than all of its children. The implementation is based on an arrayed binary tree.
	 * It can be used as an efficient priority queue.</p>
	 * @see PriorityQueue
	 */
	public class Heap implements Collection
	{
		public var _heap:Array;
		
		private var _size:int;
		private var _count:int;
		private var _compare:Function;
		
		/**
		 * Initializes a new heap.
		 */
		public function Heap(size:int, compare:Function = null)
		{
			_heap = new Array(_size = size + 1);
			_count = 0;
			
			if (compare == null)
			{
				_compare = function(a:int, b:int):int
				{
					return a - b;
				}
			}
			else
				_compare = compare;
		}
		
		/**
		 * The heap's front item.
		 */
		public function get front():*
		{
			return _heap[1];
		}
		
		/**
		 * Enqueues some data.
		 * 
		 * @param obj The data.
		 */
		public function enqueue(obj:*):void
		{
			_heap[++_count] = obj;
			walkUp(_count);
		}
		
		/**
		 * Dequeues the front item.
		 */
		public function dequeue():void
		{
			if (_count >= 1)
			{
				_heap[1] = _heap[_count];
				delete _heap[_count];
				
				walkDown(1);
				_count--;
			}
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
			return new HeapIterator(this);
		}
		
		/**
		 * The total number of items in the heap.
		 */
		public function get size():int
		{
			return _count;
		}
		
		/**
		 * Checks if the heap is empty.
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
		 * Converts the heap into an array.
		 * 
		 * @return An array containing all heap values.
		 */
		public function toArray():Array
		{
			return _heap.slice(1, _count);
		}
		
		private function walkUp(index:int):void
		{
			var parent:int = index >> 1;
			var tmp:* = _heap[index];
			while (parent > 0)
			{
				if (_compare(tmp, _heap[parent]) > 0)
				{
					_heap[index] = _heap[parent];
					index = parent;
					parent >>= 1;
				}
				else break;
			}
			_heap[index] = tmp;
		}
		
		private function walkDown(index:int):void
		{
			var child:int = index << 1;
			
			var tmp:* = _heap[index], c:*;
			
			while (child < _count)
			{
				if (child < _count - 1)
				{
					if (_compare(_heap[child], _heap[int(child + 1)]) < 0)
						child++;
				}
				if (_compare(tmp, _heap[child]) < 0)
				{
					_heap[index] = _heap[child];
					index = child;
					child <<= 1;
				}
				else break;
			}
			_heap[index] = tmp;
		}
	}
}

import de.polygonal.ds.Iterator;
import de.polygonal.ds.Heap;

internal class HeapIterator implements Iterator
{
	private var _values:Array;
	private var _length:int;
	private var _cursor:int;
	
	public function HeapIterator(heap:Heap)
	{
		_values = heap.toArray();
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