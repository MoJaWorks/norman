package uk.co.mojaworks.frameworkv2.components.director ;

import uk.co.mojaworks.frameworkv2.core.Component;

/**
 * Used to add screens/panels to the director
 * Extend this class to specify functionality for each screen
 * ...
 * @author Simon
 */
class View extends Component
{

	public function new() 
	{
		super();
		
	}
	
	public function onShow() : Void {
		
	}
	
	public function onHide() : Float {
		return 0;
	}
	
	public function onActivate() : Void {
		
	}
	
	public function onDeactivate() : Void {
		
	}
	
	public function resize() : Void {
		
	}
	
}