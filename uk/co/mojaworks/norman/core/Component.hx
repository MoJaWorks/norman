package uk.co.mojaworks.norman.core;

/**
 * ...
 * @author Simon
 */
#if !macro @:autoBuild( uk.co.mojaworks.norman.core.ComponentBuilder.build() ) #end
class Component extends RootObject
{
	
	public var gameObject : GameObject;
	public var enabled : Bool = true;
	public var destroyed : Bool = true;
	
	private function new() 
	{
		super();
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