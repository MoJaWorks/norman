package uk.co.mojaworks.norman.components.director.ui ;

import uk.co.mojaworks.norman.components.display.Display;
import uk.co.mojaworks.norman.components.input.Input;
import uk.co.mojaworks.norman.components.input.TouchData;
import uk.co.mojaworks.norman.core.Component;

/**
 * ...
 * @author Simon
 */
class Button extends View
{

	private var upState : Display;
	private var downState : Display;
	private var overState : Display;
	private var disabledState : Display;
	
	private var mouseOver : Bool = false;
	private var mouseDown : Bool = false;
	
	private var mouseDownCaptured : Bool = false;
	private var mouseWasDown : Bool = false;
	
	public var buttonEnabled : Bool = true;
	
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
		
		var newState : Display = null;
		
		if ( buttonEnabled ) {
	
			// Buttons only respond to primary pointer
			var pointer : TouchData = root.get(Input).getPointerInfo( 0 );
						
			if ( gameObject.display != null && gameObject.display.getBounds().containsPoint( gameObject.transform.globalToLocal( pointer.position ) ) && root.get(Input).isPrimaryTarget( gameObject ) ) {
				
				if ( mouseOver && !mouseWasDown && pointer.isDown ) {
					mouseDownCaptured = true;
				}else if ( !pointer.isDown ) {
					mouseDownCaptured = false;
				}
				mouseOver = true;
				mouseWasDown = pointer.isDown;
				
				if ( pointer.isDown && mouseDownCaptured ) {
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
						
		}else {
			newState = disabledState;
		}
		
		if ( currentState != newState ) {
			gameObject.add( newState );
			currentState = newState;
		}
	}
	
}