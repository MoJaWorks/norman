package uk.co.mojaworks.norman.components.input;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.events.TouchEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.ui.Multitouch;
import openfl.ui.MultitouchInputMode;
import uk.co.mojaworks.norman.core.Component;
import uk.co.mojaworks.norman.core.GameObject;

/**
 * ...
 * @author Simon
 */
class Input extends Component
{
	
	public static inline var TAPPED : String = "TAPPED";
	public static inline var TOUCH_START : String = "TOUCH_START";
	public static inline var TOUCH_END : String = "TOUCH_END";
	
	public var touchCount( default, null ) : Int = 0;
	var _touchRegister : Map<Int,TouchData>;
	var _keyRegister : Map<Int,Bool>;
	var _touchListeners : Array<GameObject>;
	
	public function new() 
	{
		super();
		_keyRegister = new Map<Int,Bool>();
		_touchRegister = new Map<Int,TouchData>();
		_touchListeners = [];
		
		#if mobile
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			for ( i in 0...Multitouch.maxTouchPoints ) _touchRegister.set( i, new TouchData( i ) );
		#else
			_touchRegister.set( 0, new TouchData(0) );
		#end
		
	}
	
	override public function onAdded():Void 
	{
		super.onAdded();
		
		core.stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
		core.stage.addEventListener( KeyboardEvent.KEY_UP, onKeyUp );
		
		#if mobile
		trace("Using touch events");
			core.stage.addEventListener( TouchEvent.TOUCH_BEGIN, onTouchBegin );
		#else
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
		touch.isTouching = true;
		touch.lastTouchStart.setTo( e.stageX, e.stageY );
		touch.position.setTo( e.stageX, e.stageY );
		core.stage.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
	}
	
	public function onMouseUp( e : MouseEvent ) : Void {
		var touch : TouchData = _touchRegister.get(0);
		touch.lastTouchEnd.setTo( e.stageX, e.stageY );
		touch.position.setTo( e.stageX, e.stageY );
		touch.isTouching = false;
		core.stage.removeEventListener( MouseEvent.MOUSE_UP, onMouseUp );
		
		checkTouchTargets(0);
	}
		
	/**
	 * TOUCH
	 */
	
	
	public function onTouchBegin( e : TouchEvent ) : Void {
		
		touchCount++;
		
		var touch : TouchData = _touchRegister.get( e.touchPointID );
		touch.lastTouchStart.setTo( e.stageX, e.stageY );
		touch.position.setTo( e.stageX, e.stageY );
		touch.isTouching = true;
		
		// If this is the first touch add the listeners
		if ( touchCount == 1 ) {
			core.stage.addEventListener( TouchEvent.TOUCH_END, onTouchEnd );
			core.stage.addEventListener( TouchEvent.TOUCH_MOVE, onTouchMove );
		}
	}
	
	public function onTouchEnd( e : TouchEvent ) : Void {
		
		touchCount--;
		
		var touch : TouchData = _touchRegister.get( e.touchPointID );
		touch.lastTouchEnd.setTo( e.stageX, e.stageY );
		touch.position.setTo( e.stageX, e.stageY );
		touch.isTouching = false;
		
		// This is the last touch - clean up
		if ( touchCount == 0 ) {
			core.stage.removeEventListener( TouchEvent.TOUCH_END, onTouchEnd );
			core.stage.removeEventListener( TouchEvent.TOUCH_MOVE, onTouchMove );
		}
		
		checkTouchTargets( e.touchPointID );
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
		if ( _touchListeners.indexOf( object ) == -1 ) _touchListeners.push( object );
	}
	
	public function removeTouchListener( object : GameObject ) {
		_touchListeners.remove( object );
	}
	
	private function checkTouchTargets( pid : Int ) : Void {
		
		for ( object in _touchListeners ) {
			var bounds : Rectangle = object.display.getBounds();
			var startPoint : Point = object.transform.globalToLocal(_touchRegister.get( pid ).lastTouchStart );
			var endPoint : Point = object.transform.globalToLocal(_touchRegister.get( pid ).lastTouchEnd );
			if ( bounds.containsPoint( startPoint ) && bounds.containsPoint( endPoint ) ) {
				object.messenger.sendMessage( TAPPED, endPoint );
			}
		}
		
	}
	 
	private function onClick( ) : Void {
		trace("Clicked ", core.stage.mouseX, core.stage.mouseY );
	}
	
}