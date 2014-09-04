package uk.co.mojaworks.norman.components.input ;

import uk.co.mojaworks.norman.core.Component;
import uk.co.mojaworks.norman.core.GameObject;

/**
 * ...
 * @author Simon
 */
class TouchListener extends Component
{

	public static inline var TAPPED : String = "TAPPED";
	public static inline var POINTER_DOWN : String = "POINTER_DOWN";
	public static inline var POINTER_UP : String = "POINTER_UP";
	
	public function new() 
	{
		super();
	}
	
	override public function onAdded() : Void {
		root.get(Input).addTouchListener( gameObject );
	}
	
	override public function onRemoved() : Void {
		root.get(Input).removeTouchListener( gameObject );
	}
	
	public function onTouchEvent( event : TouchEventData ) : Void {
		
		trace("Touch Event on ", gameObject.id, event.type );
		
		gameObject.messenger.sendMessage( event.type, event );
		
		// Bubble the event
		if ( !event.isSuppressed ) {
			var next : GameObject = gameObject.findParentThatHas( TouchListener );
			if ( next != null ) next.get(TouchListener).onTouchEvent( event );
		}
	}
		
}