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
	import de.polygonal.ds.GraphNode;
	
	/**
	 * A linked uni-directional weighted graph structure.
	 * <p>The Graph class manages all graph nodes. Each graph node has
	 * a linked list of arcs, pointing to different nodes.</p>
	 */
	public class Graph
	{
		/**
	 	 * An array containing all graph nodes.
	 	 */
		public var nodes:Array;
		
		private var _nodeCount:int;
		private var _maxSize:int;
		
		/**
		 * Constructs an empty graph.
		 * 
		 * @param size The total number of nodes allowed.
		 */
		public function Graph(size:int)
		{
			nodes = new Array(_maxSize = size);
			_nodeCount = 0;
		}
		
		/**
		 * Performs a depth-first traversal on the given node.
		 * 
		 * @param node    The starting graph node.
		 * @param process A function to apply to each traversed node.
		 */
		public function depthFirst(node:GraphNode, process:Function):void
		{
			if (!node) return;
			
			process(node);
			node.marked = true;
			
			var k:int = node.numArcs, t:GraphNode;
			for (var i:int = 0; i < k; i++)
			{
				t = node.arcs[i].node;
				if (!t.marked) depthFirst(t, process);
			}
		}
		
		/**
		 * Performs a breadth-first traversal on the given node.
		 * 
		 * @param node    The starting graph node.
		 * @param process A function to apply to each traversed node.
		 */
		public function breadthFirst(node:GraphNode, process:Function):void
		{
			if (!node) return;
			
			var que:Array = [];
			que.push(node);
			node.marked = true;
			
			var c:int = 1;
			
			var t:GraphNode, u:GraphNode;
			while (c > 0)
			{
				process(t = que[0]);
				
				var arcs:Array = t.arcs, k:int = t.numArcs;
				for (var i:int = 0; i < k; i++)
				{
					u = arcs[i].node;
					if (!u.marked)
					{
						u.marked = true;
						que.push(u);
						c++;
					}
				}
				que.shift();
				c--;
			}
		}
		
		/**
		 * Adds a node at a given index to the graph.
		 * 
		 * @param obj The data to store in the node.
		 * @param i   The index the node is stored at.
		 * @return True if successful, otherwise false.
		 */
		public function addNode(obj:*, i:int):Boolean
		{
			if (nodes[i]) return false;
			
			nodes[i] = new GraphNode(obj);
			_nodeCount++;
			return true;
		}
		
		/**
		 * Removes a node from the graph at a given index.
		 * 
		 * @param index Index of the node to remove
		 * @return True if successful, otherwise false.
		 */
		public function removeNode(i:int):Boolean
		{
			var node:GraphNode = nodes[i];
			if(!node) return false;
			
			var arc:GraphArc;
			for (var j:int = 0; j < _maxSize; j++)
			{
				var t:GraphNode = nodes[j];
				if (t && t.getArc(node)) removeArc(j, i);
			}
			
			nodes[i] = null;
			_nodeCount--;
			return true;
		}
		
		/**
		 * Finds an arc pointing to the node
		 * at the 'from' index to the node at the 'to' index.
		 * 
		 * @param from The originating graph node index.
		 * @param to   The ending graph node index.
		 * @return A GraphArc object or null if it doesn't exist.
		 */
		public function getArc(from:int, to:int):GraphArc
		{
			var node0:GraphNode = nodes[from];
			var node1:GraphNode = nodes[to];
			if (node0 && node1) return node0.getArc(node1);
			return null;
		}
		
		/**
		 * Adds an arc pointing to the node located at the
		 * 'from' index to the node at the 'to' index.
		 * 
		 * @param from   The originating graph node index.
		 * @param to     The ending graph node index.
		 * @param weight The arc's weight
		 *
		 * @return True if an arc was added, otherwise false.
		 */
		public function addArc(from:int, to:int, weight:int = 1):Boolean
		{
			var node0:GraphNode = nodes[from];
			var node1:GraphNode = nodes[to];
			
			if (node0 && node1)
			{
				if (node0.getArc(node1)) return false;
			
				node0.addArc(node1, weight);
				return true;
			}
			return false;
		}
		
		/**
		 * Removes an arc pointing to the node located at the
		 * 'from' index to the node at the 'to' index.
		 * 
		 * @param from The originating graph node index.
		 * @param to   The ending graph node index.
		 * 
		 * @return True if an arc was removed, otherwise false.
		 */
		public function removeArc(from:int, to:int):Boolean
		{
			var node0:GraphNode = nodes[from];
			var node1:GraphNode = nodes[to];
			
			if (node0 && node1)
			{
				node0.removeArc(node1);
				return true;
			}
			return false;
		}
		
		/**
		 * Clears the markers on all nodes in the graph
		 * so the breadth-first and depth-first traversal
		 * algorithms can 'see' the nodes.
		 */
		public function clearMarks():void
		{
			for (var i:int = 0; i < _maxSize; i++)
			{
				var node:GraphNode = nodes[i];
				if (node) node.marked = false;
			}
		}
		
		/**
		 * The number of nodes in the graph.
		 */
		public function get size():int
		{
			return _nodeCount;
		}
		
		/**
		 * The maximum number of nodes the
		 * graph can store.
		 */
		public function get maxSize():int
		{
			return _maxSize;
		}
		
		/**
		 * Clears every node in the graph.
		 */
		public function clear():void
		{
			nodes = new Array(_maxSize);
			_nodeCount = 0;
		}
	}
}