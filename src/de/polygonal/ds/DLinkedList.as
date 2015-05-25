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
	import de.polygonal.ds.Iterator;
	import de.polygonal.ds.Collection;
	
	import de.polygonal.ds.DListNode;
	import de.polygonal.ds.DListIterator;
	
	/**
	 * A doubly linked list.
	 * 
	 * <p>A doubly linked list stores a reference to the next
	 * and previous node which makes it possible to traverse
	 * the list in both directions.</p>
	 */
	public class DLinkedList implements Collection
	{
		private var _count:int;
		
		/**
		 * The head node being referenced.
		 */
		public var head:DListNode;
		
		/**
		 * The tail node being referenced.
		 */
		public var tail:DListNode;
		
		/**
		 * Initializes an empty list.
		 */
		public function DLinkedList()
		{
			head = tail = null;
			_count = 0;
		}
		
		/**
		 * Appends an item to the list.
		 * 
		 * @param obj The data.
		 * @return A doubly linked list node wrapping the data.
		 */
		public function append(obj:*):DListNode
		{
			var node:DListNode = new DListNode(obj);
			if (head)
			{
				tail.insertAfter(node);
				tail = tail.next;
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
		 * @return A doubly linked list node wrapping the data.
		 */
		public function prepend(obj:*):DListNode
		{
			var node:DListNode = new DListNode(obj);
			
			if (head)
			{
				head.insertBefore(node);
				head = head.prev;
			}
			else
				head = tail = node;
			
			_count++;
			return node;
		}
		
		/**
		 * Inserts an item after a given iterator or appends it
		 * if the iterator is invalid.
		 * 
		 * @param itr A doubly linked list iterator.
		 * @param obj The data.
		 * @return A doubly linked list node wrapping the data.
		 */
		public function insertAfter(itr:DListIterator, obj:*):DListNode
		{
			if (itr.list != this) return null;
			if (itr.node)
			{
				var node:DListNode = new DListNode(obj);
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
		 * Inserts an item before a given iterator or appends it
		 * if the iterator is invalid.
		 * 
		 * @param itr A doubly linked list iterator.
		 * @param obj The data.
		 * @return A doubly linked list node wrapping the data.
		 */
		public function insertBefore(itr:DListIterator, obj:*):DListNode
		{
			if (itr.list != this) return null;
			if (itr.node)
			{
				var node:DListNode = new DListNode(obj);
				itr.node.insertBefore(node);
				if (itr.node == head)
					head = head.prev;
				
				_count++;
				return node;
			}
			else
				return prepend(obj);
		}
		
		/**
		* Removes the node the iterator is pointing
		* at and moves the iterator to the next node.
		* 
		* @return True if the removal succeeded, otherwise false.
		*/
		public function remove(itr:DListIterator):Boolean
		{
			if (itr.list != this || !itr.node) return false;
			
			var node:DListNode = itr.node;
			
			if (node == head) 
				head = head.next;
			else
			if (node == tail)
				tail = tail.prev;
			
			itr.forth();
			node.unlink();
			
			if (head == null) tail = null;
			
			_count--;
			return true;
		}
		
		/**
		 * Removes the head of the list.
		 */
		public function removeHead():void
		{
			if (head)
			{
				head = head.next;
				
				if (head)
					head.prev = null;
				else
					tail = null
				
				_count--;
			}
		}
		
		/**
		 * Removes the tail of the list.
		 */
		public function removeTail():void
		{
			if (tail)
			{
				tail = tail.prev;
				
				if (tail)
					tail.next = null;
				else
					head = null;
				
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
			var node:DListNode = head;
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
			var node:DListNode = head;
			head = null;
			
			var next:DListNode;
			while (node)
			{
				next = node.next;
				node.next = node.prev = null;
				node = next;
			}
			_count = 0;
		}
		
		/**
		 * Creates an iterator object pointing
		 * at the first node in the list.
		 * 
		 * @returns An iterator object.
		 */
		public function getIterator():Iterator
		{
			return new DListIterator(this, head);
		}
		
		/**
		 * Creates a doubly linked iterator object pointing
		 * at the first node in the list.
		 * 
		 * @returns A DListIterator object.
		 */
		public function getListIterator():DListIterator
		{
			return new DListIterator(this, head);
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
			var node:DListNode = head;
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
			return "[DLinkedList > has " + size + " nodes]";
		}
		
		/**
		 * Prints out all elements in the list (for debug/demo purposes).
		 */
		public function dump():String
		{
			if (head == null) return "DLinkedList, empty";
			
			var s:String = "DLinkedList, has " + _count + " node" + (_count == 1 ? "" : "s") + "\n|< Head\n";
			
			var itr:DListIterator = getListIterator();
			for (; itr.valid(); itr.forth())
				s += "\t" + itr.data + "\n";
			
			s += "Tail >|";
			
			return s;
		}
	}
}