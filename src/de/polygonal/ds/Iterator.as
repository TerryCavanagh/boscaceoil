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
	 * A 'java-style' iterator interface.
	 */
	public interface Iterator
	{
		/**
		 * Retrieves the current item and moves
		 * the iterator to the next item in the sequence.
		 */
		function next():*
		
		/**
		 * Checks if the next item exists.
		 * 
		 * @return True if a next item exists, otherwise false.
		 */
		function hasNext():Boolean
		
		/**
		 * Moves the iterator to the first item
		 * in the sequence.
		 */
		function start():void
		
		/**
		 * Grants access to the current item being
		 * referenced by the iterator. This provides
		 * a quick way to read or write the current data.
		 */
		function get data():*
		function set data(obj:*):void
	}
}

