package uk.co.mojaworks.norman.systems.input;
import haxe.Timer;
import lime.math.Vector2;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import msignal.Signal;
import msignal.Signal.Signal1;
import uk.co.mojaworks.norman.components.delegates.BaseKeyboardDelegate;
import uk.co.mojaworks.norman.hardware.Accelerometer;
import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * ...
 * @author Simon
 */


 
class InputSystem
{

	
	var _accelerometer : Accelerometer;
	
	
	public var accelerationX : Float;
	public var accelerationY : Float;
	public var accelerationZ : Float;
	
	
	
	
	
	public function new() 
	{
		if ( Accelerometer.isSupported() ) {
			
			trace("Accelerometer supported. Connecting...");
						
			_accelerometer = new Accelerometer();
			_accelerometer.init();
			_accelerometer.onAccelerometerChanged.add( onAccelerometerUpdate );

		}else {
			trace("No accelerometer...");
		}
		
		
		
		
		
		
	}
	
	/**
	 * Accelerometer
	 */
	
	private function onAccelerometerUpdate( e : Array<Float> ) : Void 
	{
		accelerationX = e[0];
		accelerationY = e[1];
		accelerationZ = e[2];
	}
	
	
	
	
	
	
}