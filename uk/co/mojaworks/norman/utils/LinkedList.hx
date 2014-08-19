package uk.co.mojaworks.norman.utils;
import uk.co.mojaworks.norman.utils.LinkedList.LinkedListItem;

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
	
	public function remove( item : T ) : Void {
		
		var looking : Bool = true;
		var current : LinkedListItem<T> = first;
		
		while ( current != null ) {
			if ( current.item == item ) {
				removeItem( current );
				//if ( current.prev != null ) {
					//current.prev.next = current.next;
				//}
				//if ( current.next != null ) {
					//current.next.prev = current.prev;
				//}
				//if ( current == first ) {
					//first = current.next;
				//}
				//if ( current == last ) {
					//last = current.prev;
				//}
				//current.destroy();
				//current = null;
				//length--;
			}else {
				current = current.next;
			}
		}
		
	}
	
	public function removeItem( item : LinkedListItem<T> ) : Void {
		
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
	
	public function insertAfterItem( item : T, after : LinkedListItem<T> ) : Void {
		
		var link : LinkedListItem<T> = new LinkedListItem<T>(item);
		
		link.prev = after;
		link.next = after.next;
		
		link.next.prev = link;
		link.prev.next = link;
		
		if ( after == last ) last = link;
		
		length++;
		
	}
	
	public function insertBeforeItem( item : T, before : LinkedListItem<T> ) : Void {
		
		var link : LinkedListItem<T> = new LinkedListItem<T>(item);
		
		link.next = before;
		link.prev = before.prev;
		
		link.next.prev = link;
		link.prev.next = link;
		
		if ( before == first ) first = link;
		
		length++;
		
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
	
}