package uk.co.mojaworks.norman.systems.input;
import haxe.Timer;
import lime.math.Vector2;
import msignal.Signal.Signal1;
import uk.co.mojaworks.norman.hardware.Accelerometer;

/**
 * ...
 * @author Simon
 */

@:enum abstract MouseButton(Int) from Int to Int {
	var None = -1;
	var Left = 0;
	var Middle = 1;
	var Right = 2;
}
 
class InputSystem
{

	var accelerometer : Accelerometer;
	
	public var accelerationX : Float;
	public var accelerationY : Float;
	public var accelerationZ : Float;
	
	public var mouseIsDown : Array<Bool>;
	public var mouseWasDownLastFrame : Array<Bool>;
	public var mousePosition : Vector2;
	
	public var mouseDown : Signal1<MouseButton>;
	public var mouseUp : Signal1<MouseButton>;
	
	public function new() 
	{
		if ( Accelerometer.isSupported() ) {
			
			trace("Accelerometer supported. Connecting...");
						
			accelerometer = new Accelerometer();
			accelerometer.init();
			accelerometer.onAccelerometerChanged.add( onAccelerometerUpdate );

		}else {
			trace("No accelerometer...");
		}
		
		mousePosition = new Vector2();
		
		// Only listen for 3 buttons
		mouseIsDown = [false, false, false];
		mouseWasDownLastFrame = [false, false, false];
		mouseDown = new Signal1<MouseButton>();
		mouseUp = new Signal1<MouseButton>();
	}
	
	public function update( seconds : Float ) : Void {
		
		for ( i in 0...3 ) {
			mouseWasDownLastFrame[i] = mouseIsDown[i];
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
	
	/**
	 * Mouse
	 */
	
	@:allow( uk.co.mojaworks.norman.NormanApp )
	private function onMouseDown( x : Float, y : Float, button : Int ) : Void {
		if ( button >= 0 && button < mouseIsDown.length ) {
			mouseIsDown[button] = true;
			mouseDown.dispatch( button );
		}
	}
	
	@:allow( uk.co.mojaworks.norman.NormanApp )
	private function onMouseUp( x : Float, y : Float, button : Int ) : Void {
		if ( button >= 0 && button < mouseIsDown.length ) {
			mouseIsDown[button] = false;
			mouseUp.dispatch( button );
		}
	}
	
	@:allow( uk.co.mojaworks.norman.NormanApp )
	private function onMouseMove( x : Float, y : Float ) : Void {
		mousePosition.setTo( x, y );
	}
	
}