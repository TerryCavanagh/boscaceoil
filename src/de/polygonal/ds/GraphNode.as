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
	import de.polygonal.ds.GraphArc;
	
	/**
	 * A graph node.
	 */
	public class GraphNode
	{
		/**
		 * The data being referenced.
		 */
		public var data:*;
		
		/**
		 * An array of arcs connecting this node to other nodes.
		 */
		public var arcs:Array;
		
		/**
		 * A flag indicating whether the node is marked or not.
		 * Used for iterating over a graph structure.
		 */
		public var marked:Boolean;
		
		private var _arcCount:int = 0;
		
		/**
		 * Constructs a new graph node.
		 * 
		 * @param obj The data to store inside the node.
		 */
		public function GraphNode(obj:*)
		{
			this.data = obj;
			arcs = [];
			_arcCount = 0;
			marked = false;
		}
		
		/**
		 * Adds an arc to the current graph node, pointing to a different
		 * graph node and with a given weight.
		 * 
		 * @param target The destination node the arc should point to.
		 * @param weigth The arc's weigth.
		 */
		public function addArc(target:GraphNode, weight:Number):void
		{
			arcs.push(new GraphArc(target, weight));
			_arcCount++;
		}

		/**
		 * Removes the arc that points to the given node.
		 * 
		 * @return True if removal was successful, otherwise false.
		 */
		public function removeArc(target:GraphNode):Boolean
		{
			for (var i:int = 0; i < _arcCount; i++)
			{
				if (arcs[i].node == target)
				{
					arcs.splice(i, 1);
					_arcCount--;
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Finds the arc that points to the given node.
		 * 
		 * @param  target The destination node.
		 * 
		 * @return A GraphArc object or null if the arc doesn't exist.
		 */
		public function getArc(target:GraphNode):GraphArc
		{
			for (var i:int = 0 ; i < _arcCount; i++)
			{
				var arc:GraphArc = arcs[i];
				if (arc.node == target) return arc;
			}
			return null;
		}
		
		/**
		 * The number of arcs extending from this node.
		 */
		public function get numArcs():int
		{
			return _arcCount;
		}
	}
}