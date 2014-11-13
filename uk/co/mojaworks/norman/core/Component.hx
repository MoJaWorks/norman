package uk.co.mojaworks.norman.core;
import uk.co.mojaworks.norman.core.Messenger.MessageCallback;
import uk.co.mojaworks.norman.core.view.GameObject;
import uk.co.mojaworks.norman.core.view.GameObject;

/**
 * ...
 * @author Simon
 */
#if !macro @:autoBuild( uk.co.mojaworks.norman.core.ComponentBuilder.build() ) #end
class Component extends CoreObject
{
	
	public var gameObject : GameObject;
	public var enabled : Bool = true;
	public var destroyed : Bool = true;
	
	private function new( ) 
	{
		super();
	}
	
	/**
	 * Messaging
	 */
	
	public function sendLocalMessage( message : String, data : Dynamic = null ) : Void {
		gameObject.messenger.sendMessage( message, data );
	}
	
	public function addLocalMessageListener( message : String, callback : MessageCallback ) : Void {
		gameObject.messenger.addMessageListener( message, callback );
	}
	
	public function removeLocalMessageListener( message : String, ?callback : MessageCallback = null ) : Void {
		gameObject.messenger.removeMessageListener( message, callback );
	}

	/**
	 * 
	 */
	
	public function getComponentType() : String {
		return "";
	}
	
	public function onUpdate( seconds : Float ) : Void {
	}
	
	public function onAdded( ) : Void {
	}
	
	public function onRemoved( ) : Void {
	}
		
	public function destroy() : Void {
		gameObject = null;
		enabled = false;
		destroyed = true;
	}
		
}