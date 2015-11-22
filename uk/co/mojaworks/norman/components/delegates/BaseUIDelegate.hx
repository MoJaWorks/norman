package uk.co.mojaworks.norman.components.delegates;

import haxe.CallStack;
import lime.ui.MouseCursor;
import msignal.Signal.Signal1;
import uk.co.mojaworks.norman.components.Component;
import uk.co.mojaworks.norman.components.renderer.BaseRenderer;
import uk.co.mojaworks.norman.factory.GameObject;
import uk.co.mojaworks.norman.systems.Systems;
import uk.co.mojaworks.norman.systems.ui.MouseEvent;

/**
 * ...
 * @author Simon
 */
class BaseUIDelegate extends Component
{
	
	public var isMouseButtonDown : Array<Bool>;
	public var wasMouseButtonDownLastFrame : Array<Bool>;
	public var wasMouseButtonDownElsewhere : Array<Bool>;
	public var isMouseOver : Bool = false;
	public var wasMouseOverLastFrame : Bool = false;
	public var isCurrentTarget : Bool = false;
	public var hitTarget( default, default ) : GameObject = null;
	
	public var clicked : Signal1<MouseEvent>;
	public var cursor : MouseCursor = MouseCursor.DEFAULT;
	
	public function new( ) 
	{
		super( );
		
		clicked = new Signal1<MouseEvent>();
		isMouseButtonDown = [false, false, false];
		wasMouseButtonDownLastFrame = [false, false, false];
		wasMouseButtonDownElsewhere = [false, false, false];
	}
	
	override public function onAdded( ) : Void {
		//trace("Adding UI Delegate for ", gameObject.id );
		if ( hitTarget == null ) hitTarget = gameObject;
		Systems.ui.add( this );
	}
	
	override public function onRemove( ) : Void {
		//trace("Removing UI Delegate for ", gameObject.id );
		if ( hitTarget == gameObject ) hitTarget = null;
		Systems.ui.remove( this );
	}
	
	public function processEvent( e : MouseEvent ) : Void {
		
		switch( e.type ) {
			case MouseEventType.Down:
				onMouseDown( e );
			case MouseEventType.Up:
				onMouseUp( e );
			case MouseEventType.Over:
				onMouseOver( e );
			case MouseEventType.Out:
				onMouseOut( e );
			case MouseEventType.Click:
				onClick( e );				
		}
		
		//TODO: Bubble the event if it's not stopped
		
	}
	
	public function onMouseDown( e : MouseEvent ) : Void {}
	public function onMouseUp( e : MouseEvent ) : Void {}
	public function onMouseOver( e : MouseEvent ) : Void {}
	public function onMouseOut( e : MouseEvent ) : Void { }
	
	public function onClick( e : MouseEvent ) : Void { 
		if ( enabled ) clicked.dispatch( e );
	}
	
	override public function destroy():Void 
	{
		if ( !destroyed ) {
			super.destroy();
			
			isMouseButtonDown = null;
			wasMouseButtonDownLastFrame = null;
			wasMouseButtonDownElsewhere = null;
			
			clicked.removeAll();
			clicked = null;
		}
	}

}