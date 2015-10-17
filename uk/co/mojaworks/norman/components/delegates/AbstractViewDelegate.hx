package uk.co.mojaworks.norman.components.delegates;

import uk.co.mojaworks.norman.components.Component;

/**
 * ...
 * @author Simon
 */
class AbstractViewDelegate extends Component
{
	
	static public inline var TYPE:String = "AbstractViewDelegate";
	
	// Active controls animations and if the screen should be "alive"
	public var active( default, set ) : Bool = false;
	
	// Enabled sets whether buttons should be accessible etc
	public var enabled( default, set ) : Bool = false;
	
	public function new( type : String ) 
	{
		super(type, TYPE);
		
	}
	
	public function show() : Void { }
	public function hideAndDestroy : Void { }
	public function resize() : Void { }
	public function update() : Void { }
	
}