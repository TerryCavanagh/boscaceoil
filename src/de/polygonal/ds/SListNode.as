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
	 * A singly linked list node.
	 * 
	 * The node acts as a data container and also
	 * holds a reference to next node in the list.
	 */
	public class SListNode
	{
		/**
		 * The node's data.
		 */
		public var data:*;
		
		/**
		 * The next node in the list being referenced.
		 */
		public var next:SListNode;
		
		/**
		 * Initializes a new node that stores
		 * the given item.
		 * 
		 * @param obj The data to store in the node.
		 */
		public function SListNode(obj:*)
		{
			data = obj;
			next = null;
		}
		
		/**
		 * A helper function used solely by the SLinkedList class
		 * for node insertion.
		 * 
		 * @param node The node after which this node is inserted.
		 */
		public function insertAfter(node:SListNode):void
		{
			node.next = next;
			next = node;		
		}
		
		/**
		 * Returns a string representing the current object.
		 */
		public function toString():String
		{
			return "[SListNode, data=" + data + "]";
		}
	}
}