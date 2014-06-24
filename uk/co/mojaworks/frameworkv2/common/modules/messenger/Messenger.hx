package uk.co.mojaworks.frameworkv2.common.modules.messenger ;
import uk.co.mojaworks.frameworkv2.common.modules.messenger.IScript;
import uk.co.mojaworks.frameworkv2.core.Component;

/**
 * ...
 * @author Simon
 */
class Messenger extends Component
{

	var _listeners : Map<String, Array<Class<IScript>>>;
	
	public function new() 
	{
		super();
		_listeners = new Map<String, Array<Class<IScript>>>();
	}
	
	public function sendMessage( message : String, ?data : Dynamic = null ) : Void {
		
		trace("Sending", message );
		
		if ( _listeners.get(message) != null ) {
			for ( listener in _listeners.get(message) ) {
				var l : IScript = Type.createInstance( listener, [] );
				l.execute( data );
			}
		}
	}
	
	public function attachScript( message : String, script : Class<IScript> ) : Void {
		if ( _listeners.get(message) == null ) _listeners.set( message, [] );
		_listeners.get( message ).push( script );
	}
	
	public function removeScript( message : String, ?script : Class<IScript> = null ) : Void {
		if ( _listeners.get(message) != null ) {
			
			if ( script != null ) {
				_listeners.get(message).remove( script );
			}else {
				 //Clear all listeners for this message
				_listeners.set(message, []);
			}
			
		}
	}
	
}