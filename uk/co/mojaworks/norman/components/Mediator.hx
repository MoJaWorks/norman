package uk.co.mojaworks.norman.components;

import uk.co.mojaworks.norman.core.Component;

/**
 * ...
 * @author Simon
 */
class Mediator extends Component
{

	var _constructed : Bool = false;
	
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
		// Override to construct
		_constructed = true;
	}
	
}