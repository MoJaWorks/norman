package uk.co.mojaworks.norman.components;

import uk.co.mojaworks.norman.core.Component;

/**
 * ...
 * @author Simon
 */
class Prefab extends Component
{

	public function new() 
	{
		super();
		
	}
	
	override public function onAdded():Void 
	{
		super.onAdded();
		construct();
	}
	
	private function construct() : Void {
		// Build an entity
	}
	
}