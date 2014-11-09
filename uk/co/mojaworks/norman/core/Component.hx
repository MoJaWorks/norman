package uk.co.mojaworks.norman.core;
import uk.co.mojaworks.norman.core.view.GameObject;

/**
 * ...
 * @author Simon
 */
#if !macro @:autoBuild( uk.co.mojaworks.norman.core.ComponentBuilder.build() ) #end
class Component
{
	
	public var gameObject : GameObject;
	public var enabled : Bool = true;
	public var destroyed : Bool = true;
	
	private function new() 
	{
	}

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