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
	 * A bitvector.
	 * 
	 * A bitvector is meant to condense bit values (or booleans) into
	 * an array as close as possible so that no space is wasted.
	 */
	public class BitVector
	{
		private var _bits:Array;
		private var _arrSize:int;
		private var _bitSize:int;
		
		/**
		 * Creates a bitvector with a given number of bits.
		 * Each cell holds a 31-bit signed integer.
		 * 
		 * @param bits The total number of bits.
		 */
		public function BitVector(bits:int)
		{
			_bits = [];
			_arrSize = 0;
			
			resize(bits);
		}
		
		/**
		 * The total number of bits.
		 */
		public function get bitCount():int
		{
			return _arrSize * 31;
		}
		
		/**
		 * The total number of cells.
		 */
		public function get cellCount():int
		{
			return _arrSize;
		}
		
		/**
		 * Gets a bit from a given index.
		 * 
		 * @param index The index of the bit.
		 */
		public function getBit(index:int):int
		{
			var bit:int = index % 31;
			return (_bits[(index / 31) >> 0] & (1 << bit)) >> bit;
		}
		
		/**
		 * Sets a bit at a given index.
		 * 
		 * @param index The index of the bit.
		 * @param b     The boolean flag to set.
		 */
		public function setBit(index:int, b:Boolean):void
		{
			var cell:int = index / 31;
			var mask:int = 1 << index % 31;
			_bits[cell] = b ? (_bits[cell] | mask) : (_bits[cell] & (~mask));
		}
		
		/**
		 * Resizes the bitvector to an appropriate number of bits.
		 * 
		 * @param size The total number of bits.
		 */
		public function resize(size:int):void
		{
			if (size == _bitSize) return;
			_bitSize = size;
			
			//convert the bit-size to integer-size
			if (size % 31 == 0)
				size /= 31;
			else
				size = (size / 31) + 1;
			
			if (size < _arrSize)
			{
				_bits.splice(size);
				_arrSize = size;
			}
			else
			{
				_bits = _bits.concat(new Array(size - _arrSize));
				_arrSize = _bits.length;
			}
		}
		
		/**
		 * Resets all bits to 0;
		 */
		public function clear():void
		{
			var k:int = _bits.length;
			for (var i:int = 0; i < k; i++)
				_bits[i] = 0;
		}
		
		/**
		 * Sets each bit to 1.
		 */
		public function setAll():void
		{
			var k:int = _bits.length;
			for (var i:int = 0; i < k; i++)
				_bits[i] = int.MAX_VALUE;
		}
		
		/**
		 * Returns a string representing the current object.
		 */
		public function toString():String
		{
			return "[BitVector, size=" + _bitSize + "]";
		}
	}
}

