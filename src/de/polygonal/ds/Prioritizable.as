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
	 * All objects you want to insert into a PriorityQueue have to extend this class.
	 * 
	 * <p>I could have defined this as an interface, but this would
	 * force me to write functions to just get or set the priority value.</p>
	 */
	public class Prioritizable
	{
		public var priority:int;
		
		public function Prioritizable()
		{
			priority = -1;
		}
		
		public function toString():String
		{
			return "[Prioritizable, priority=" + priority + "]";
		}
	}
}