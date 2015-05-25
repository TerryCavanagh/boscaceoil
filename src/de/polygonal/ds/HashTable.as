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
	 * A hash table using linked overflow for resolving collisions.
	 */
	public class HashTable
	{
		/**
		 * A simple function for hashing strings.
		 */
		public static function hashString(s:String):int
		{
			var hash:int = 0, i:int, k:int = s.length;
			for (i = 0; i < k; i++)
				hash += (i + 1) * s.charCodeAt(i);
			return hash;
		}
		
		/**
		 * A simple function for hashing integers.
		 */
		public static function hashInt(i:int):int
		{
			return hashString(i.toString());
		}
		
		private var _table:Array;
		private var _hash:Function;
		
		private var _size:int;
		private var _divisor:int;
		private var _count:int;
		
		/**
		 * Initializes a hash table.
		 * 
		 * @param size The size of the hash table.
		 * @param hash A hashing function.
		 */
		public function HashTable(size:int, hash:Function = null)
		{
			_count = 0;
			
			_hash = (hash == null) ? function(key:int):int { return key } : hash;
			_table = new Array(_size = size);
			
			for (var i:int = 0; i < size; i++)
				_table[i] = [];
			
			_divisor = _size - 1;
		}
		
		/**
		 * Inserts a key/data couple into the table.
		 * 
		 * @param key The key.
		 * @param obj The data associated with the key.
		 */
		public function insert(key:*, obj:*):void
		{
			_table[int(_hash(key) & _divisor)].push(new HashEntry(key, obj));
			_count++;
		}
		
		/**
		 * Finds the entry that is associated with the given key.
		 * 
		 * @param  key The key to search for.
		 * @return The data associated with the key or null if no matching
		 *         entry was found.
		 */
		public function find(key:*):*
		{
			var list:Array = _table[int(_hash(key) & _divisor)];
			var k:int = list.length, entry:HashEntry;
			for (var i:int = 0; i < k; i++)
			{
				entry = list[i];
				if (entry.key === key)
					return entry.data;
			}
			return null;
		}
		
		/**
		 * Removes an entry based on a given key.
		 * 
		 * @param  key The entry's key.
		 * @return The data associated with the key or null if no matching
		 *         entry was found.
		 */
		public function remove(key:*):*
		{
			var list:Array = _table[int(_hash(key) & _divisor)];
			var k:int = list.length;
			for (var i:int = 0; i < k; i++)
			{
				var entry:HashEntry = list[i];
				if (entry.key === key)
				{
					list.splice(i, 1);
					return entry.data;
				}
			}
			return null;
		}
		
		/**
		 * Checks if a given item exists.
		 * 
		 * @return True if item exists, otherwise false.
		 */
		public function contains(obj:*):Boolean
		{
			var list:Array, k:int = size;
			for (var i:int = 0; i < k; i++)
			{
				list = _table[i];
				var l:int = list.length; 
				
				for (var j:int = 0; j < l; j++)
					if (list[j].data === obj) return true;
			}
			return false;
		}
		
		/**
		 * Iterator not supported (yet).
		 */
		public function getIterator():Iterator
		{
			return new NullIterator();
		}
		
		/**
		 * Clears all elements.
		 */
		public function clear():void
		{
			_table = new Array(_size);
			_count = 0;
		}
		
		/**
		 * The total number of items.
		 */
		public function get size():int
		{
			return _count;
		}
		
		/**
		 * The maximum allowed size of the queue.
		 */
		public function get maxSize():int
		{
			return _size;
		}
		
		/**
		 * Converts the structure into an array.
		 * 
		 * @return An array.
		 */
		public function toArray():Array
		{
			var a:Array = [], list:Array, k:int = size;
			for (var i:int = 0; i < k; i++)
			{
				list = _table[i];
				var l:int = list.length; 
				
				for (var j:int = 0; j < l; j++)
					a.push(list[j]);
			}
			return a;
		}
		
		/**
		 * Returns a string representing the current object.
		 */
		public function toString():String
		{
			return "[HashTable, size=" + size + "]";
		}
		
		public function print():String
		{
			var s:String = "HashTable:\n";
			for (var i:int = 0; i < _size; i++)
			{
				if (_table[i])
					s += "[" + i + "]" + "\n" + _table[i];
			}
			return s;
		}
	}
}

/**
 * Simple container class for storing a key/data couple.
 */
internal class HashEntry
{
	public var key:int;
	
	public var data:*;
	
	public function HashEntry(key:int, data:*)
	{
		this.key = key;
		this.data = data;
	}
}


