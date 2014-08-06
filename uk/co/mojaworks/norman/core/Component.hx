package uk.co.mojaworks.norman.core;
import haxe.ds.StringMap;
import uk.co.mojaworks.norman.components.Tick;

/**
 * ...
 * @author Simon
 */
#if !macro @:autoBuild( uk.co.mojaworks.norman.core.ComponentBuilder.build() ) #end
class Component extends CoreObject
{
	
	public var gameObject : GameObject;
	
	public var enabled : Bool = true;
	var autoUpdate : Bool = false;
	
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
		if ( autoUpdate ) core.root.get(Tick).addTarget( this );
	}
	
	public function onRemoved( ) : Void {
		if ( autoUpdate ) core.root.get(Tick).removeTarget( this );
	}
		
	public function destroy() : Void {
	}
		
}