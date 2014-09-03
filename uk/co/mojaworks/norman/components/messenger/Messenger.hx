package uk.co.mojaworks.norman.components.messenger ;
import uk.co.mojaworks.norman.components.messenger.IScript;
import uk.co.mojaworks.norman.core.Component;

/**
 * ...
 * @author Simon
 */
class Messenger extends Component
{

	var _scripts : Map<String, Array<IScript>>;
	var _listeners:Map<String, Array<MessageData->Void>>;
	
	public function new() 
	{
		super();
		_scripts = new Map<String, Array<IScript>>();
		_listeners = new Map<String, Array<MessageData->Void>>();
	}
	
	public function sendMessage( message : String, ?data : Dynamic = null ) : Void {
		
		//trace("Sending", message );
		
		if ( _listeners.get( message ) != null ) {
			for ( listener in _listeners.get( message ) ) {
				listener( new MessageData( gameObject, message, data ) );
			}
		}
		
		if ( _scripts.get(message) != null ) {
			for ( listener in _scripts.get(message) ) {
				listener.execute( new MessageData( gameObject, message, data ) );
			}
		}
	}
	
	public function attachScript( message : String, script : Class<IScript> ) : Void {
		if ( _scripts.get(message) == null ) _scripts.set( message, [] );
		_scripts.get( message ).push( Type.createInstance(script, []) );
	}
	
	public function removeScript( message : String, ?script : Class<IScript> = null ) : Void {
		if ( _scripts.get(message) != null ) {
			if ( script != null ) {
				
				for ( s in _scripts.get( message ) ) {
					if ( Std.is( s, script ) ) _scripts.get(message).remove( s );
					return;
				}
				
			}else {
				 //Clear all listeners for this message
				_scripts.set(message, []);
			}
		}
	}
	
	public function attachListener( message : String, listener : MessageData->Void ) : Void {
		if ( _listeners.get(message) == null ) _listeners.set( message, [] );
		if ( _listeners.get(message).indexOf( listener ) == -1 ) {
			_listeners.get(message).push( listener );
		}
	}
	
	public function removeListener( message : String, ?listener : MessageData->Void = null ) : Void {
		if ( _listeners.get(message) != null ) {
			if ( listener != null ) {
				_listeners.get(message).remove( listener );
			}else {
				 //Clear all listeners for this message
				_listeners.set(message, []);
			}
		}
	}
	
	override public function destroy() : Void {
		_scripts = null;
		_listeners = null;
	}
	
}