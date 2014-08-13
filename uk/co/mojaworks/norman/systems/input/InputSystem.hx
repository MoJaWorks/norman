package uk.co.mojaworks.norman.systems.input ;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.events.TouchEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.ui.Multitouch;
import openfl.ui.MultitouchInputMode;
import uk.co.mojaworks.norman.core.GameObject;

using Lambda;

/**
 * ...
 * @author Simon
 */
class InputSystem extends AppSystem
{
	
	
	
	public static inline var TAPPED : String = "TAPPED";
	public static inline var POINTER_DOWN : String = "POINTER_DOWN";
	public static inline var POINTER_UP : String = "POINTER_UP";
	
	public var touchCount( default, null ) : Int = 0;
	var _touchRegister : Map<Int,TouchData>;
	var _keyRegister : Map<Int,Bool>;
	var _touchListeners : List<GameObject>;
	
	public function new() 
	{
		super();
		_keyRegister = new Map<Int,Bool>();
		_touchRegister = new Map<Int,TouchData>();
		_touchListeners = new List<GameObject>();
		
		core.stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
		core.stage.addEventListener( KeyboardEvent.KEY_UP, onKeyUp );
		
		#if mobile
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			// Hard code at 5 as that is currently the maximum for ipads and top end android
			for ( i in 0...5 ) _touchRegister.set( i, new TouchData( i ) );
			core.stage.addEventListener( TouchEvent.TOUCH_BEGIN, onTouchBegin );
		#else
			_touchRegister.set( 0, new TouchData(0) );
			core.stage.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
		#end
		
	}
		
	/**
	 * KEYBOARD
	 **/
	
	private function onKeyDown(e:KeyboardEvent):Void 
	{
		_keyRegister.set( e.keyCode, true );
	}
	
	private function onKeyUp(e:KeyboardEvent):Void 
	{
		_keyRegister.set( e.keyCode, false );
	}
	
	public function isKeyDown( code : Int ) : Bool {
		return _keyRegister.exists(code) && _keyRegister.get(code);
	}
	
	/**
	 * MOUSE
	 */
		
	public function onMouseDown( e : MouseEvent ) : Void {
		var touch : TouchData = _touchRegister.get(0);		
		touch.isDown = true;
		touch.lastTouchStart.setTo( e.stageX, e.stageY );
		touch.position.setTo( e.stageX, e.stageY );
		core.stage.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
		
		checkTouchTargets( 0, POINTER_DOWN );
	}
	
	public function onMouseUp( e : MouseEvent ) : Void {
		var touch : TouchData = _touchRegister.get(0);
		touch.lastTouchEnd.setTo( e.stageX, e.stageY );
		touch.position.setTo( e.stageX, e.stageY );
		touch.isDown = false;
		core.stage.removeEventListener( MouseEvent.MOUSE_UP, onMouseUp );
		
		checkTouchTargets( 0, POINTER_UP );
	}
		
	/**
	 * TOUCH
	 */
	
	
	public function onTouchBegin( e : TouchEvent ) : Void {
		
		touchCount++;
		
		var touch : TouchData = _touchRegister.get( e.touchPointID );
		touch.lastTouchStart.setTo( e.stageX, e.stageY );
		touch.position.setTo( e.stageX, e.stageY );
		touch.isDown = true;
		
		// If this is the first touch add the listeners
		if ( touchCount == 1 ) {
			core.stage.addEventListener( TouchEvent.TOUCH_END, onTouchEnd );
			core.stage.addEventListener( TouchEvent.TOUCH_MOVE, onTouchMove );
		}
		
		checkTouchTargets( e.touchPointID, POINTER_DOWN );
	}
	
