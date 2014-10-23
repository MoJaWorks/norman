package uk.co.mojaworks.norman.components.input ;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.events.TouchEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.ui.Multitouch;
import openfl.ui.MultitouchInputMode;
import uk.co.mojaworks.norman.components.input.TouchEventData;
import uk.co.mojaworks.norman.core.Component;
import uk.co.mojaworks.norman.core.GameObject;
import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * ...
 * @author Simon
 */
class Input extends Component
{
		
	public static inline var MAX_TOUCHES : Int = 5;
	
	public var touchCount( default, null ) : Int = 0;
	var _touchRegister : Map<Int,TouchData>;
	var _keyRegister : Map<Int,Bool>;
	var _touchListeners : LinkedList<GameObject>;
	
	public function new() 
	{
		super();
		_keyRegister = new Map<Int,Bool>();
		_touchRegister = new Map<Int,TouchData>();
		_touchListeners = new LinkedList<GameObject>();
		
		root.stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
		root.stage.addEventListener( KeyboardEvent.KEY_UP, onKeyUp );
		
		#if mobile
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			// Hard code at 5 as that is currently the maximum for ipads and top end android
			for ( i in 0...MAX_TOUCHES ) _touchRegister.set( i, new TouchData( i ) );
			root.stage.addEventListener( TouchEvent.TOUCH_BEGIN, onTouchBegin );
		#else
			_touchRegister.set( 0, new TouchData(0) );
			root.stage.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
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
		root.stage.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
		
		checkTouchTargets( 0, TouchListener.POINTER_DOWN );
	}
	
	public function onMouseUp( e : MouseEvent ) : Void {
		var touch : TouchData = _touchRegister.get(0);
		touch.lastTouchEnd.setTo( e.stageX, e.stageY );
		touch.position.setTo( e.stageX, e.stageY );
		touch.isDown = false;
		root.stage.removeEventListener( MouseEvent.MOUSE_UP, onMouseUp );
		
		checkTouchTargets( 0, TouchListener.POINTER_UP );
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
			root.stage.addEventListener( TouchEvent.TOUCH_END, onTouchEnd );
			root.stage.addEventListener( TouchEvent.TOUCH_MOVE, onTouchMove );
		}
		
		checkTouchTargets( e.touchPointID, TouchListener.POINTER_DOWN );
	}
	
	public function onTouchEnd( e : TouchEvent ) : Void {
		
		touchCount--;
		
		var touch : TouchData = _touchRegister.get( e.touchPointID );
		touch.lastTouchEnd.setTo( e.stageX, e.stageY );
		touch.position.setTo( e.stageX, e.stageY );
		touch.isDown = false;
		
		// This is the last touch - clean up
		if ( touchCount == 0 ) {
			root.stage.removeEventListener( TouchEvent.TOUCH_END, onTouchEnd );
			root.stage.removeEventListener( TouchEvent.TOUCH_MOVE, onTouchMove );
		}
		
		checkTouchTargets( e.touchPointID, TouchListener.POINTER_UP );
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
			_touchRegister.get(0).position.setTo( root.stage.mouseX, root.stage.mouseY );
		#end
	}
	
	/**
	 * CLICKED
	 * Search through listeners and pass on clicked message
	 */
	
	public function addTouchListener( object : GameObject ) {
		_touchListeners.push( object );
	}
	
	public function removeTouchListener( object : GameObject ) {
		_touchListeners.remove( object );
	}
	
	private function checkTouchTargets( pid : Int, mode : String ) : Void {
		
		var touch : TouchData = _touchRegister.get( pid );
		var startPoint : Point;
		var endPoint : Point;
		var bounds : Rectangle;
				
		trace( _touchListeners, _touchListeners.length );
		
		var object : GameObject = getPrimaryTarget( pid );
			
		bounds = object.sprite.getBounds();
		startPoint = object.transform.globalToLocal( touch.lastTouchStart );
		
		if ( mode == TouchListener.POINTER_DOWN ) {
			
			if ( bounds.containsPoint( startPoint ) ) {
				object.get(TouchListener).onTouchEvent( new TouchEventData( TouchListener.POINTER_DOWN, touch.touchId, touch.lastTouchStart, startPoint ) );
			}
			
		}else if ( mode == TouchListener.POINTER_UP ) {
			
			endPoint = object.transform.globalToLocal( touch.lastTouchEnd );
			if ( bounds.containsPoint( endPoint ) ) {
				
				object.get(TouchListener).onTouchEvent( new TouchEventData( TouchListener.POINTER_UP, touch.touchId, touch.lastTouchEnd, endPoint ) );
				
				// Event started on this object so it is clicked
				if ( bounds.containsPoint( startPoint ) ) {
					object.get(TouchListener).onTouchEvent( new TouchEventData( TouchListener.TAPPED, touch.touchId, touch.lastTouchEnd, endPoint ) );
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
	
	public function isPointerOver( id : Int, object : GameObject ) : Bool {
		return object.sprite.hitTestPoint( _touchRegister.get(id).position );
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

		var result : Array<Int> = [];
		
		for ( touch in _touchRegister ) {			
			if ( isPointerOver( touch.touchId, object ) ) result.push( touch.touchId );
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
				bounds = object.sprite.getBounds();
				local = object.transform.globalToLocal( touch.position );
				if ( bounds.containsPoint( local ) ) result.push( touch.touchId );
			}
		}
		
		return result;
		
	}
	
	public function isPrimaryTarget( gameObject:GameObject, pointer : Int = 0 ) : Bool
	{
		for ( object in _touchListeners ) {
			if ( object.getChildSortString() > gameObject.getChildSortString() && isPointerOver( pointer, object ) ) return false;
		}
		
		return true;
	}
	
	public function getPrimaryTarget( pointer : Int = 0 ) : GameObject
	{
		var primary : GameObject = null;
		
		for ( object in _touchListeners ) {
			if ( primary == null || (object.getChildSortString() > gameObject.getChildSortString() && isPointerOver( pointer, object )) ) primary = object;
		}
		
		return primary;
	}
	
	public function getPrimaryTargetAtPoint( globalPoint : Point ) : GameObject
	{
		var primary : GameObject = null;
		
		for ( object in _touchListeners ) {
			if ( primary == null || (object.getChildSortString() > gameObject.getChildSortString() && object.display.hitTestPoint( globalPoint )) ) primary = object;
		}
		
		return primary;
	}
	
}