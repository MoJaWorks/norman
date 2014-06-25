package uk.co.mojaworks.frameworkv2.core;

/**
 * ...
 * @author Simon
 */
#if !macro @:autoBuild( uk.co.mojaworks.frameworkv2.core.ComponentBuilder.build() ) #end
class Component extends CoreObject
{
	
	public var gameObject : GameObject;
	
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
		
	}
	
}