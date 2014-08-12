package uk.co.mojaworks.norman.components.ui ;

import uk.co.mojaworks.norman.components.display.Display;
import uk.co.mojaworks.norman.systems.input.InputSystem;
import uk.co.mojaworks.norman.systems.input.TouchData;
import uk.co.mojaworks.norman.core.Component;

/**
 * ...
 * @author Simon
 */
class Button extends Component
{

	public var upState : Display;
	public var downState : Display;
	public var overState : Display;
	public var disabledState : Display;
	
	public var mouseOver : Bool;
	public var mouseDown : Bool;
	
	private var currentState : Display;
	
	public function new() 
	{
		super();
	}
	
	public function setup( upState : Display, downState : Display = null, overState : Display = null, disabledState : Display = null ) : Void {
		
		this.upState = upState;
		this.downState = (downState == null) ? upState : downState;
		this.overState = (overState == null) ? upState : overState;
		this.disabledState = (disabledState == null ) ? upState : disabledState;
		
	}
	
	override public function onUpdate(seconds:Float):Void 
	{
		super.onUpdate(seconds);
		
		// Buttons only respond to primary pointer
		var pointer : TouchData = core.app.input.getPointerInfo( 0 );
		var newState : Display = null;
		
		if ( gameObject.display != null && gameObject.display.getBounds().containsPoint( gameObject.transform.globalToLocal( pointer.position ) ) ) {
			mouseOver = true;
			if ( pointer.isDown ) {
				mouseDown = true;
			}else {
				mouseDown = false;
			}
		}else {
			mouseOver = false;
			mouseDown = false;
		}
		
		if ( mouseOver ) {
			if ( mouseDown ) {
				newState = downState;
			}else {
				newState = overState;
			}
		}else {
			newState = upState;
		}
		
		if ( currentState != newState ) {
			gameObject.add( newState );
		}
	}
	
}