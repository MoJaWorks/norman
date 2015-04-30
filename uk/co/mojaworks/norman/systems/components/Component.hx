package uk.co.mojaworks.norman.systems.components ;

/**
 * ...
 * @author Simon
 */
class Component {
	
	// Is a basic data element
	public var entityId : String;
	public var type : String;
	
	public function new( type : String ) {
		this.type = type;
	}
}