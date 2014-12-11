package uk.co.mojaworks.norman.systems.input;

import lime.math.Vector2;
import uk.co.mojaworks.norman.core.CoreObject;

/**
 * ...
 * @author Simon
 */
class InputSystem extends CoreObject
{

	public static inline var MAX_TOUCHES : Int = 5;
	
	public var touchCount( default, null ) : Int = 0;
	var _touchRegister : Map<Int,TouchData>;
	var _keyRegister : Map<Int,Bool>;
	
	public function new() 
	{
		super();
		_keyRegister = new Map<Int,Bool>();
		_touchRegister = new Map<Int,TouchData>();
	}
		
	/**
	 * KEYBOARD
	 **/
	
	public function onKeyDown( code : Int ):Void 
	{
		_keyRegister.set( code, true );
	}
	
	public function onKeyUp( code : Int ):Void 
	{
		_keyRegister.set( code, false );
	}
	
	public function isKeyDown( code : Int ) : Bool {
		return _keyRegister.exists(code) && _keyRegister.get(code);
	}
	
	/**
	 * Pointer
	 */
		
	public function onPointerDown( x : Float, y : Float, touchId : Int = 0 ) : Void {
		var touch : TouchData = _touchRegister.get( touchId );		
		
		if ( touch == null ) {
			touch = new TouchData( touchId );
			_touchRegister.set( touchId, touch );
		}
		
		touch.isDown = true;
		touch.lastTouchStart.setTo( x, y );
		touch.position.setTo( x, y );
		
		touchCount++;
	}
	
	/**/
	
	public function onPointerUp( x : Float, y : Float, touchId : Int = 0 ) : Void {
		var touch : TouchData = _touchRegister.get( touchId );
		
		if ( touch == null ) {
			touch = new TouchData( touchId );
			_touchRegister.set( touchId, touch );
		}
		
		touch.isDown = false;
		touch.lastTouchEnd.setTo( x, y );
		touch.position.setTo( x, y );
		
		touchCount--;
	}	
	
	/**/
	
	public function onPointerMove( x : Float, y : Float, touchId : Int = 0 ) : Void {
		
		var touch : TouchData = _touchRegister.get( touchId );
		
		if ( touch == null ) {
			touch = new TouchData( touchId );
			_touchRegister.set( touchId, touch );
		}
		
		touch.position.setTo( x, y );
	}
	 	
	/**
	 * Easy access
	 */
	
	 public function getPointerInfo( id : Int = 0 ) : TouchData {
		return _touchRegister.get( id );
	}
	 
	public function isTouchDown( id : Int = 0 ) : Bool {
		return _touchRegister.get( id ).isDown;
	}
	
	public function getTouchPosition( id : Int = 0 ) : Vector2 {
		return _touchRegister.get( id ).position;
	}	 
		
	public function isAnyPointerDown() : Array<Int> {
		
		if ( touchCount == 0 ) return [];
		
		var result : Array<Int> = [];
		var touch : TouchData;
		
		for ( key in _touchRegister.keys() ) {
			touch = _touchRegister.get(key);
			if ( touch.isDown ) result.push( touch.touchId );
		}
		return result;
	}
	
}