/**
* ...
*/

package ocean.utils {
	import flash.utils.ByteArray;
	import flash.errors.EOFError;
	public class GreedyUINT {
	//*	MEMBERS//////////////////////////////////////////////////////
	
		private var _rawBytes:ByteArray;
	//*	PROPERTIES///////////////////////////////////////////////////
		
		/**
		* The value of GreedyUINT as uint.
		*/
		public function get value():uint{
			_rawBytes.position = 0;
			if(0==_rawBytes.length){
				throw new Error("value is not defined");
			}
			
			var n:uint;
			// value = (128^e)*b1+(128^e-1)*b2+....(128^0)*bn;
			for( var e:int = _rawBytes.length-1; e>=0; e-- ){
				n += ( _rawBytes.readByte()&0x7F )<<(7*e);
			}
			if( n==Infinity || n==-Infinity ){
				throw new Error("value is beyond uint infinity");
			}
			return n;
		}
		
		/**
		* Set the value of GreedyUINT with uint.
		* @param	n
		* @return
		*/
		public function set value(n:uint):void{
			_rawBytes.position = 0;
			var e:uint ;
			var t:uint ;
			var temp:Array=new Array();
			// bytes =[ n/(128^e)%128 | 0x80 , n/(128^e-1)%128 | 0x80 , ... n/(128^0)%128 ];
			if( 0!=n ){
				for( e=0 , t = n>>(7*e) ; t>=1 && e<5; ){
					//变长整数最后一个字节高bit位为0。其他字节高bit位为1，低七位是余数对128求模
					// tips:If the divisor is a power of 2, the modulo (%) operation can be done with:
					//	modulus = numerator & (divisor - 1);
					temp[e] = e?( t&(128-1) | 0x80 ): n&(128-1);//temp[e] = e?( t%128 | 0x80 ): n%128;
					
					// 余数为整数除以128的e次方
					t = n>>(7*(++e));
				}
			}else{
				temp[0]=0;
			}
			for( _rawBytes.length = e = temp.length ; e>0 ; e-- ){
				_rawBytes.writeByte(temp[e-1]);
			}
			
		}
		
		/**
		* RawBytes value in ByteArray format
		*/
		public function get rawBytes():ByteArray{
			_rawBytes.position = 0;
			return _rawBytes;
		}
		/**
		* set property rawBytes with input byteArray, this method will not effect the position of the coming byteArray.
		* @param	raw
		* @return
		*/
		public function set rawBytes(raw:ByteArray):void{
			_rawBytes.position = 0;
			_rawBytes.length = 0;
			if( check(raw) ){
				_rawBytes.writeBytes(raw);
				_rawBytes.position = 0;
			}else{
				throw new Error("input byteArrary is not a valid GreedyUINT");
			}
		}
	//*	METHODS//////////////////////////////////////////////////////
	
		/**
		* GreedyUINT is length flexible unsigned int type. 
		* When value a greedy uint, the high bit of the last byte is 0, other byte's high bit is 1. 
		* Each 7 bits equals the remainder moded by 128. 
		* <p><code>bytes = [ n/(128<sup>p</sup>)%128 | 0x80 , 
		* n/(128<sup>p-1</sup>)%128 | 0x80 , ... n/(128<sup>0</sup>)%128 ];</code></p>
		* @param	raw bytes to convert into greedy uint, if null creates a 0. 
		* @author Efishocean
		* @version 1.0.0
		* fixed the byteArray position to zero in every function's first line 2007-7-25 11:58
		*/
		public function GreedyUINT(raw:ByteArray=null):void{
			_rawBytes = new ByteArray();
			if( null==raw ){
				_rawBytes[0]=0;
			}
			else if( check(raw) ){
				_rawBytes.writeBytes(raw);
			}
			else{
				throw new Error("input byteArrary is not a valid GreedyUINT");
			}
		}
		
		/**
		* Checks if the input raw datas are valid greedyUINT
		* @param	raw bytes
		* @return valid or not.
		* @ 2007-7-18 23:08
		*/
		public function check(raw:ByteArray):Boolean{
			if( null==raw ){return false;}
			var len:uint = raw.length;
			//变长只处理小于4294967295的数，这个范围内可以用小于5个字节的变长表示
			if( len>5 || len<=0){return false;}
			//变长整数最后一字节8bit位为零
			if( (raw[len-1] & 0x80) != 0x00 ){
				return false;
			}
			//前面字节的8bit位为'1'
			else{
				for( var i:uint=0; i<len-1 ; i++ ){
					if( (raw[i]&0x80)!=0x80 ){
						return false ;
					}
				}
			}
			return true;
		}
		
		/**
		* Copies greedy uint from stream obay the valid format. this method will push the position of stream forward.
		* @param raw bytes stream
		* @see #GreedyUINT()
		*/
		public function stream(raw:ByteArray):void{
			_rawBytes.position = 0;
			_rawBytes.length = 0 ;
			var temp:int;
			
			do{
				//从流中读出一字节
				try{
					temp = raw.readByte();
				}catch(e:EOFError){
					throw new Error("End of File Error! Not enough bytes to read.");
				}
				//写入字节
				_rawBytes.writeByte(temp);
				//如果8bit位是0，读取变长整数结束，否则继续读取下一个字节
			}while( (temp&0x80)!=0x00 && _rawBytes.length<=5);
			if( _rawBytes.length == 6 ){
				throw new Error("can't deal with uint value beyond 4294967295. This stream is not countable .");
			}

		}

		/**
		* The length of greedy uint in bytes
		*/
		public function get length():uint{
			return rawBytes.length;
		}

		
	}
	
}
