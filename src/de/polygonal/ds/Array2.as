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
	 * A two-dimensonal array built upon a single linear array.
	 */
	public class Array2 implements Collection
	{
		private var _a:Array;
		private var _w:int, _h:int;
		
		/**
		 * Initializes a two-dimensional array to match the given width and height.
		 * 
		 * @param w The width  (number of colums).
		 * @param h The height (number of rows).
		 */
		public function Array2(width:int, height:int)
		{
			_a = new Array((_w = width) * (_h = height));
			fill(null);
		}
		
		/**
		 * Indicates the width (colums).
		 * If a new width is set, the two-dimensional array is resized accordingly.
		 */
		public function get width():int
		{
			return _w;
		}
		
		public function set width(w:int):void
		{
			resize(w, _h);
		}
		
		/**
		 * Indicates the height (rows).
		 * If a new height is set, the two-dimensional array is resized accordingly.
		 */
		public function get height():int
		{
			return _h;
		}
		
		public function set height(h:int):void
		{
			resize(_w, h);
		}
		
		/**
		 * Sets each cells in the two-dimensional array to a given value.
		 * 
		 * @param item The item to be written into each cell.
		 */
		public function fill(item:*):void
		{
			var k:int = _w * _h;
			for (var i:int = 0; i < k; i++)
				_a[i] = item;
		}
		
		/**
		 * Reads the value at the given x/y index.
		 * No boundary check is performed, so you have to
		 * make sure that the input coordinates do not exceed
		 * the width or height of the two-dimensional array.
		 *
		 * @param x The x index.
		 * @param y The y index.
		 */
		public function get(x:int, y:int):*
		{
			return _a[int(y * _w + x)];
		}
		
		/**
		 * Writes data into the cell at the given x/y index.
		 * No boundary check is performed, so you have to
		 * make sure that the input coordinates do not exceed
		 * the width or height of the two-dimensional array.
		 *
		 * @param x The x index.
		 * @param y The y index.
		 * @param obj The item to be written into the cell.
		 */
		public function set(x:int, y:int, obj:*):void
		{
			_a[int(y * _w + x)] = obj;
		}
		
		/**
		 * Resizes the array to match the given width and height
		 * while preserving existing values.
		 * 
		 * @param w The new width (cols)
		 * @param h The new height (rows)
		 */
		public function resize(w:int, h:int):void
		{
			if (w <= 0) w = 1;
			if (h <= 0) h = 1;
			
			var copy:Array = _a.concat();
			
			_a.length = 0;
			_a.length = w * h;
			
			var minx:int = w < _w ? w : _w;
			var miny:int = h < _h ? h : _h;
			
			var x:int, y:int, t1:int, t2:int;
			for (y = 0; y < miny; y++)
			{
				t1 = y *  w;
				t2 = y * _w;
				
				for (x = 0; x < minx; x++)
					_a[int(t1 + x)] = copy[int(t2 + x)];
			}
			
			_w = w;
			_h = h;
		}
		
		/**
		 * Extracts the row at the given index.
		 * 
		 * @return An array storing the values of the row.
		 */
		public function getRow(y:int):Array
		{
			var offset:int = y * _w;
			return _a.slice(offset, offset + _w);
		}
		
		/**
		 * Extracts the colum at the given index.
		 * 
		 * @return An array storing the values of the column.
		 */
		public function getCol(x:int):Array
		{
			var t:Array = [];
			for (var i:int = 0; i < _h; i++)
				t[i] = _a[int(i * _w + x)];
			return t;
		}
		
		/**
		 * Shifts all columns by one column to the left.
		 * Columns are wrapped, so the column at index 0 is
		 * not lost but appended to the rightmost column.
		 */
		public function shiftLeft():void
		{
			if (_w == 1) return;
			
			var j:int = _w - 1, k:int;
			for (var i:int = 0; i < _h; i++)
			{
				k = i * _w + j;
				_a.splice(k, 0, _a.splice(k - j, 1));
			}
		}
		
		/**
		 * Shifts all columns by one column to the right.
		 * Columns are wrapped, so the column at the last index is
		 * not lost but appended to the leftmost column.
		 */
		public function shiftRight():void
		{
			if (_w == 1) return;
			
			var j:int = _w - 1, k:int;
			for (var i:int = 0; i < _h; i++)
			{
				k = i * _w + j;
				_a.splice(k - j, 0, _a.splice(k, 1));
			}
		}
		
		/**
		 * Shifts all rows up by one row.
		 * Rows are wrapped, so the first row is
		 * not lost but appended to bottommost row.
		 */
		public function shiftUp():void
		{
			if (_h == 1) return;
			
			_a = _a.concat(_a.slice(0, _w));
			_a.splice(0, _w);
		}
		
		/**
		 * Shifts all rows down by one row.
		 * Rows are wrapped, so the last row is
		 * not lost but appended to the topmost row.
		 */
		public function shiftDown():void
		{
			if (_h == 1) return;
			
			var offset:int = (_h - 1) * _w;
			_a = _a.slice(offset, offset + _w).concat(_a);
			_a.splice(_h * _w, _w);
		}
		
		/**
		 * Appends an array as a new row.
		 * If the given array is longer or shorter than the current width,
		 * it is truncated or widened to match the current dimensions.
		 *
		 * @param a The array to insert.
		 */
		public function appendRow(a:Array):void
		{
			a.length = _w;
			_a = _a.concat(a);
			_h++
		}
		
		/**
		 * Prepends an array as a new row.
		 * If the given array is longer or shorter than the current width,
		 * it is truncated or widened to match the current dimensions.
		 * 
		 * @param a The array to insert.
		 */
		public function prependRow(a:Array):void
		{
			a.length = _w;
			_a = a.concat(_a);
			_h++;
		}
		
		/**
		 * Appends an array as a new column.
		 * If the given array is longer or shorter than the current height,
		 * it is truncated or widened to match the current dimensions.
		 * 
		 * @param a The array to insert.
		 */
		public function appendCol(a:Array):void
		{
			a.length = _h;
			for (var y:int = 0; y < _h; y++)
				_a.splice(y * _w + _w + y, 0, a[y]);
			_w++;
		}
		
		/**
		 * Prepends an array as a new column.
		 * If the given array is longer or shorter than the current height,
		 * it is truncated or widened to match the current dimensions.
		 * 
		 * @param a - The array to insert.
		 */
		public function prependCol(a:Array):void
		{	
			a.length = _h;
			for (var y:int = 0; y < _h; y++)
				_a.splice(y * _w + y, 0, a[y]);
			_w++;
		}
		
		/**
		 * Flips rows with cols and vice versa.
		 * This is equivalent of rotating the array about 180 degrees.
		 */
		public function transpose():void
		{
			var a:Array = _a.concat();
			for (var y:int = 0; y < _h; y++)
			{
				for (var x:int = 0; x < _w; x++)
					_a[int(x * _w + y)] = a[int(y * _w + x)]
			}
		}
		
		/**
		 * Checks if a given item exists.
		 * 
		 * @return True if the specified item is found, otherwise false.
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
		 * Initializes an iterator object
		 * pointing to the first value (0, 0).
		 */
		public function getIterator():Iterator
		{
			return new Array2Iterator(this);
		}
		
		/**
		 * The total number of cells.
		 */
		public function get size():int
		{
			return _w * _h;
		}
		
		/**
		 * Checks if the 2d array is empty.
		 */
		public function isEmpty():Boolean
		{
			return false;
		}
		
		/**
		 * Converts the structure into an array.
		 * 
		 * @return An array storing the data of this structure.
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
			return "[Array2, width=" + width + ", height=" + height + "]";
		}
		
		/**
		 * Prints all elements (for debug/demo purposes only).
		 */
		public function dump():String
		{
			var s:String = "Array2\n{";
			var offset:int, value:*;
			for (var y:int = 0; y < _h; y++)
			{
				s += "\n" + "\t";
				offset = y * _w;
				for (var x:int = 0; x < _w; x++)
				{
					value = _a[int(offset + x)];
					s += "[" + (value != undefined ? value : "?") + "]";
				}
			}
			s += "\n}";
			return s;
		}
	}
}

import de.polygonal.ds.Iterator;
import de.polygonal.ds.Array2;

internal class Array2Iterator implements Iterator
{
	private var _a2:Array2;
	private var _xCursor:int;
	private var _yCursor:int;
	
	public function Array2Iterator(a2:Array2)
	{
		_a2 = a2;
		_xCursor = _yCursor = 0;
	}
	
	public function get data():*
	{
		return _a2.get(_xCursor, _yCursor);
	}
	
	public function set data(obj:*):void
	{
		_a2.set(_xCursor, _yCursor, obj);
	}
	
	public function start():void
	{
		_xCursor = _yCursor = 0;
	}
	
	public function hasNext():Boolean
	{
		return (_yCursor * _a2.width + _xCursor < _a2.size);
	}
	
	public function next():*
	{
		var item:* = data;
		
		if (++_xCursor == _a2.width)
		{
			_yCursor++;
			_xCursor = 0;
		}
		
		return item;
	}
}