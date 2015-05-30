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
	import de.polygonal.ds.SListNode;
	import de.polygonal.ds.SListIterator;
	
	/**
	 * A singly linked list.
	 */
	public class SLinkedList implements Collection
	{
		private var _count:int;
		
		/**
		 * The head node being referenced.
		 */
		public var head:SListNode;
		
		/**
		 * The tail node being referenced.
		 */
		public var tail:SListNode;
		
		/**
		 * Initializes an empty list.
		 */
		public function SLinkedList()
		{
			head = tail = null;
			_count = 0;
		}
		
		/**
		 * Appends an item to the list.
		 * 
		 * @param obj The data.
		 * @return A singly linked list node wrapping the data.
		 */
		public function append(obj:*):SListNode
		{
			var node:SListNode = new SListNode(obj);
			if (head)
			{
				tail.next = node;
				tail = node;
			}
			else
				head = tail = node;
			
			_count++;
			return node;
		}
		
		/**
		 * Prepends an item to the list.
		 * 
		 * @param obj The data.
		 * @return A singly linked list node wrapping the data.
		 */
		public function prepend(obj:*):SListNode
		{
			var node:SListNode = new SListNode(obj);
			
			if (head)
			{
				node.next = head;
				head = node;
			}
			else
				head = tail = node;
			
			_count++;
			return node;
		}
		
		/**
		 * Inserts data after a given iterator or appends it
		 * if the iterator is invalid.
		 * 
		 * @param itr  A singly linked list iterator.
		 * @param obj The data.
		 * @return A singly linked list node wrapping the data.
		 */
		public function insertAfter(itr:SListIterator, obj:*):SListNode
		{
			if (itr.list != this) return null;
			if (itr.node)
			{
				var node:SListNode = new SListNode(obj);
				itr.node.insertAfter(node);
				if (itr.node == tail)
					tail = itr.node.next;
				
				_count++;
				return node;
			}
			else
				return append(obj);
		}
		
		/**
		* Removes the node the iterator is pointing
		* to and move the iterator to the next node.
		* 
		* @return True if the removal succeeded, otherwise false.
		*/
		public function remove(itr:SListIterator):Boolean
		{
			if (itr.list != this || !itr.node) return false;
			
			var node:SListNode = head;
			if (itr.node == head)
			{
				itr.forth();
				removeHead();
			}
			else
			{
				while (node.next != itr.node) node = node.next;
				itr.forth();
				if (node.next == tail) tail = node;
				node.next = itr.node;
			}
			_count--;
			return true;
		}
		
		/**
		 * Removes the head of the list.
		 */
		public function removeHead():void
		{
			if (!head) return;
			
			if (head == tail)
				head = tail = null;
			else
			{
				var node:SListNode = head;
				
				head = head.next;
				node.next = null;
				if (head == null) tail = null;
			}
			_count--;
		}
		
		/**
		 * Removes the tail of the list.
		 */
		public function removeTail():void
		{
			if (!tail) return;
			
			if (head == tail)
				head = tail = null;
			else
			{
				var node:SListNode = head;
				while (node.next != tail)
					node = node.next;
				
				tail = node;
				node.next = null;
			}
			_count--;
		}
		
		/**
		 * Checks if a given item exists.
		 * 
		 * @return True if the item is found, otherwise false.
		 */
		public function contains(obj:*):Boolean
		{
			var node:SListNode = head;
			while (node)
			{
				if (node.data == obj) return true;
				node = node.next;
			}
			return false;
		}
		
		/**
		 * Clears the list by unlinking all nodes
		 * from it. This is important to unlock
		 * the nodes for the garbage collector.
		 */
		public function clear():void
		{
			var node:SListNode = head;
			head = null;
			
			var next:SListNode;
			while (node)
			{
				next = node.next;
				node.next = null;
				node = next;
			}
			_count = 0;
		}
		
		/**
		 * Creates an iterator pointing
		 * to the first node in the list.
		 * 
		 * @returns An iterator object.
		 */
		public function getIterator():Iterator
		{
			return new SListIterator(this, head);
		}
		
		/**
		 * Creates a list iterator pointing
		 * to the first node in the list.
		 * 
		 * @returns A SListIterator object.
		 */
		public function getListIterator():SListIterator
		{
			return new SListIterator(this, head);
		}
		
		/**
		 * The total number of nodes in the list.
		 */
		public function get size():int
		{
			return _count;
		}
		
		/**
		 * Checks if the list is empty.
		 */
		public function isEmpty():Boolean
		{
			return _count == 0;
		}
		
		/**
		 * Converts the linked list into an array.
		 * 
		 * @return An array.
		 */
		public function toArray():Array
		{
			var a:Array = [];
			var node:SListNode = head;
			while (node)
			{
				a.push(node.data);
				node = node.next;
			}
			return a;
		}
		
		/**
		 * Returns a string representing the current object.
		 */
		public function toString():String
		{
			return "[SlinkedList, size=" + size + "]";
		}
		
		/**
		 * Prints out all elements in the list (for debug/demo purposes).
		 */
		public function dump():String
		{
			if (!head)
				return "SLinkedList: (empty)";
			
			var s:String = "SLinkedList: (has " + _count + " node" + (_count == 1 ? ")" : "s") + "\n|< Head\n";
			
			var itr:SListIterator = getListIterator();
			for (; itr.valid(); itr.forth())
				s += "\t" + itr.data + "\n";
			
			s += "Tail >|";
			
			return s;
		}
	}
}