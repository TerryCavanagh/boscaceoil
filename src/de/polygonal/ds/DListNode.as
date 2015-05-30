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
	/**
	 * A list node.
	 * 
	 * The node acts as a data container and also
	 * holds a reference to next and previous node
	 * in the list.
	 */
	public class DListNode
	{
		/**
		 * The node's data.
		 */
		public var data:*;
		
		/**
		 * The next node in the list being referenced.
		 */
		public var next:DListNode;
		
		/**
		 * The previous node in the list being referenced.
		 */
		public var prev:DListNode;
		
		/**
		 * Initializes a new node that stores
		 * the given item.
		 * 
		 * @param obj The data to store in the node.
		 */
		public function DListNode(obj:*)
		{
			next = prev = null;
			data = obj;
		}
		
		/**
		 * A helper function used solely by the DLinkedList class
		 * for inserting this node after a given node.
		 * 
		 * @param node A doubly linked list node.
		 */
		public function insertAfter(node:DListNode):void
		{
			node.next = next;
			node.prev = this;
			if (next) next.prev = node;
			next = node;
		}
		
		/**
		 * A helper function used solely by the DLinkedList class
		 * for inserting this node in front of a given node.
		 * 
		 * @param node A doubly linked list node.
		 */
		public function insertBefore(node:DListNode):void
		{
			node.next = this;
			node.prev = prev;
			if (prev) prev.next = node;
			prev = node;
		}
		
		/**
		 * A helper function used solely by the DLinkedList class
		 * to unlink the node from the list.
		 */
		public function unlink():void
		{
			if (prev) prev.next = next;
			if (next) next.prev = prev;
			next = prev = null;
		}
		
		/**
		 * Returns a string representing the current object.
		 */
		public function toString():String
		{
			return "[DListNode, data=" + data + "]"
		}
	}
}