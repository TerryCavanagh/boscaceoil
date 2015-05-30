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
	import de.polygonal.ds.NullIterator;
	import de.polygonal.ds.BinaryTreeNode;
	
	/**
	 * A Binary Search Tree (BST).
	 * 
	 * <p>A BST stores data in a recursive manner so that you can
	 * access it quickly by using a key. Therefore, a BST automatically
	 * sorts data as it is inserted.<br/>
	 * For a BST to be valid, every node has to follow two rules:</p>
	 * 1. The data value in the left subtree must be less than the data value in the current node.<br/>
	 * 2. The data value in the right subtree must be greater than the data value in the current node. 
	 */
	public class BinarySearchTree implements Collection
	{
		/**
		 * The root node being referenced.
		 */
		public var root:BinaryTreeNode;
		
		private var _compare:Function;
		
		/**
		 * Initializes a BST tree with a given comparison function.
		 * The function should return -1 if the left is 'less than'
		 * the right, 0 if they are equal, and 1 if the left is 'greater than'
		 * the right. If the function is omitted, the BST uses a
		 * default function for comparing integers.
		 * 
		 * @param compare The comparison function.
		 */
		public function BinarySearchTree(compare:Function = null)
		{
			root = null;
			
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
		 * Inserts data into the tree.
		 * 
		 * @param obj The data.
		 */
		public function insert(obj:*):void
		{
			var cur:BinaryTreeNode = root;
			
			if (!root) root = new BinaryTreeNode(obj);
			else
			{
				while (cur)
				{
					if (_compare(obj, cur.data) < 0)
					{
						if (cur.left)
							cur = cur.left
						else
						{
							cur.setLeft(obj);
							return;
						}
					}
					else
					{
						if (cur.right)
							cur = cur.right;
						else
						{
							cur.setRight(obj);
							return;
						}
					}
				}
			}
		}
		
		/**
		 * Finds a piece of data in the tree and returns a reference
		 * to the node that contains a match, or null if no match is found.
		 * 
		 * @param obj The data to find.
		 * @return A node containing the data or null if the data isn't found.
		 */
		public function find(obj:*):BinaryTreeNode
		{
			var cur:BinaryTreeNode = root, i:int;
			while (cur)
			{
				i = _compare(obj, cur.data);
				if (i == 0) return cur;
				cur = i < 0 ? cur.left : cur.right;
			}
			return null;
		}
		
		/**
		 * Removes a node from the BST.
		 *
		 * @param node The node to remove.
		 */
		public function remove(node:BinaryTreeNode):void
		{
			if (node.left && node.right)
			{
				var t:BinaryTreeNode = node;
				while (t.right) t = t.right;
				
				if (node.left == t)
				{
					t.right = node.right;
					t.right.parent = t;
				}
				else
				{
					t.parent.right = t.left;
					if (t.left) t.left.parent = t.parent;
					
					t.left = node.left;
					t.left.parent = t;
					t.right = node.right;
					t.right.parent = t;
				}
				
				if (node == root)
					root = t;
				else
				{
					if (node.isLeft())
						node.parent.left = t;
					else
						node.parent.right = t;
				}
				
				t.parent = node.parent;
				node.left = null;
				node.right = null;
				node = null;
			}
			else
			{
				var child:BinaryTreeNode = null;
				
				if (node.left)
					child = node.left;
				else
				if (node.right)
					child = node.right;
					
				if (node == root)
					root = child;
				else
				{
					if (node.isLeft())
						node.parent.left = child;
					else
						node.parent.right = child;
				}
				
				if (child) child.parent = node.parent;
				node.left = node.right = null;
				node = null;
			}
		}
		
		/**
		 * Checks if a given item exists.
		 * 
		 * @return True if the item is found, otherwise false.
		 */
		public function contains(obj:*):Boolean
		{
			if (find(obj)) return true;
			return false;
		}
		
		/**
		 * Clears the tree recursively, starting from this node.
		 */
		public function clear():void
		{
			if (root)
			{
				root.destroy();
				root = null;
			}
		}
		
		/**
		 * Regular iterator is not supported, 
		 * use BinaryTreeNode.preorder(), inorder() and postorder() instead.
		 */
		public function getIterator():Iterator
		{
			return new NullIterator();
		}
		
		/**
		 * The total number of tree nodes.
		 */
		public function get size():int
		{
			if (!root) return 0;
			return root.count();
		}
		
		/**
		 * Checks if the BST is empty.
		 */
		public function isEmpty():Boolean
		{
			if (root)
				return root.count() == 0;
			else
				return true;
		}
		
		/**
		 * Converts the structure into an array.
		 * 
		 * @return An array.
		 */
		public function toArray():Array
		{
			var a:Array = [];
			var copy:Function = function(node:BinaryTreeNode):void
			{
				a.push(node.data);
			}
			BinaryTreeNode.inorder(root, copy);
			return a;
		}
		
		/**
		 * Returns a string representing the current object.
		 */
		public function toString():String
		{
			return "[BST, size=" + size + "]";
		}
		
		/**
		 * Prints out all elements in the queue (for debug/demo purposes).
		 */
		public function dump():String
		{
			var s:String = "";
			var dumpNode:Function = function (node:BinaryTreeNode):void
			{
				s += node + "\n";
			}
			BinaryTreeNode.inorder(root, dumpNode);
			return s;
		}
	}
}