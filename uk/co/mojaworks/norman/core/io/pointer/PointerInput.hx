package uk.co.mojaworks.norman.core.io.pointer;
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
	
	public var scroll : Signal2<Int,Vector2>;
	public var down : Signal2<Int,MouseButton>;
	public var up : Signal2<Int,MouseButton>;
	
	var _scrollDelta : Vector2;
	var _pointers : Array<Pointer>;
	
	public function new() 
	{
		_pointers = [];
		for ( i in 0...MAX_TOUCH_POINTS ) 
		{
			_pointers.push( new Pointer( i ) );
		}
		
		down = new Signal2<Int,MouseButton>();
		up = new Signal2<Int,MouseButton>();
		scroll = new Signal2<Int,Vector2>();
		
		_scrollDelta = new Vector2();
	}
	
	public function get( id : Int ) : Pointer
	{
		if ( id >= 0 && id < PointerInput.MAX_TOUCH_POINTS ) {
			return _pointers[id];
		}
		
		return null;
	}
	
	public function anyPointerIsDown() 
	{
		for ( pointer in _pointers ) 
		{
			if ( pointer.buttonIsDown( MouseButton.Left ) )
			{
				return true;
			}
		}
		
		return false;
	}
	
	/**
	 * Get mouse input from system events
	 */
	
	@:allow( uk.co.mojaworks.norman.NormanApp )
	private function onMouseDown( x : Float, y : Float, button : Int ) : Void {
		if ( button >= 0 && button < MAX_BUTTONS ) {
			_pointers[0].updateButtonState( button, true );
			down.dispatch( 0, button );
		}
	}
	
	@:allow( uk.co.mojaworks.norman.NormanApp )
	private function onMouseUp( x : Float, y : Float, button : Int ) : Void {
		if ( button >= 0 && button < MAX_BUTTONS ) {
			_pointers[0].updateButtonState( button, false );
			up.dispatch( 0, button );
		}
	}
	
	@:allow( uk.co.mojaworks.norman.NormanApp )
	private function onMouseMove( x : Float, y : Float ) : Void {
		_pointers[0].position.setTo( x, y );
	}
	
	@:allow( uk.co.mojaworks.norman.NormanApp )
	private function onMouseScroll( deltaX : Float, deltaY : Float ) : Void {
		_scrollDelta.setTo( deltaX, deltaY );
		scroll.dispatch( 0, _scrollDelta );
	}
	
	@:allow( uk.co.mojaworks.norman.NormanApp )
	private function endFrame( ) : Void {
		for ( pointer in _pointers ) 
		{
			pointer.endFrame();
		}
	}
	
}