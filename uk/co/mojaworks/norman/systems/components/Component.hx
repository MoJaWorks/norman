package uk.co.mojaworks.norman.systems.components ;
import uk.co.mojaworks.norman.factory.GameObject;

/**
 * ...
 * @author Simon
 */
class Component {
	
	// Is a basic data element
	public var gameObject : GameObject;
	public var type : String;
	
	public function new( type : String ) {
		this.type = type;
	}
	
	public function destroy() : Void {
	}
}