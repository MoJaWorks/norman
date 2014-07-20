package uk.co.mojaworks.norman.components.messenger ;
import uk.co.mojaworks.norman.components.messenger.IScript;
import uk.co.mojaworks.norman.core.Component;
import uk.co.mojaworks.norman.core.GameObject;

/**
 * ...
 * @author Simon
 */
class Messenger extends Component
{

	var _scripts : Map<String, Array<Class<IScript>>>;
	var _listeners:Map<String, Array<GameObject->Dynamic->Void>>;
	
	public function new() 
	{
		super();
		_scripts = new Map<String, Array<Class<IScript>>>();
		_listeners = new Map<String, Array<GameObject->Dynamic->Void>>();
	}
	
	public function sendMessage( message : String, ?data : Dynamic = null ) : Void {
		
		//trace("Sending", message );
		
		if ( _listeners.get( message ) != null ) {
			for ( listener in _listeners.get( message ) ) {
				listener( gameObject, data );
			}
		}
		
		if ( _scripts.get(message) != null ) {
			for ( listener in _scripts.get(message) ) {
				var l : IScript = Type.createInstance( listener, [] );
				l.execute( gameObject, data );
			}
		}
	}
	
	public function attachScript( message : String, script : Class<IScript> ) : Void {
		if ( _scripts.get(message) == null ) _scripts.set( message, [] );
		_scripts.get( message ).push( script );
	}
	
	public function removeScript( message : String, ?script : Class<IScript> = null ) : Void {
		if ( _scripts.get(message) != null ) {
			if ( script != null ) {
				_scripts.get(message).remove( script );
			}else {
				 //Clear all listeners for this message
				_scripts.set(message, []);
			}
		}
	}
	
	public function attachListener( message : String, listener : GameObject->Dynamic->Void ) : Void {
		if ( _listeners.get(message) == null ) _listeners.set( message, [] );
		if ( _listeners.get(message).indexOf( listener ) == -1 ) {
			_listeners.get(message).push( listener );
		}
	}
	
	public function removeListener( message : String, ?listener : GameObject->Dynamic->Void = null ) : Void {
		if ( _listeners.get(message) != null ) {
			if ( listener != null ) {
				_listeners.get(message).remove( listener );
			}else {
				 //Clear all listeners for this message
				_listeners.set(message, []);
			}
		}
	}
	
}