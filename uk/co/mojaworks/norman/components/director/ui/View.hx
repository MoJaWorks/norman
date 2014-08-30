package uk.co.mojaworks.norman.components.director.ui ;

import uk.co.mojaworks.norman.core.Component;

/**
 * Used to add screens/panels to the director
 * Extend this class to specify functionality for each screen
 * ...
 * @author Simon
 */
class View extends Component
{

	public var active : Bool = false;
	
	public function new() 
	{
		super();
	}
	
	public function onShow() : Void {
	}
	
	public function onActivate() : Void {
	}
	
	public function onDeactivate() : Void {		
	}
	
	public function resize() : Void {
	}
	
}