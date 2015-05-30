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
	
	/**
	 * A three-dimensonal array build upon a single linear array.
	 */
	public class Array3 implements Collection
	{
		private var _a:Array;
		private var _w:int, _h:int, _d:int;
		
		/**
		 * Initializes a three-dimensional array to match the given width, height and depth.
		 * 
		 * width  - The width (number of columns).
		 * height - The height (number of rows).
		 * depth  - The depth (number of layers).
		 */
		public function Array3(w:int, h:int, d:int)
		{
			_a = new Array((_w = w) * (_h = h) * (_d = d));
		}
		
		/**
		 * Indicates the width (columns).
		 * If a new width is set, the structure is resized accordingly.
		 */
		public function get width():int
		{
			return _w;
		}
		
		public function set width(w:int):void
		{
			resize(w, _h, _d);
		}
		
		/**
		 * Indicates the height (rows).
		 * If a new height is set, the structure is resized accordingly.
		 */
		public function get height():int
		{
			return _h;
		}
		
		public function set height(h:int):void
		{
			resize(_w, h, _d);
		}
		
		/**
		 * Indicates the depth (layers).
		 * If a new depth is set, the structure is resized accordingly.
		 */
		public function get depth():int
		{
			return _d;
		}
		
		public function set depth(d:int):void
		{
			resize(_w, _h, d);
		}
		
		/**
		 * Sets each cell in the three-dimensional array to a given value.
		 * 
		 * @param obj The data.
		 */
		public function fill(obj:*):void
		{
			var k:int = size;
			for (var i:int = 0; i < k; i++)
				_a[i] = obj;
		}
		
		/**
		 * Reads the data at the given x/y/z index.
		 * No boundary check is performed, so you have to
		 * make sure the x, y and z index does not exceed the
		 * width, height or depth of the structure.
		 *
		 * @param x The x index.
		 * @param y The y index.
		 * @param z The z index.
		 */
		public function get(x:int, y:int, z:int):*
		{
			return _a[int((z * _w * _h) + (y * _w) + x)];
		}
		
		/**
		 * Writes data into the cell at the given x/y/z index.
		 * No boundary check is performed, so you have to
		 * make sure the x, y and z index does not exceed the
		 * width, height or depth of the structure.
		 * 
		 * @param x   The x index.
		 * @param y   The y index.
		 * @param z   The z index.
		 * @param obj The data to store.
		 */
		public function set(x:int, y:int, z:int, obj:*):void
		{
			_a[int((z * _w * _h) + (y * _w) + x)] = obj;
		}
		
		/**
		 * Resizes the array to match the given width, height and depth
		 * while preserving existing values.
		 * 
		 * @param w The new width (columns)
		 * @param h The new height (rows)
		 * @param d The new depth (layers)
		 */
		public function resize(w:int, h:int, d:int):void
		{
			var tmp:Array = _a.concat();
			
			_a.length = 0;
			_a.length = w * h * d;
			
			if (_a.length == 0)
				return;
			
			var xMin:int = w < _w ? w : _w;
			var yMin:int = h < _h ? h : _h;
			var zMin:int = d < _d ? d : _d;
			
			var x:int, y:int, z:int;
			var t1:int, t2:int, t3:int, t4:int;
			
			for (z = 0; z < zMin; z++)
			{
				t1 = z *  w  * h;
				t2 = z * _w * _h;
				
				for (y = 0; y < yMin; y++)
				{
					t3 = y *  w;
					t4 = y * _w;
					
					for (x = 0; x < xMin; x++)
						_a[t1 + t3 + x] = tmp[t2 + t4 + x];
				}
			}
			
			_w = w;
			_h = h;
			_d = d;
		}
		
		/**
		 * Checks if a given item exists.
		 * 
		 * @return True if the item is found, otherwise false.
		 */
		public function contains(obj:*):Boolean
		{
			var k:int = size;
			for (var i:int = 0; i < k; i++)
			{
				if (_a[i] === obj)
					return true;
			}
			return false;
		}
		
		/**
		 * Clears all elements.
		 */
		public function clear():void
		{
			_a = new Array(size);
		}
		
		/**
		 * Initializes an iterator object pointing to the
		 * first item (0, 0) in the first layer.
		 */
		public function getIterator():Iterator
		{
			return new Array3Iterator(this);
		}
		
		/**
		 * The total number of cells.
		 */
		public function get size():int
		{
			return _w * _h * _d;
		}
		
		/**
		 * Checks if the 3d array is empty.
		 */
		public function isEmpty():Boolean
		{
			return false;
		}
		
		
		/**
		 * Converts the structure into an array.
		 * 
		 * @return An array.
		 */
		public function toArray():Array
		{
			var a:Array = _a.concat();
			
			var k:int = size;
			if (a.length > k) a.length = k;
			return a;
		}
		
		/**
		 * Returns a string representing the current object.
		 */
		public function toString():String
		{
			return "[Array3, size=" + size + "]";
		}
	}
}

import de.polygonal.ds.Iterator;
import de.polygonal.ds.Array3;

internal class Array3Iterator implements Iterator
{
	private var _values:Array;
	private var _length:int;
	private var _cursor:int;
	
	public function Array3Iterator(a3:Array3)
	{
		_values = a3.toArray();
		_length = _values.length;
		_cursor = 0;
	}
	
	public function get data():*
	{
		return _values[_cursor];
	}
	
	public function set data(obj:*):void
	{
		_values[_cursor] = obj;
	}
	
	public function start():void
	{
		_cursor = 0;
	}
	
	public function hasNext():Boolean
	{
		return _cursor < _length;
	}
	
	public function next():*
	{
		return _values[_cursor++];
	}
}