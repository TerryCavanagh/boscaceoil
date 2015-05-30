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
	
	/**
	 * An do-nothing iterator for structures that don't support iterators.
	 */
	public class NullIterator implements Iterator
	{
		public function start():void
		{
		}
		
		public function next():*
		{
			return null;
		}
	
		public function hasNext():Boolean
		{
			return false;
		}
		
		public function get data():*
		{
			return null;
		}
		
		public function set data(obj:*):void
		{
		}
	}
}

