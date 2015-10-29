package uk.co.mojaworks.norman.components ;
import uk.co.mojaworks.norman.factory.GameObject;
import uk.co.mojaworks.norman.factory.IDisposable;

/**
 * ...
 * @author Simon
 */
	
 #if !macro @:autoBuild( uk.co.mojaworks.norman.components.ComponentBuilder.build() ) #end
 class Component implements IDisposable {
	 
	public var enabled( default, set ) : Bool = true;
	public var gameObject : GameObject;
	public var destroyed : Bool = false;
	
	public function new( ) {
		
	}
	
	public function destroy() : Void {
		destroyed = true;
		if ( gameObject != null ) gameObject.removeComponent( this );
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
	
	public function isEnabled() : Bool {
		if ( gameObject != null ) {
			return gameObject.isEnabled();
		}else {
			return enabled;
		}
	}
	
	public function set_enabled( bool : Bool ) : Bool {
		return this.enabled = bool;
	}
}