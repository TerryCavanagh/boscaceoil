package de.polygonal.ds
{
	import flash.utils.Dictionary;
	import de.polygonal.ds.Collection;
	
	public class HashMap implements Collection
	{
		private var _keyMap:Dictionary;
		private var _objMap:Dictionary;
		private var _size:int;
		
		/**
		 * Initializes a hash map, which maps
		 * keys to values. It cannot contain duplicate keys so
		 * each key can map to at most one value.
		 */
		public function HashMap()
		{
			_keyMap = new Dictionary(true);
			_objMap = new Dictionary(true);
			_size = 0;
		}
		
		/**
		 * Inserts a key/data couple into the table.
		 * 
		 * @param key The key.
		 * @param obj The data associated with the key.
		 */
		public function insert(key:*, obj:*):Boolean
		{
			if (_keyMap[key]) return false;
			++_size;
			_objMap[obj] = key;
			_keyMap[key] = obj;
			return true;
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
			return _keyMap[key] || null;
		}
		
		/**
		 * Finds the key that maps the given value.
		 * 
		 * @param  val The value which maps the sought-after key.
		 * @return The key mapping the given value or null if no matching
		 *         key was found.
		 */
		public function findKey(val:*):*
		{
			return _objMap[val] || null;
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
			var obj:* = _keyMap[key];
			
			if (obj)
			{
				--_size;
				delete _keyMap[key];
				delete _objMap[obj];
				return obj;
			}
			return null;
		}
		
		/**
		 * Checks if a key maps the given value.
		 * 
		 * @return True if value exists, otherwise false.
		 */
		public function contains(obj:*):Boolean
		{
			return _objMap[obj] ? true : false;
		}
		
		/**
		 * Checks if a mapping exists for the given key.
		 * 
		 * @return True if key exists, otherwise false.
		 */
		public function containsKey(key:*):Boolean
		{
			return _keyMap[key] ? true : false;
		}
		
		/**
		 * Creates an interator for traversing the values.
		 */
		public function getIterator():Iterator
		{
			return new HashMapValueIterator(this);
		}
		
		/**
		 * Creates an interator for traversing the keys.
		 */
		public function getKeyIterator():Iterator
		{
			return new HashMapKeyIterator(this);
		}
		
		/**
		 * Clears all elements.
		 */
		public function clear():void
		{
			_keyMap = new Dictionary(true);
			_objMap = new Dictionary(true);
			_size = 0;
		}
		
		/**
		 * The total number of items.
		 */
		public function get size():int
		{
			return _size;
		}
		
		/**
		 * Checks if the map is empty.
		 * 
		 * @return True if empty, otherwise false.
		 */
		public function isEmpty():Boolean
		{
			return _size == 0;
		}
		
		/**
		 * Writes all values into an array.
		 * 
		 * @return An array.
		 */
		public function toArray():Array
		{
			var a:Array = new Array(_size), j:int = 0;
			for each (var i:* in _keyMap)
			{
				a[j++] = i;
			}
			return a;
		}
		
		/**
		 * Writes all keys into an array.
		 * 
		 * @return An array.
		 */
		public function getKeySet():Array
		{
			var a:Array = new Array(_size), j:int = 0;
			for each (var i:* in _objMap)
			{
				a[j++] = i;
			}
			return a;
		}
		
		/**
		 * Returns a string representing the current object.
		 */
		public function toString():String
		{
			return "[HashMap, size=" + size + "]";
		}
		
		/**
		 * Prints all elements (for debug/demo purposes only).
		 */
		public function dump():String
		{
			var s:String = "HashMap:\n";
			for each (var i:* in _objMap)
				s += "[key: " + i + " val:" + _keyMap[i] + "]\n";
			return s;
		}
	}
}

import de.polygonal.ds.Iterator;
import de.polygonal.ds.HashMap;

internal class HashMapValueIterator implements Iterator
{
	private var _h:HashMap;
	private var _values:Array;
	private var _cursor:int;
	private var _size:int;
	
	public function HashMapValueIterator(h:HashMap)
	{
		_h = h;
		_values = h.toArray();
		_cursor = 0;
		_size = _h.size; 
	}
	
	public function get data():*
	{
		return _values[_cursor];
	}
	
	public function set data(obj:*):void
	{
		var key:* = _h.findKey(_values[_cursor]);
		_h.remove(key);
		_h.insert(key, obj);
	}
	
	public function start():void
	{
		_cursor = 0;
	}
	
	public function hasNext():Boolean
	{
		return _cursor < _size;
	}
	
	public function next():*
	{
		return _values[_cursor++];
	}
}

internal class HashMapKeyIterator implements Iterator
{
	private var _h:HashMap;
	private var _keys:Array;
	private var _cursor:int;
	private var _size:int;
	
	public function HashMapKeyIterator(h:HashMap)
	{
		_h = h;
		_keys = h.getKeySet();
		_cursor = 0;
		_size = _h.size; 
	}
	
	public function get data():*
	{
		return _keys[_cursor];
	}
	
	public function set data(obj:*):void
	{
		var key:* = _keys[_cursor];
		var val:* = _h.find(key);
		_h.remove(key);
		_h.insert(obj, val);
	}
	
	public function start():void
	{
		_cursor = 0;
	}
	
	public function hasNext():Boolean
	{
		return _cursor < _size;
	}
	
	public function next():*
	{
		return _keys[_cursor++];
	}
}