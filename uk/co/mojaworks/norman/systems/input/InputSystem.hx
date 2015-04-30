package uk.co.mojaworks.norman.systems.input;
import openfl.events.AccelerometerEvent;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.Lib;
import openfl.sensors.Accelerometer;

/**
 * ...
 * @author Simon
 */
class InputSystem
{

	var accelerometer : Accelerometer;
	
	public var accelerationX : Float;
	public var accelerationY : Float;
	public var accelerationZ : Float;
	
	public var mouseIsDown : Bool;
	public var mousePosition : Point;
	
	public function new() 
	{
		if ( Accelerometer.isSupported ) {
			accelerometer = new Accelerometer();
			accelerometer.addEventListener( AccelerometerEvent.UPDATE, onAccelerometerUpdate );
		}else {
			trace("No accelerometer...");
		}
		
		mousePosition = new Point();
		Lib.current.stage.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
		Lib.current.stage.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
		Lib.current.stage.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
	}
	
	/**
	 * Accelerometer
	 */
	
	private function onAccelerometerUpdate( e : AccelerometerEvent ) : Void 
	{
		accelerationX = e.accelerationX;
		accelerationY = e.accelerationY;
		accelerationZ = e.accelerationZ;
		
		trace( "Acceleration updated", accelerationX, accelerationY, accelerationZ );
	}
	
	/**
	 * Mouse
	 */
	
	private function onMouseDown( e : MouseEvent ) : Void {
		mouseIsDown = true;
	}
	
	private function onMouseUp( e : MouseEvent ) : Void {
		mouseIsDown = false;
	}
	
	private function onMouseMove( e : MouseEvent ) : Void {
		mousePosition.setTo( e.stageX, e.stageY );
	}
	
}