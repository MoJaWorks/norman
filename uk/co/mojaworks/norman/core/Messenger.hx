package uk.co.mojaworks.norman.core;

/**
 * ...
 * @author Simon
 */

typedef MessageCallback = Dynamic->Void;
 
class Messenger
{

	var _listeners:Map<String, Array<MessageCallback>>;
	
	public function new() 
	{
		_listeners = new Map<String, Array<MessageCallback>>();
	}
	
	public function sendMessage( message : String, ?data : Dynamic = null ) : Void {

		//trace("Sending", message );
		if ( _listeners.get( message ) != null ) {
			for ( listener in _listeners.get( message ) ) {
				listener( data );
			}
		}
		
	}
	
	public function addMessageListener( message : String, callback : MessageCallback ) : Void {
		if ( _listeners.get(message) == null ) _listeners.set( message, [] );
		if ( _listeners.get(message).indexOf( callback ) == -1 ) {
			_listeners.get(message).push( callback );
		}
	}
	
	public function removeMessageListener( message : String, ?callback : MessageCallback = null ) : Void {
		if ( _listeners.get(message) != null ) {
			if ( callback != null ) {
				_listeners.get(message).remove( callback );
			}else {
				 //Clear all listeners for this message
				_listeners.set(message, []);
			}
		}
	}
	
	public function destroy() : Void {
		_listeners = null;
	}
	
}