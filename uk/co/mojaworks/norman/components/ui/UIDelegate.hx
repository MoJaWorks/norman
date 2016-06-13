package uk.co.mojaworks.norman.components.ui;

import haxe.CallStack;
import msignal.Signal.Signal1;
import uk.co.mojaworks.norman.components.Component;
import uk.co.mojaworks.norman.components.renderer.BaseRenderer;
import uk.co.mojaworks.norman.core.io.pointer.PointerInput;
import uk.co.mojaworks.norman.factory.GameObject;
import uk.co.mojaworks.norman.systems.Systems;
import uk.co.mojaworks.norman.systems.ui.PointerEvent;

/**
 * ...
 * @author Simon
 */
class UIDelegate extends Component implements IUIDelegate
{
	
	public var isMouseButtonDown : Array<Bool>;
	public var wasMouseButtonDownLastFrame : Array<Bool>;
	public var wasMouseButtonDownElsewhere : Array<Bool>;
	public var isMouseOver : Bool = false;
	public var wasMouseOverLastFrame : Bool = false;
	public var isCurrentTarget : Bool = false;
	public var hitTarget : GameObject = null;
	
	public var clicked : Signal1<PointerEvent>;
	//public var cursor : MouseCursor = MouseCursor.DEFAULT;
	
	public function new( ) 
	{
		super( );
		
		clicked = new Signal1<PointerEvent>();
		isMouseButtonDown = [ for ( i in 0...PointerInput.MAX_BUTTONS ) false ];
		wasMouseButtonDownLastFrame = [ for ( i in 0...PointerInput.MAX_BUTTONS ) false ];
		wasMouseButtonDownElsewhere = [ for ( i in 0...PointerInput.MAX_BUTTONS ) false ];
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
	
	public function processEvent( e : PointerEvent ) : Void {
		
		trace("Processing UI Event", e.type );
		
		switch( e.type ) {
			case PointerEventType.Down:
				onMouseDown( e );
			case PointerEventType.Up:
				onMouseUp( e );
			case PointerEventType.Over:
				onMouseOver( e );
			case PointerEventType.Out:
				onMouseOut( e );
			case PointerEventType.Click:
				onClick( e );
			case PointerEventType.Scroll:
				onMouseScroll( e );
		}
		
		//TODO: Bubble the event if it's not stopped
		
	}
	
	public function onMouseDown( e : PointerEvent ) : Void {
		trace("MouseDown Base");
	}
	public function onMouseUp( e : PointerEvent ) : Void {}
	public function onMouseOver( e : PointerEvent ) : Void {}
	public function onMouseOut( e : PointerEvent ) : Void { }
	public function onMouseScroll( e : PointerEvent ) : Void { }
	
	public function onClick( e : PointerEvent ) : Void { 
		trace("Onclick");
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