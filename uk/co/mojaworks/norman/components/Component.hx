package uk.co.mojaworks.norman.components ;
import uk.co.mojaworks.norman.factory.GameObject;

/**
 * ...
 * @author Simon
 */
	
 #if !macro @:autoBuild( uk.co.mojaworks.norman.components.ComponentBuilder.build() ) #end
 class Component {
	 
	public var gameObject : GameObject;
	
	public function new( ) {
		
	}
	
	public function destroy() : Void {
	}
	
	public function onAdded() : Void {
		
	}
	
	public function onRemove() : Void {
	}
	
	public function getComponentType() : String {
		return "Component";
	}
	
	public function getBaseComponentType() : String {
		return "Component";
	}
}