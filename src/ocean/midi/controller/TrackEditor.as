/**
 * Copyright(C) 2008 Efishocean
 * 
 * This file is part of Midias.
 *
 * Midias is an ActionScript3 midi lib developed by Efishocean.
 * Midias was extracted from my project 'ocean' which purpose to 
 * impletement a commen audio formats libray. 
 * More infos might appear on my blog http://www.tan66.cn 
 * 
 * Midias is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 * 
 * Midias is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>
 */

package ocean.midi.controller {
	import de.polygonal.ds.DLinkedList;
	import de.polygonal.ds.DListIterator;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import ocean.midi.model.MetaItem;
	import ocean.midi.model.NoteItem;
	
	import ocean.midi.model.MessageItem;
	import ocean.midi.model.MessageList;
	import ocean.midi.MidiEnum;
	import ocean.midi.InvalidMidiError;
	import ocean.midi.event.MvcEvent;
	import ocean.midi.controller.History;
	
	/**
	* TrackEditor class controlls one track specified by the setter 'activeMsgList'
	*
	* Each track utilies a single messageListEditor instance,
	* cause it provides undo and redo method just on one certain file.
	*
	* Some methods invoke the execute method,
	* which stores the references of changed items into two array, the 'after' and 'before'.
	*
	* The methods execute, undo and redo will invoke update subsequence.
	* During update processing, updateA and updateB refer to the provided arrA and arrB,
	* and have their marks of items swtiched,
	* then sent an "update" event to notify the relative views to redraw these items.
	*
	* This means each time when updating occurs,
	* some old items may be deactivated, and some new items may be created and pushed into current list.
	* The relative views should redraw these special old items and new items
	* @author EfishOcean 2007-8-7 22:51
	* @version 0.1
	*/
	public class TrackEditor extends EventDispatcher{
		//
		private var _activeMsgList:MessageList;
		private var _globalHistory:History;
		private var _stack:DLinkedList;
		private var _itr:DListIterator;
		public var pending:Array;

		/**
		* Edits midi track
		* @param messageList Midi event messages.
		* @see ocean.midi.model.MessageList
		*/
		public function TrackEditor(messageList:MessageList=null):void{
			
			if( messageList != null ){
				_activeMsgList = messageList;
			}
			else{
				_activeMsgList = new MessageList();
			}
			_globalHistory = History.getHistory();
			_stack = _globalHistory.stack;
			
			_itr = _globalHistory.iterator;
		}
		
		/**
		 * The activeMsgList
		 */
		public function set activeMsgList(msgList:MessageList):void{
			if( msgList != null ){
				_activeMsgList = msgList;
			}
			else{
				throw new InvalidMidiError("set midi message list error, midi track is invalid");
			}
			dispatchEvent( new MvcEvent( MvcEvent.APPLY_TRACK ) );
		}
		
		/**
		 * The active message List in editing.
		 */
		public function get activeMsgList():MessageList{
			return _activeMsgList;
		}

		private function get _history():uint{
			return _globalHistory.size;
		}
		
		/**
		* Clones items from list, and form a new messageList
		* @param	list Active message list.
		* @return	the new messageList.
		* @see ocean.midi.model.MessageList
		*/
		public function copy( list:MessageList ):MessageList{
			var msgList:MessageList = new MessageList();
			//find the min time
			var min:uint = 0;
			for each( var item:MessageItem in list ){
				if( item.mark ){
					min = min<item.timeline ? min : item.timeline;
					// clone item
					msgList.push(item.clone());
				}
			}
			
			//fix each item's timeline, however the 1st item's timeline should be zero.
			for each( item in msgList ){
				item.timeline -= min;
			}
			return msgList;
		}
		
		/**
		* Cuts some items from 'list' , and return a new messageList
		* @param	list Active message list.
		* @return	Reference of active message list.
		* @see ocean.midi.model.MessageList
		*/
		public function cut( list:MessageList ):MessageList{
			var msgList:MessageList = copy(list);
			erase(list);
			return msgList;
		}
		

		/**
		* Apply filter on message list. An example filter is defined in pan method as closure fucntion.
		* @param	selected All items in selected list should be selected note-item's reference
		* @param	filter Function that can modify the items in eventlist.
		* 			A proper filter should like the following: 
		* <listing version="3.0">function tuneFilter( msg:EventItem , [args] ):void{;}</listing>
		* @param	...args More arguments.
		* 			<p>WARNING! if the filter is modifying the timeline of item, it should pass the
		* 			_end-of-track item as arguments and fix it.</p>
		* @see ocean.midi.model.MessageList
		*/
		public function applyFilter( selected:MessageList , filter:Function , ...args ):void{
			var after:Array = new Array();
			var temp:MessageItem;
			var item:MessageItem;
			
			//use selfFeedBackSecurity is because:
			//if the 'filter' callback invokes selected as args, will also cause problems.
			//for example: filter descrease the length of selected, item may point at undefined position.
			var selfFeedbackSecurity:Array = new Array();
			for each( item in selected ){
				temp = item.clone();
				// abandon old items
				item.mark = false;
				after.push( item );
				selfFeedbackSecurity.push(temp);
			}
			
			//don't use for each here, because selected is part of _activeMsgList.
			for( var i:int=selfFeedbackSecurity.length ; i>0 ; i-- ){
					temp = selfFeedbackSecurity[i-1];
					// add new items
					filter( temp , args );
					_activeMsgList.push(temp);
					after.push( temp );
			}
			execute(after);
		}
		

		/**
		* Pans a block of selected items.  
		* @param	list @see ocean.midi.model.MessageList
		* @param	v Vertical panning pitch.
		* @param	h Horizontal panning timeline.
		*/
		public function pan( list:MessageList , v:int=0 , h:int=0 ):void{
			if( v!=0 || h!=0 ){
				var filter:Function = function(item:MessageItem , args:Array ):void{
					//pan the timeline
					if( ( item.timeline+args[1] )<0 )
						item.timeline = 0;
					else
						item.timeline += args[1];
					if( item is NoteItem ){
						//max key is G#10
						if( ((item as NoteItem).pitch+args[0])>0x7F )
							(item as NoteItem).pitch = 0x7F;
						//min key is C
						else if(((item as NoteItem).pitch+args[0])<0x00 )
							(item as NoteItem).pitch = 0x00;
						//pan the pitch
						else
							(item as NoteItem).pitch += args[0];
						//args[2] is the _end-of-track reference, keep it always at the end
						////args[2].timeline = args[2].timeline>(item.timeline+(item as NoteItem).duration) ? args[2].timeline : (item.timeline+(item as NoteItem).duration);
					}
					
				}
				this.applyFilter( list , filter , v , h );
			}
		}

		
		/**
		* Inserts a message to the track. Don't alter following messages's deltatime
		* @param	atTime Time position to insert .
		* @param	item @see ocean.midi.model.MessageItem 
		*/
		public function insertMessage( atTime:uint , item:MessageItem ):void{
			
			var after:Array = new Array();
			var temp:MessageItem;

			temp = item.clone();
			temp.timeline = atTime;
			temp.mark = true;
			after.push(temp);
			
			// temp list, later concat to _activeMsgList
			var tempList:MessageList = new MessageList();
			tempList.push(temp);
			
			//maxtimeline+maxduration - atTime indecates slide
			var slide:uint = (temp is NoteItem) ? (temp as NoteItem).duration : 0;
			
			// fixed the _end-of-track item
			////_end.timeline += slide;

			if( temp is NoteItem ){

				//slide old, and form a abandoned array
				for each( var it:* in _activeMsgList ){
					// _end is always not in undo-redo stack
					if( it.mark ){
						if( it.timeline>=atTime ){

							// slide cloned item
							temp = it.clone();
							temp.timeline += slide;
							
							// new item
							temp.mark = true;
							
							//old item
							it.mark = false;
							
							// add new item
							tempList.push(temp);
							
							// record added item
							after.push(temp);
							
							// record abandoned item
							after.push(it);
							
						}
					}
				}
			}
			//add new items
			for each( var _it:* in tempList){
				_activeMsgList.push(_it);
			}
		
			execute(after);
		}
		/**
		 * paste a message to the track. alter the following message's deltatime. Erase it if collision detected.
		 * @param	atTime Time position to paste.
		 * @param	item @see ocean.midi.model.MessageItem 
		 */
		 public function pasteMessage( atTime:uint , item:MessageItem ):void{
			
			var after:Array = new Array();
			var temp:MessageItem;
			temp = item.clone();
			temp.timeline = atTime;
			temp.mark = true;
			after.push(temp);
			
			//note's time line between new item's duration is abandoned.
			if( temp is NoteItem ){
		
				for each( var it:MessageItem in _activeMsgList ){
					if( it.kind==MidiEnum.NOTE && it.timeline>=atTime && it.timeline<(atTime+(temp as NoteItem).duration) ){
						
						it.mark = false;
						after.push(it);
						
					}
				}
			}
			//add new item
			_activeMsgList.push(temp);
			
			execute(after);
		}
		
		/**
		 * Merge a message to the track. alter the following message's deltatime. make it stable.		
		 * @param	atTime Time position to insert .
		 * @param	item @see ocean.midi.model.MessageItem 
		 */
		public function mergeMessage( atTime:uint , item:MessageItem ):void{
			
			var after:Array = new Array();
			var temp:MessageItem;
			temp = item.clone();
			temp.timeline = atTime;
			temp.mark = true;
			_activeMsgList.push(temp);
			after.push(temp);
			execute(after);
		}
		
		/**
		 * Erases a message, specified by index in messageList
		 * @param item to be erased.
		 * @return the erased item
		 */
		public function eraseMessage( item:MessageItem ):void{
			var after:Array = new Array();
			item.mark = false;
			after.push(item);
			execute(after);
		}
		
		/**
		* Insert a track fragment into the track at special time.
		* @param	atTime postion to insert.
		* @param list to be inserted.
		* @see ocean.midi.model.MessageList
		*/
		public function insert(atTime:uint , list:MessageList):void{
			
			var after:Array = new Array();
			var slide:uint=0;
			var temp:MessageItem;
			var tempList:MessageList = new MessageList();
			for each( var item:MessageItem in list ){
				if( item.mark ){
					
					// clone an item
					temp = item.clone();
					
					// fix timeline of lst
					temp.timeline += atTime;
					
					if( item is NoteItem ){
						
						// max timeline in list
						slide = ( slide > (temp.timeline+(temp as NoteItem).duration)) ? slide : (temp.timeline+(temp as NoteItem).duration) ;
					}
					
					// new item
					temp.mark = true;
					
					// add new item
					tempList.push(temp);
					
					// record action
					after.push(temp);
				}
			}
			
			//maxtimeline+maxduration - atTime indecates slide
			slide -= atTime;
			
			//slide old, and form a abandoned array
			for each( item in _activeMsgList ){
				if( item.mark ){
					if( item.timeline>=atTime ){
						
						// slide cloned item
						temp = item.clone();
						temp.timeline += slide;
						
						// new item
						temp.mark = true;
						
						//old item
						item.mark = false;
						
						// add new item
						tempList.push(temp);
						
						// record added item
						after.push(temp);
						
						// record abandoned item
						after.push(item);
						
					}
				}
			}
			
			//add new items
			for each( item in tempList){
				_activeMsgList.push(item);
			}
			
			execute(after);
		}
		
		/**
		* Replaces a list of items where the timeline is map the range of list
		* @param	atTime position to be replaced with new.
		* @param	list to be replaced
		* @see ocean.midi.model.MessageList
		*/
		public function paste(atTime:uint , list:MessageList):void{
			
			var after:Array = new Array();
			var max:uint=0;
			var temp:MessageItem;
			var tempList:MessageList = new MessageList();
			for each( var item:MessageItem in list ){
				if( item.mark ){
					
					// clone an item
					temp = item.clone();
					
					// fix timeline
					temp.timeline += atTime ;
					
					if( item.kind == MidiEnum.NOTE ){
						
						// max timeline in list
						max = ( max > (temp.timeline+(temp as NoteItem).duration)) ? max : (temp.timeline+(temp as NoteItem).duration) ;
					}else{
						max = max > temp.timeline ? max : temp.timeline;
					}
					
					//new item
					temp.mark = true;
					
					// add new item to tempList
					tempList.push(temp);
					
					// record action
					after.push(temp);
				}
			}
			
			//form a abandoned array
			for each( item in _activeMsgList ){
				if( item.mark ){
					if( item.kind==MidiEnum.NOTE && item.timeline>=atTime && item.timeline<max ){
						
						//old item
						item.mark = false;
						
						// record action
						after.push(item);
					}
				}
			}
			// add new items
			for each( item in tempList){
				_activeMsgList.push(item);
			}
			
			execute(after);
		}
		
		/**
		* Merge activeMsgList with new list.
		* @param	atTime position to push
		* @param	list to merge.
		* @see ocean.midi.model.MessageList
		*/
		public function merge(atTime:uint , list:MessageList):void{
			var max:uint = 0;
			var after:Array = new Array();
			var temp:MessageItem;
			for each( var item:MessageItem in list ){
				if( item.mark ){
					
					// clone an item
					temp = item.clone();
					
					//fix timeline
					temp.timeline += atTime ;
					
					if( item.kind == MidiEnum.NOTE ){
						
						// max timeline in list
						max = ( max > (temp.timeline+(temp as NoteItem).duration)) ? max : (temp.timeline+(temp as NoteItem).duration) ;
					}else{
						max = max > temp.timeline ? max : temp.timeline;
					}
					
					//new item
					item.mark = true;
					
					//add item
					_activeMsgList.push(temp);
					
					//record into stack
					after.push(temp);
				}
			}
			
			execute(after);
		}
		
		/**
		* Erases a list of datas from the activeMsgList.
		* @param	list item references selected from activeMsgList.
		* @see ocean.midi.model.MessageList
		* @see #activeMsgList()
		*/
		public function erase( list:MessageList ):void{
			var after:Array = new Array();
			for each( var item:MessageItem in list ){
				if( item.mark ){
					
					//new item
					item.mark = false;
					after.push(item);
				}
			}
			execute(after);
		}
		
	
		/**
		* Notifies views and puts change status in undoredo stack
		* @param	after array carries marked items after operation.
		* @see #undo()
		* @see #redo()
		*/
		private function execute( after:Array ):void{
			
			//send events and update views
			update( after );
			
			//push the array of current changed-session on the top of undo stack
			_stack.insertAfter( _itr , after );
			_itr.forth();
			
			//cut the stack at current point, next states are abondoned
			_stack.tail = _itr.node;
			_stack.tail.next = null;
			
			//iterator points the tail. acts like a stack
			_itr.end();
		
			//stack is full, shift the bottom
			if( _stack.size >_history+1 ){
				_stack.head.next.unlink();
			}
		}

		/**
		* Undo last operation.
		* @see #redo()
		*/
		public function undo():void{
			if( _itr.node != _stack.head ){
				//switch state of cached session **
				for each( var item:MessageItem in _itr.data ){
					item.mark = !item.mark;
				}
				//update the views to redraw
				update( _itr.data );
				//move iterator back
				_itr.back();
			}
		}
		
		/**
		* Redo last undo-ed operation.
		* @see #undo()
		*/
		public function redo():void{
			if( _itr.node!= _stack.tail ){
				//move iterator forth
				_itr.forth();
				//switch state of cached session **
				for each( var item:MessageItem in _itr.data ){
					item.mark = !item.mark;
				}
				//update the views to redraw
				update(_itr.data );
			}
		}
		
		/**
		* Dispatches update event to views
		* @param	arr Marks of items in arr will be utilized to redraw views.
		* @see #execute()
		* @see ocean.midi.model.MessageItem#mark
		*/
		private function update( arr:Array ):void{
			pending = arr;
			dispatchEvent( new MvcEvent( MvcEvent.UPDATE_VIEW ) );
			//when views receive "update views" event,
			//edit activeMsgList with 'pending' items
			//redraw pending items upon the 'mark' properties of the items in them
		}

	}
	
}
