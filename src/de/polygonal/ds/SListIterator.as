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
	import de.polygonal.ds.SListNode;
	import de.polygonal.ds.SLinkedList;
	
	/**
	 * A singly linked list iterator.
	 */
	public class SListIterator implements Iterator
	{
		/**
		 * The node the iterator is pointing.
		 */
		public var node:SListNode;
		
		 /**
		 * The list of the iterator is referenced.
		 */
		public var list:SLinkedList;
		
		/**
		 * Initializes a new SListIterator instance pointing to a given node.
		 * Usually created by invoking SLinkedList.getIterator().
		 * 
		 * @param list The linked list the iterator should use.
		 * @param node The iterator's initial node. 
		 */
		public function SListIterator(list:SLinkedList = null, node:SListNode = null)
		{
			this.list = list;
			this.node = node;
		}
		
		/**
		 * Returns the current node's data while
		 * moving the iterator forward by one position.
		 */
		public function next():*
		{
			if (hasNext())
			{
				var obj:* = node.data;
				node = node.next;
				return obj;
			}
			return null
		}
		
		/**
		 * Checks if a next node exists.
		 */
		public function hasNext():Boolean
		{
			return Boolean(node);
		}
		
		/**
		 * Read/writes the current node's data.
		 * 
		 * @return The data.
		 */
		public function get data():*
		{
			if (node) return node.data;
			return null;
		}
		
		public function set data(obj:*):void
		{
			node.data = obj;
		}
		
		
		/**
		 * Moves the iterator to the start of the list.
		 */
		public function start():void
		{
			if (list) node = list.head;
		}
		
		/**
		 * Moves the iterator to the end of the list.
		 */
		public function end():void
		{
			if (list) node = list.tail;
		}
		
		/**
		 * Moves the iterator to the next node.
		 */
		public function forth():void
		{
			if (node) node = node.next;
		}
		
		/**
		 * Checks if the current referenced node is valid.
		 * 
		 * @return True if the node exists, otherwise false.
		 */
		public function valid():Boolean
		{
			return Boolean(node);
		}
		
		/**
		 * Removes the node the iterator is 
		 * pointing to.
		 */
		public function remove():void
		{
			list.remove(this);
		}
		
		/**
		 * Returns a string representing the current object.
		 */
		public function toString():String
		{
			return "{SListIterator: data=" + node.data + "}";
		}
	}
}