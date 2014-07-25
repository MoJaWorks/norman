package uk.co.mojaworks.norman.components.input;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.events.TouchEvent;
import openfl.geom.Point;
import openfl.ui.Multitouch;

/**
 * ...
 * @author Simon
 */
class Input extends Component
{

	public var isTouching( default, null ) : Bool = false;
	public var lastTouchStartPosition( default, null ) : Point;
	public var lastTouchEndPosition( default, null ) : Point;
	public var touchPositions( default, null ) : Array<Point>;
	var _regsiter : Map<Int,Bool>;
	
	public function new() 
	{
		super();
		register = new Map<Int,Bool>():
		touchPositions = [];
		
		for ( i in 0...Multitouch.maxTouchPoints ) touchPositions.push( new Point() );
		
		lastTouchStartPosition = new Point();
		lastTouchEndPosition = new Point();
	}
	
	override public function onAdded():Void 
	{
		super.onAdded();
		
		core.stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
		core.stage.addEventListener( KeyboardEvent.KEY_UP, onKeyUp );
		
		#if mobile
			core.stage.addEventListener( TouchEvent.TOUCH_BEGIN, onTouchBegin );
		#else
			core.stage.addEventListener( MouseEvent.MOUSE_DOWN, onTouchBegin );
		#end
	}
	
	/**
	 * Keyboard
	 **/
	
	private function onKeyDown(e:KeyboardEvent):Void 
	{
		_register.set( e.keyCode, true );
	}
	
	private function onKeyUp(e:KeyboardEvent):Void 
	{
		_register.set( e.keyCode, false );
	}
	
	public function isKeyDown( code : Int ) : Void {
		return _register.exists(code) && _regsiter.get(code);
	}
	
	/**
	 * Mouse
	 */
		
	public function onMouseDown( e : MouseEvent ) : Void {
		lastTouchStartPosition.setTo( e.stageX, e.stageY );
		touchPositions[0].setTo( 
		core.stage.addEventListener( MouseEvent.MOUSE_UP, onTouchEnd );
	}
	
	public function onMouseUp( e : MouseEvent ) : Void {
		lastTouchEndPosition.setTo( e.stageX, e.stageY );
		core.stage.removeEventListener( MouseEvent.MOUSE_UP, onTouchEnd );
	}
		
	override public function onUpdate(seconds:Float):Void 
	{
		super.onUpdate(seconds);
		touchPositions.setTo( stage.mouseX, stage.mouseY );
	}
	
	
	public function onTouchBegin( e : MouseEvent ) : Void {
		lastTouchStartPosition.setTo( e.stageX, e.stageY );
		core.stage.addEventListener( MouseEvent.MOUSE_UP, onTouchEnd );
	}
	
	public function onTouchEnd( e : MouseEvent ) : Void {
		lastTouchEndPosition.setTo( e.stageX, e.stageY );
		core.stage.removeEventListener( MouseEvent.MOUSE_UP, onTouchEnd );
	}
	
}