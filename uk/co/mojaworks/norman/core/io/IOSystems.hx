package uk.co.mojaworks.norman.core.io;
import uk.co.mojaworks.norman.core.io.pointer.PointerInput;

/**
 * ...
 * @author Simon
 */
class IOSystems
{

	public var accelerometer : AccelerometerInput;
	public var keyboard : KeyboardInput;
	public var pointer : PointerInput;
	public var vibration : Vibration;
	
	public function new() 
	{
		accelerometer = new AccelerometerInput();
		keyboard = new KeyboardInput();
		pointer = new PointerInput();
		vibration = new Vibration();
	}
	
}