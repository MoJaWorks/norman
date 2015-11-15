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

@:enum abstract MouseButton(Int) from Int to Int {
	var None = -1;
	var Left = 0;
	var Middle = 1;
	var Right = 2;
}
 
class InputSystem
{

	var _keybaordDelegates : LinkedList<BaseKeyboardDelegate>;
	var _accelerometer : Accelerometer;
	var _scrollDelta : Vector2;
	
	public var accelerationX : Float;
	public var accelerationY : Float;
	public var accelerationZ : Float;
	
	public var mouseIsDown : Array<Bool>;
	public var mouseWasDownLastFrame : Array<Bool>;
	public var mousePosition : Vector2;
	
	public var mouseScroll : Signal1<Vector2>;
	public var mouseDown : Signal1<MouseButton>;
	public var mouseUp : Signal1<MouseButton>;
	
	public var keyState : Map<KeyCode,Bool>;
	public var keyUp : Signal2<KeyCode, KeyModifier>;
	public var keyDown : Signal2<Int, KeyModifier>;
	public var textEntered : Signal1<String>;
	public var textEditing : Signal1<String>;
	
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
		
		mousePosition = new Vector2();
		
		// Only listen for 3 buttons
		mouseIsDown = [false, false, false];
		mouseWasDownLastFrame = [false, false, false];
		mouseDown = new Signal1<MouseButton>();
		mouseUp = new Signal1<MouseButton>();
		mouseScroll = new Signal1<Vector2>();
		_scrollDelta = new Vector2();
		
		_keybaordDelegates = new LinkedList<BaseKeyboardDelegate>( );
		this.keyState = new Map<Int,Bool>();
		keyUp = new Signal2<KeyCode, KeyModifier>();
		keyDown = new Signal2<KeyCode, KeyModifier>();
		textEntered = new Signal1<String>();
		textEditing = new Signal1<String>();
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
	
	@:allow( uk.co.mojaworks.norman.NormanApp )
	private function onMouseScroll( deltaX : Float, deltaY : Float ) : Void {
		_scrollDelta.setTo( deltaX, deltaY );
		mouseScroll.dispatch( _scrollDelta );
	}
	
	
	/**
	 * Keybaord
	 */
	
	public function addKeyboardDelegate( kb : BaseKeyboardDelegate ) : Void 
	{
		_keybaordDelegates.push( kb );
	}
	
	public function removeKeyboardDelegate( kb : BaseKeyboardDelegate ) : Void 
	{
		_keybaordDelegates.remove( kb );
	}
	
	
	@:allow( uk.co.mojaworks.norman.NormanApp )
	private function onKeyUp( key : KeyCode, modifier : KeyModifier ) : Void {
		keyState.set( key, true );
		keyUp.dispatch( key, modifier );
		for ( kb in _keybaordDelegates ) kb.onKeyUp( key, modifier );
	}
	
	@:allow( uk.co.mojaworks.norman.NormanApp )
	private function onKeyDown( key : KeyCode, modifier : KeyModifier ) : Void {
		keyState.set( key, false );
		keyDown.dispatch( key, modifier );
		for ( kb in _keybaordDelegates ) kb.onKeyDown( key, modifier );
	}
	
	@:allow( uk.co.mojaworks.norman.NormanApp )
	private function onTextEntry( str : String ) : Void {
		textEntered.dispatch( str );
		for ( kb in _keybaordDelegates ) kb.onTextEntry( str );
	}
	
	@:allow( uk.co.mojaworks.norman.NormanApp )
	private function onTextEdit( str : String ) : Void {
		textEditing.dispatch( str );
		for ( kb in _keybaordDelegates ) kb.onTextEdit( str );
	}
	
}