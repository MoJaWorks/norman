package uk.co.mojaworks.norman.components ;
import uk.co.mojaworks.norman.factory.GameObject;
import uk.co.mojaworks.norman.factory.IDisposable;

/**
 * ...
 * @author Simon
 */
	
 #if !macro @:autoBuild( uk.co.mojaworks.norman.components.ComponentBuilder.build() ) #end
 class Component implements IDisposable {
	 
	public var gameObject : GameObject;
	public var destroyed : Bool = false;
	
	public function new( ) {
		
	}
	
	public function destroy() : Void {
		destroyed = true;
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