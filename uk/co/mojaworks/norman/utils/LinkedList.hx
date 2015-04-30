package uk.co.mojaworks.norman.utils;

/**
 * ...
 * @author Simon
 */

class LinkedListIterator<T> {
	
	var list : LinkedList<T>;
	var current : LinkedListItem<T>;
	
	public function new( list : LinkedList<T> ) {
		this.list = list;
		current = list.first;
	}
	
	public function hasNext() : Bool {
		return current != null;
	}
	
	public function next() : T {
		var item : T = current.item;
		current = current.next;
		return item;
	}
	
}

class LinkedListItem<T> {
	public var next : LinkedListItem<T> = null;
	public var prev : LinkedListItem<T> = null;
	public var item : T;
	
	public function new ( item : T ) {
		this.item = item;
	}
	
	public function destroy() : Void {
		next = null;
		prev = null;
		item = null;
	}
}
 
class LinkedList<T>
{
	
	public var length( default, null ) : Int = 0;
	public var first( default, null ) : LinkedListItem<T>;
	public var last( default, null ) : LinkedListItem<T>;

	public function new() 
	{
	}
	
	public function iterator() : LinkedListIterator<T> {
		return new LinkedListIterator<T>( this );
	}
	
	public function push( item : T ) : Void {
		var link : LinkedListItem<T> = new LinkedListItem<T>( item );
		
		if ( length == 0 ) {
			first = link;
		}else {
			last.next = link;
			link.prev = last;
		}
		
		last = link;
		length++;
	}
	
	public function pop() : T {
		
		if ( length > 0 ) {
			var item : T = last.item;
			
			if ( last.prev != null ) {
				last = last.prev;
			}else {
				last = null;
				first = null;
			}
			
			length--;
			return item;
		}
		
		return null;
	}
	
	public function contains( item : T ) : Bool {
		
		var current : LinkedListItem<T> = first;
		
		while ( current != null ) {
			if ( current.item == item ) {
				return true;
			}
			current = current.next;
		}
		
		return false;
		
	}
	
	public function indexOf( item : T ) : Int {
		
		var i : Int = 0;
		var current : LinkedListItem<T> = first;
		
		while ( current != null ) {
			if ( current.item == item ) {
				return i;
			}
			current = current.next;
			++i;
		}
		
		return -1;
		
	}
	
	public function swap( item1 : T, item2 : T ) : Bool {
		
		var current : LinkedListItem<T> = first;
		var target1 : LinkedListItem<T> = null;
		var target2 : LinkedListItem<T> = null;
		
		while ( current != null && ( target1 == null || target2 == null ) ) {
			if ( target1 == null && current.item == item1 ) target1 = current;
			else if ( target2 == null && current.item == item2 ) target2 = current;
			current = current.next;
		}
		
		if ( target1 != null && target2 != null ) {
			
			if ( first == target1 ) first == target2;
			else if ( first == target2 ) first == target1;
			
			if ( last == target1 ) last == target2;
			else if ( last == target2 ) last = target1;
			
			var t1Prev : LinkedListItem<T> = target1.prev;
			var t1Next : LinkedListItem<T> = target1.next;
			
			target1.next = target2.next;
			target1.prev = target2.prev;
			
			target2.next = t1Next;
			target2.prev = t1Prev;
			
			return true;
		}
		
		return false;
		
	}
	
	/**
	 * Returns true if the item was found and removed
	 * @param	item
	 * @return
	 */
	
	public function remove( item : T ) : Bool {
		
		var current : LinkedListItem<T> = first;
		
		while ( current != null ) {
			if ( current.item == item ) {
				removeItem( current );
				return true;
			}
			current = current.next;
		}
		
		return false;
		
	}
	
	public function clear() 
	{
		var current : LinkedListItem<T> = first;
		var next : LinkedListItem<T>;
		
		while ( current != null ) {
			
			// Only destroys references to actual items, not the items themselves
			next = current.next;
			current.destroy();
			current = next;
			
		}
		
		first = null;
		last = null;
		length = 0;
	}
	
	/**
	 * Working with LinkedListItems
	 * @param	item
	 */
	
	private function removeItem( item : LinkedListItem<T> ) : Void {
		
		if ( item.prev != null ) {
			item.prev.next = item.next;
		}
		if ( item.next != null ) {
			item.next.prev = item.prev;
		}
		if ( item == first ) {
			first = item.next;
		}
		if ( item == last ) {
			last = item.prev;
		}
		item.destroy();
		item = null;
		length--;
	}
	
	private function insertAfterItem( item : T, after : LinkedListItem<T> ) : Void {
		
		var link : LinkedListItem<T> = new LinkedListItem<T>(item);
		
		link.prev = after;
		link.next = after.next;
		
		link.next.prev = link;
		link.prev.next = link;
		
		if ( after == last ) last = link;
		
		length++;
		
	}
	
	private function insertBeforeItem( item : T, before : LinkedListItem<T> ) : Void {
		
		var link : LinkedListItem<T> = new LinkedListItem<T>(item);
		
		link.next = before;
		link.prev = before.prev;
		
		link.next.prev = link;
		link.prev.next = link;
		
		if ( before == first ) first = link;
		
		length++;
		
	}
	
	public function get( key:Int ) : T {
		
		var i : Int = 0;
		var val : LinkedListItem<T> = first;
		
		while ( i < key ) {
			if ( val == null ) return null;
			val = val.next;
		}
		
		return val.item;
	}
	
}