	public function onTouchEnd( e : TouchEvent ) : Void {
		
		touchCount--;
		
		var touch : TouchData = _touchRegister.get( e.touchPointID );
		touch.lastTouchEnd.setTo( e.stageX, e.stageY );
		touch.position.setTo( e.stageX, e.stageY );
		touch.isDown = false;
		
		// This is the last touch - clean up
		if ( touchCount == 0 ) {
			core.stage.removeEventListener( TouchEvent.TOUCH_END, onTouchEnd );
			core.stage.removeEventListener( TouchEvent.TOUCH_MOVE, onTouchMove );
		}
		
		checkTouchTargets( e.touchPointID, POINTER_UP );
	}
	
	public function onTouchMove( e : TouchEvent ) : Void {
		_touchRegister.get( e.touchPointID ).position.setTo( e.stageX, e.stageY );
	}
	
	/**
	 * UPDATES
	 */
	
	override public function onUpdate(seconds:Float):Void 
	{
		super.onUpdate(seconds);
		
		#if !mobile
			_touchRegister.get(0).position.setTo( core.stage.mouseX, core.stage.mouseY );
		#end
	}
	
	/**
	 * CLICKED
	 * Search through listeners and pass on clicked message
	 */
	
	public function addTouchListener( object : GameObject ) {
		_touchListeners.add( object );
	}
	
	public function removeTouchListener( object : GameObject ) {
		_touchListeners.remove( object );
	}
	
	private function checkTouchTargets( pid : Int, mode : String ) : Void {
		
		var touch : TouchData = _touchRegister.get( pid );
		var startPoint : Point;
		var endPoint : Point;
		var bounds : Rectangle;
				
		for ( object in _touchListeners ) {
			bounds = object.display.getBounds();
			startPoint = object.transform.globalToLocal( touch.lastTouchStart );
			
			if ( mode == POINTER_DOWN ) {
				
				if ( bounds.containsPoint( startPoint ) ) {
					object.messenger.sendMessage( POINTER_DOWN, new TouchEventData( POINTER_DOWN, touch.touchId, touch.lastTouchStart, startPoint ) );
				}
				
			}else if ( mode == POINTER_UP ) {
				
				endPoint = object.transform.globalToLocal( touch.lastTouchEnd );
				if ( bounds.containsPoint( endPoint ) ) {
					
					object.messenger.sendMessage( POINTER_UP, new TouchEventData( POINTER_UP, touch.touchId, touch.lastTouchEnd, endPoint ) );
					
					// Event started on this object so it is clicked
					if ( bounds.containsPoint( startPoint ) ) {
						object.messenger.sendMessage( TAPPED, new TouchEventData( TAPPED, touch.touchId, touch.lastTouchEnd, endPoint ) );
					}
				}
			}
		}
		
	}
	 	
	/**
	 * Easy access
	 */
	
	 public function getPointerInfo( id : Int = 0 ) : TouchData {
		return _touchRegister.get( id );
	}
	 
	public function isPointerDown( id : Int = 0 ) : Bool {
		return _touchRegister.get( id ).isDown;
	}
	
	public function getTouchPosition( id : Int = 0 ) : Point {
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
	
	public function isAnyPointerOver( object : GameObject ) : Array<Int> {
		
		var bounds : Rectangle;
		var local : Point;
		var touch : TouchData;
		var result : Array<Int> = [];
		
		for ( key in _touchRegister.keys() ) {
			touch = _touchRegister.get( key );
			bounds = object.display.getBounds();
			local = object.transform.globalToLocal( touch.position );
			
			if ( bounds.containsPoint( local ) ) result.push( touch.touchId );
		}
		
		return result;
	}
	
	public function isAnyPointerDownOver( object : GameObject ) : Array<Int> {
		
		if ( touchCount == 0 ) return [];
		
		var bounds : Rectangle;
		var local : Point;
		var touch : TouchData;
		var result : Array<Int> = [];
		
		for ( key in _touchRegister.keys() ) {
			touch = _touchRegister.get( key );
			
			if ( touch.isDown ) {
				bounds = object.display.getBounds();
				local = object.transform.globalToLocal( touch.position );
				if ( bounds.containsPoint( local ) ) result.push( touch.touchId );
			}
		}
		
		return result;
		
	}
	
}