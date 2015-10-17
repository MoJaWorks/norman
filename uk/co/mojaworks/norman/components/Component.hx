package uk.co.mojaworks.norman.components ;
import uk.co.mojaworks.norman.factory.GameObject;

/**
 * ...
 * @author Simon
 */
	
 class Component {
	 
	// Is a basic data element
	public var gameObject : GameObject;
	public var type : String;
	public var baseType : String;
	
	public function new( type : String, ?baseType : String = null ) {
		this.type = type;
		
		if ( baseType == null ) {
			this.baseType = type;
		}else {
			this.baseType = baseType;
		}
	}
	
	public function destroy() : Void {
	}
	
	public function onAdded() : Void {
		
	}
	
	public function onRemove() : Void {
		
	}
}