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
	
	/**
	* An arrayed stack.
	* <p>A stack is a LIFO structure (Last In, First Out).</p>
	*/
	public class ArrayedStack implements Collection
	{
		private var _stack:Array;
		private var _size:int;
		private var _top:int;
		
		/**
		 * Initializes a stack to match the given size.
		 * 
		 * @param size The total number of elements the stack can store.
		 */
		public function ArrayedStack(size:int)
		{
			_size = size;
			clear();
		}
		
		/**
		 * Indicates the top item.
		 *
		 * @return The top item.
		 */
		public function peek():*
		{
			return _stack[int(_top - 1)];
		}
		
		/**
		 * Pushes data onto the stack.
		 * 
		 * @param obj The data.
		 */
		public function push(obj:*):Boolean
		{
			if (_size != _top)
			{
				_stack[_top++] = obj;
				return true;
			}
			return false;
		}
		
		/**
		 * Pops data from the stack.
		 * 
		 * @return The top item.
		 */
		public function pop():void
		{
			if (_top > 0) _top--
		}
		
		/**
		 * Reads an item at a given index.
		 * 
		 * @param i The index.
		 * @return The item at the given index.
		 */
		public function getAt(i:int):*
		{
			if (i >= _top) return null;
			return _stack[i];
		}
		
		/**
		 * Writes an item at a given index.
		 * 
		 * @param i   The index.
		 * @param obj The data.
		 */
		public function setAt(i:int, obj:*):void
		{
			if (i >= _top) return;
			_stack[i] = obj;
		}
		
		/**
		 * Checks if a given item exists.
		 * 
		 * @return True if the item is found, otherwise false.
		 */
		public function contains(obj:*):Boolean
		{
			for (var i:int = 0; i < _top; i++)
			{
				if (_stack[i] === obj)
					return true;
			}
			return false;
		}
		
		/**
		 * Clears the stack.
		 */
		public function clear():void
		{
			_stack = new Array(_size);
			_top = 0;
		}
		
		/**
		 * Creates a new iterator pointing to the top item.
		 */
		public function getIterator():Iterator
		{
			return new ArrayedStackIterator(this);
		}
		
		/**
		 * The total number of items in the stack.
		 */
		public function get size():int
		{
			return _top;
		}
		
		/**
		 * Checks if the stack is empty.
		 */
		public function isEmpty():Boolean
		{
			return _size == 0;
		}
		
		/**
		 * The maximum allowed size.
		 */
		public function get maxSize():int
		{
			return _size;
		}
		
		/**
		 * Converts the structure into an array.
		 * 
		 * @return An array.
		 */
		public function toArray():Array
		{
			return _stack.concat();
		}
		
		/**
		 * Returns a string representing the current object.
		 */
		public function toString():String
		{
			return "[ArrayedStack, size= " + _top + "]";
		}
		
		/**
		 * Prints out all elements in the queue (for debug/demo purposes).
		 */
		public function dump():String
		{
			var s:String = "[ArrayedStack]";
			if (_top == 0) return s;
			
			var k:int = _top - 1;
			s += "\n\t" + _stack[k--] + " -> front\n";
			for (var i:int = k; i >= 0; i--)
				s += "\t" + _stack[i] + "\n";
			return s;
		}
	}
}

import de.polygonal.ds.Iterator;
import de.polygonal.ds.ArrayedStack;

internal class ArrayedStackIterator implements Iterator
{
	private var _stack:ArrayedStack;
	private var _cursor:int;
	
	public function ArrayedStackIterator(stack:ArrayedStack)
	{
		_stack = stack;
		start();
	}
	
	public function get data():*
	{
		return _stack.getAt(_cursor);
	}
	
	public function set data(obj:*):void
	{
		_stack.setAt(_cursor, obj);
	}
	
	public function start():void
	{
		_cursor = _stack.size - 1;
	}
	
	public function hasNext():Boolean
	{
		return _cursor >= 0;
	}
	
	public function next():*
	{
		if (_cursor >= 0)
			return _stack.getAt(_cursor--);
		return null;
	}
}