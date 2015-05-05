package uk.co.mojaworks.norman.systems.input;
import lime.math.Vector2;

/**
 * ...
 * @author Simon
 */
class InputSystem
{

	//var accelerometer : Accelerometer;
	
	public var accelerationX : Float;
	public var accelerationY : Float;
	public var accelerationZ : Float;
	
	public var mouseIsDown : Bool;
	public var mousePosition : Vector2;
	
	public function new() 
	{
		//if ( Accelerometer.isSupported ) {
			//accelerometer = new Accelerometer();
			//accelerometer.addEventListener( AccelerometerEvent.UPDATE, onAccelerometerUpdate );
		//}else {
			//trace("No accelerometer...");
		//}
		
		mousePosition = new Vector2();
		//Lib.current.stage.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
		//Lib.current.stage.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
		//Lib.current.stage.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
	}
	
	/**
	 * Accelerometer
	 */
	
	//private function onAccelerometerUpdate( e : AccelerometerEvent ) : Void 
	//{
		//accelerationX = e.accelerationX;
		//accelerationY = e.accelerationY;
		//accelerationZ = e.accelerationZ;
		//
		//trace( "Acceleration updated", accelerationX, accelerationY, accelerationZ );
	//}
	
	/**
	 * Mouse
	 */
	
	@:allow( uk.co.mojaworks.norman.NormanApp )
	private function onMouseDown( x : Float, y : Float ) : Void {
		mouseIsDown = true;
	}
	
	@:allow( uk.co.mojaworks.norman.NormanApp )
	private function onMouseUp( x : Float, y : Float ) : Void {
		mouseIsDown = false;
	}
	
	@:allow( uk.co.mojaworks.norman.NormanApp )
	private function onMouseMove( x : Float, y : Float ) : Void {
		mousePosition.setTo( x, y );
	}
	
}