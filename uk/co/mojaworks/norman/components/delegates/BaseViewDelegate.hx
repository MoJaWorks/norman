package uk.co.mojaworks.norman.components.delegates;

import uk.co.mojaworks.norman.components.Component;
import uk.co.mojaworks.norman.factory.GameObject;

/**
 * ...
 * @author Simon
 */
class BaseViewDelegate extends Component
{
	
	// Active controls animations and if the screen should be "alive"
	public var active( default, set ) : Bool = false;
	
	// Enabled sets whether buttons should be accessible etc
	public var enabled( default, set ) : Bool = false;
	
	public function new( ) 
	{
		super();
		
	}
	
	public function set_active( bool : Bool ) : Bool {
		return this.active = bool;
	}
	
	public function set_enabled( bool : Bool ) : Bool {
		return this.enabled = bool;
	}
	
	public function show() : Void {
		enabled = true;
		active = true;
	}
	
	public function hideAndDestroy() : Void {
		enabled = false;
		active = false;
	}
	
	public function resize() : Void {}
	public function update( seconds : Float ) : Void {}
	
	
}