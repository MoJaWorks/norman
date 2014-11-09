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
		core.messenger.sendMessage( message, data );
	}
	
	private function addMessageListener( message : String, callback : MessageCallback ) {
		core.messenger.addMessageListener( message, callback ); 
	}
	
	private function getView( id : String ) {
		return core.view.getView( id );
	}
	
	private function getModel( id : String ) {
		return core.model.getModel( id );
	}
	
	
	
}