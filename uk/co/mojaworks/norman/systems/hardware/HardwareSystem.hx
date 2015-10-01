package uk.co.mojaworks.norman.systems.hardware;
import uk.co.mojaworks.norman.hardware.Vibration;

/**
 * ...
 * @author Simon
 */
class HardwareSystem
{

	public var vibration( default, null ) : Vibration;
	
	public function new() 
	{
		vibration = new Vibration();
	}
	
}