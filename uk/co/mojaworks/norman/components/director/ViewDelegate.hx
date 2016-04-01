package uk.co.mojaworks.norman.components.director;

import uk.co.mojaworks.norman.components.Component;
import uk.co.mojaworks.norman.factory.GameObject;

/**
 * ...
 * @author Simon
 */
class ViewDelegate extends Component implements IViewDelegate
{
	
	// Active controls animations and if the screen should be "alive"
	public var active( default, set ) : Bool = false;
		
	public function new( ) 
	{
		super();
	}
	
	public function build() : Void
	{
		
	}
	
	public function set_active( bool : Bool ) : Bool {
		return this.active = bool;
	}
		
	public function show() : Void {
		enabled = true;
		active = true;
	}
	
	public function hideAndDestroy() : Void {
		gameObject.destroy();
	}
	
	public function resize() : Void {}
	public function update( seconds : Float ) : Void {}
	
	
}