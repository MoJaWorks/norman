package uk.co.mojaworks.norman.core;
import uk.co.mojaworks.norman.core.view.GameObject;

/**
 * ...
 * @author Simon
 */

class MessageData {
	
	public var target : GameObject;
	public var message : String;
	public var data : Dynamic;
	
	public function new ( target : GameObject, message : String, data : Dynamic ) {
		this.target = target;
		this.message = message;
		this.data = data;
	}
}

/**
 * 
 */
 
typedef MessageCallback = MessageData->Void;
 
/**
 * 
 */

class Messenger extends Component
{

	var _listeners:Map<String, Array<MessageCallback>>;
	
	public function new() 
	{
		super();
		_listeners = new Map<String, Array<MessageCallback>>();
	}
	
	override public function sendMessage( message : String, ?data : Dynamic = null ) : Void {

		//trace("Sending", message );
		if ( _listeners.get( message ) != null ) {
			for ( listener in _listeners.get( message ) ) {
				listener( new MessageData( gameObject, message, data ) );
			}
		}
		
	}
	
	override public function addMessageListener( message : String, callback : MessageCallback ) : Void {
		if ( _listeners.get(message) == null ) _listeners.set( message, [] );
		if ( _listeners.get(message).indexOf( callback ) == -1 ) {
			_listeners.get(message).push( callback );
		}
	}
	
	override public function removeMessageListener( message : String, ?callback : MessageCallback = null ) : Void {
		if ( _listeners.get(message) != null ) {
			if ( callback != null ) {
				_listeners.get(message).remove( callback );
			}else {
				 //Clear all listeners for this message
				_listeners.set(message, []);
			}
		}
	}
	
	override public function destroy() : Void {
		super.destroy();
		_listeners = null;
	}
	
}