package uk.co.mojaworks.norman.core;
import uk.co.mojaworks.norman.core.Messenger.MessageCallback;

/**
 * ...
 * @author Simon
 */
class CoreObject
{

	private var core( get, never ) : Core;
	
	private function new() 
	{
		// Abstract class
	}
	
	#if !display
	private function get_core() : Core {
		return Core.getInstance();
	}
	#end
	
	private function sendMessage( message : String, data : Dynamic = null ) {
		core.sendMessage( message, data );
	}
	
	private function addMessageListener( message : String, callback : MessageCallback ) {
		core.addMessageListener( message, callback ); 
	}
	
	private function removeMessageListener( message : String, ?callback : MessageCallback = null ) {
		core.removeMessageListener( message, callback ); 
	}
	
	private function getObject( id : String ) {
		return core.view.getObject( id );
	}
	
	private function getProxy( id : String ) {
		return core.model.getProxy( id );
	}
	
	
	
}