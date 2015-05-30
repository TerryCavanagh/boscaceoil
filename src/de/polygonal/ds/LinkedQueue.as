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
	import de.polygonal.ds.SLinkedList;
	
	/**
	 * A linked queue.
	 * 
	 * <p>A queue is a FIFO structure (First In, First Out).</p>
	 */
	public class LinkedQueue
	{
		private var _list:SLinkedList;
		
		/**
		 * Initializes an empty linked queue.
		 * You can pass an existing singly linked list
		 * to provide queue-like access.
		 * 
		 * @param list An existing list to use as a queue.
		 */
		public function LinkedQueue(list:SLinkedList = null)
		{
			if (list == null)
				_list = new SLinkedList();
			else
				_list = list;
		}
		
		/**
		 * The total number of items in the queue.
		 */
		public function get size():int
		{
			return _list.size;
		}
		
		/**
		 * Indicates the front item.
		 * 
		 * @return The front item.
		 */
		public function peek():*
		{
			if (_list.size > 0)
				return _list.head.data;
			return null;
		}
		
		/**
		 * Clears all elements.
		 */
		public function clear():void
		{
			_list.clear();
		}
		
		/**
		 * Enqueues some data.
		 * 
		 * @param obj The data.
		 */
		public function enqueue(obj:*):void
		{
			_list.append(obj);
		}
		
		/**
		 * Dequeues the front item.
		 */
		/**
		 * Dequeues and returns the front item.
		 * 
		 * @return The front item or null if the queue is empty.
		 */
		public function dequeue():*
		{
			if (_list.size > 0)
			{
				var front:* = _list.head.data;
				_list.removeHead();
				return front;
			}
			return null;
		}
		
		/**
		 * Returns a string representing the current object.
		 */
		public function toString():String
		{
			return "[LinkedQueue > " + _list + "]";
		}
		
		/**
		 * Prints out all elements in the queue (for debug/demo purposes).
		 */
		public function dump():String
		{
			return "LinkedQueue:\n" + _list.dump();
		}
	}
}