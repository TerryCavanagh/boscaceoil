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
	 * A weighted arc pointing to a graph node.
	 */
	public class GraphArc
	{
		/**
		 * The node that the arc points to being referenced.
		 */
		public var node:GraphNode;
		
		/**
		 * The weight (or cost) of the arc.
		 */
		public var weight:Number
		
		/**
		 * Initializes a new graph arc with a given weight.
		 * 
		 * @param node 		The graph node.
		 * @param weight 	The weight.
		 */
		public function GraphArc(node:GraphNode, weight:Number = 1)
		{
			this.node = node;
			this.weight = weight;
		}
	}
}