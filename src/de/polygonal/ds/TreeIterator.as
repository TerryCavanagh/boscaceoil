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
	import de.polygonal.ds.LinkedStack;
	import de.polygonal.ds.TreeNode;
	import de.polygonal.ds.DListIterator;
	
	/**
	 * A tree iterator.
	 */
	public class TreeIterator implements Iterator
	{
		/**
		 * Performs a preorder Traversal on the tree starting from a 
		 * given tree node.
		 *
		 * @param node    A TreeNode object to start traversing at.
		 * @param process A function to apply to each traversed node.
		 */
		public static function preorder(node:TreeNode, process:Function):void
		{
			process(node);
			
			var itr:DListIterator = node.children.getIterator() as DListIterator;
			for (; itr.valid(); itr.forth())
				TreeIterator.preorder(itr.data, process);
		}
		
		/**
		 * Performs a postorder traversal on the tree starting from
		 * a given tree node.
		 *
		 * @param node    The TreeNode object to start from.
		 * @param process A function to apply to each traversed node.
		 */
		public static function postorder(node:TreeNode, process:Function):void
		{
			var itr:DListIterator = node.children.getIterator() as DListIterator;
			for (; itr.valid(); itr.forth())
				postorder(TreeNode(itr.data), process)
			
			process(node);
		}
		
		/**
		 * The tree node being referenced.
		 */
		public var node:TreeNode;
		
		private var _childItr:DListIterator;
		
		private var _stack:LinkedStack;
		
		/**
		 * Initializes a tree iterator pointing to a given tree node.
		 * 
		 * @param node The node the iterator should point to.
		 */
		public function TreeIterator(node:TreeNode = null)
		{
			this.node = node;
			reset();
			
			_stack = new LinkedStack();
			_stack.push(_childItr);
		}
		
		/**
		 * Checks if the next node exists.
		 */
		public function hasNext():Boolean
		{
			if (_stack.size == 0)
				return false;
			else
			{
				var itr:DListIterator = _stack.peek();
				
				if (!itr.hasNext())
				{
					_stack.pop();
					return hasNext();
				}
				else
					return true;
			}
		}
		
		/**
		 * Returns the current referenced node
		 * and moves the iterator forward by
		 * one position.
		 */
		public function next():*
		{
			if (hasNext())
			{
				var itr:DListIterator = _stack.peek();
				var node:TreeNode = itr.next();
				
				if (node.children.size > 0)
					_stack.push(node.children.getIterator());
				
				return node;
			}
			else
				return null;
		}
		
		/**
		 * Resets the vertical iterator so that it points
		 * to the root of the tree. Also make sure the
		 * horizontal iterator points to the first child.
		 */
		public function start():void
		{
			root();
			childStart();
			
			while (_stack.size > 0) _stack.pop();
			_stack.push(_childItr);
		}
		
		/**
		 * Read/writes the current node's data.
		 * 
		 * @return The data.
		 */
		public function get data():*
		{
			return node.data;
		}
		
		public function set data(obj:*):void
		{
			node.data = obj;
		}
		
		/**
		 * The current child node being referenced
		 */
		public function get childNode():TreeNode
		{
			return _childItr.data;
		}
		
		/**
		 * Returns the item the child iterator is pointing to.
		 */
		public function get childData():*
		{
			return _childItr.data.data;
		}
		
		/**
		 * Checks if the node is valid.
		 */
		public function valid():Boolean
		{
			return Boolean(node);
		}
		
		/**
		 * Moves the iterator to the root of the tree.
		 */
		public function root():void
		{
			if (node)
			{
				while (node.parent)
					node = node.parent;
			}
			reset();
		}
		
		/**
		 * Moves the iterator up by one level of the tree,
		 * so that it points to the parent of the current tree node.
		 */
		public function up():void
		{
			if (node) node = node.parent;
			reset();
		}
		
		/**
		 * Moves the iterator down by one level of the tree,
		 * so that it points to the first child of the current tree node.
		 */
		public function down():void
		{
			if (_childItr.valid())
			{
				node = _childItr.data;
				reset();
			}
		}
		
		/**
		 * Moves the child iterator forward
		 * by one position.
		 */
		public function nextChild():void
		{
			_childItr.forth();
		}
		
		/**
		 * Moves the child iterator back
		 * by one position.
		 */
		public function prevChild():void
		{
			_childItr.back();
		}
		
		/**
		 * Moves the child iterator to the first child.
		 */
		public function childStart():void
		{
			_childItr.start();
		}
		
		/**
		 * Moves the child iterator to the last child.
		 */
		public function childEnd():void
		{
			_childItr.end();
		}
		
		/**
		 * Determines if the child iterator is valid.
		 */
		public function childValid():Boolean
		{
			return _childItr.valid();
		}
		
		/**
		 * Appends a child node to the child list.
		 * 
		 * @param obj The data to append as a child node.
		 */
		public function appendChild(obj:*):void
		{
			new TreeNode(obj, node);
			
			if (node.children.size == 1)
				childStart();
		}
		
		/**
		 * Prepends a child node to the child list.
		 * 
		 * @param obj The data to prepend as a child node.
		 */
		public function prependChild(obj:*):void
		{
			var childNode:TreeNode = new TreeNode(obj, null);
			childNode.parent = node;
			node.children.prepend(childNode);
			
			if (node.children.size == 1)
				childStart();
		}
		
		/**
		 * Inserts a child node before the current child node.
		 * 
		 * @param obj The data to insert as a child node.
		 */
		public function insertBeforeChild(obj:*):void
		{
			var childNode:TreeNode = new TreeNode(obj, null);
			childNode.parent = node;
			node.children.insertBefore(_childItr, childNode);
			
			if (node.children.size == 1)
				childStart();
		}
		
		/**
		 * Inserts a child node after the current child node.
		 * 
		 * @param obj The data to insert as a child node.
		 */
		public function insertAfterChild(obj:*):void
		{
			var childNode:TreeNode = new TreeNode(obj, null);
			childNode.parent = node;
			node.children.insertAfter(_childItr, childNode);
			
			if (node.children.size == 1)
				childStart();
		}
		
		/**
		 * Unlinks the current child node from the tree.
		 * Doesn't delete the node.
		 */
		public function removeChild():void
		{
			if (node && _childItr.valid())
			{
				_childItr.data.parent = null;
				node.children.remove(_childItr);
			}
		}
		
		private function reset():void
		{
			if (node)
				_childItr = node.children.getListIterator();
			else
			{
				_childItr.node = null;
				_childItr.list = null;
			}
		}
		
		/**
		 * Returns a string representing the current object.
		 */
		public function toString():String
		{
			var s:String = "[TreeIterator > pointing to: [V] " + node + " [H] " + (_childItr.data || "(leaf node)");
			return s;
		}
	}
}
