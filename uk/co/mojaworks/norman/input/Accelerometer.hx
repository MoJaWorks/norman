package uk.co.mojaworks.norman.input;
import lime.app.Event;
import lime.utils.JNI;

/**
 * ...
 * @author Simon
 */
class Accelerometer
{

	public var onAccelerometerChanged : Event<Float->Float->Float->Void>;
	
	public function new() 
	{
		onAccelerometerChanged = new Event<Float->Float->Float->Void>()
	}
	
	public function init() : Void {
		// Connect to the native accelerometer
		
		#if android
		#end
		
	}
	
	public static function isSupported() : Bool {
		#if ios || android
			return true;
		#else
			return false;
		#end
	}
	
}