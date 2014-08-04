package uk.co.mojaworks.norman.components.messenger;
import uk.co.mojaworks.norman.core.GameObject;

/**
 * ...
 * @author Simon
 */
class MessageData
{

	public var target : GameObject;
	public var message : String;
	public var data : Dynamic;
	
	public function new( target : GameObject, message : String, data : Dynamic = null ) 
	{
		this.target = target;
		this.message = message;
		this.data = data;
	}
	
}