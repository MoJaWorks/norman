package uk.co.mojaworks.norman.core.io.pointer;
import lime.math.Vector2;
import msignal.Signal.Signal2;
import uk.co.mojaworks.norman.core.io.pointer.Pointer;

/**
 * ...
 * @author Simon
 */

@:enum abstract MouseButton(Int) from Int to Int {
	var None = -1;
	var Left = 0;
	var Middle = 1;
	var Right = 2;
	var Button4 = 3;
	var Button5 = 4;
}
 
class PointerInput
{
	
	public static inline var MAX_TOUCH_POINTS : Int = 5;
	public static inline var MAX_BUTTONS : Int = 5;
	
	public var pointerScroll : Signal2<Int,Vector2>;
	public var pointerDown : Signal2<Int,MouseButton>;
	public var pointerUp : Signal2<Int,MouseButton>;
	
	var _scrollDelta : Vector2;
	var _pointers : Array<Pointer>;
	
	public function new() 
	{
		_pointers = [];
		for ( i in 0...MAX_TOUCH_POINTS ) 
		{
			_pointers.push( new Pointer( i ) );
		}
		
		pointerDown = new Signal2<Int,MouseButton>();
		pointerUp = new Signal2<Int,MouseButton>();
		pointerScroll = new Signal2<Int,Vector2>();
	}
	
	public function get( id : Int ) : Pointer
	{
		if ( id >= 0 && id < PointerInput.MAX_TOUCH_POINTS ) {
			return _pointers[id];
		}
		
		return null;
	}
	
	/**
	 * Get mouse input from system events
	 */
	
	@:allow( uk.co.mojaworks.norman.NormanApp )
	private function onMouseDown( x : Float, y : Float, button : Int ) : Void {
		if ( button >= 0 && button < MAX_BUTTONS ) {
			_pointers[0].updateButtonState( button, true );
			pointerDown.dispatch( 0, button );
		}
	}
	
	@:allow( uk.co.mojaworks.norman.NormanApp )
	private function onMouseUp( x : Float, y : Float, button : Int ) : Void {
		if ( button >= 0 && button < MAX_BUTTONS ) {
			_pointers[0].updateButtonState( button, false );
			pointerUp.dispatch( 0, button );
		}
	}
	
	@:allow( uk.co.mojaworks.norman.NormanApp )
	private function onMouseMove( x : Float, y : Float ) : Void {
		_pointers[0].position.setTo( x, y );
	}
	
	@:allow( uk.co.mojaworks.norman.NormanApp )
	private function onMouseScroll( deltaX : Float, deltaY : Float ) : Void {
		_scrollDelta.setTo( deltaX, deltaY );
		pointerScroll.dispatch( 0, _scrollDelta );
	}
	
	@:allow( uk.co.mojaworks.norman.NormanApp )
	private function endFrame( ) : Void {
		for ( pointer in _pointers ) 
		{
			pointer.endFrame();
		}
	}
	
}