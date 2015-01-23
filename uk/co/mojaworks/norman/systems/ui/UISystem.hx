package uk.co.mojaworks.norman.systems.ui;

import lime.math.Vector2;
import lime.ui.Mouse;
import lime.ui.MouseCursor;
import uk.co.mojaworks.norman.components.ui.UITouchListener;
import uk.co.mojaworks.norman.core.CoreObject;
import uk.co.mojaworks.norman.core.Messenger.MessageData;
import uk.co.mojaworks.norman.core.view.GameObject;
import uk.co.mojaworks.norman.systems.input.InputSystem;
import uk.co.mojaworks.norman.systems.input.TouchData;
import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * ...
 * @author Simon
 */
class UISystem extends CoreObject
{

	public var items : LinkedList<UITouchListener>;
	public var primaryPointerTarget : UITouchListener;
	
	public function new() 
	{
		super();
		items = new LinkedList<UITouchListener>();
		
		core.app.input.pointerDown.add( onPointerDown );
		core.app.input.pointerUp.add( onPointerUp );
	}
	
	/**
	 * Adding/removing
	 */
	
	public function add( item : UITouchListener ) : Void {
		items.push( item );
	}
	
	public function remove( item : UITouchListener ) : Void {
		items.remove( item );
	}
	
	/**
	 * Updating
	 */
	
	public function update( seconds : Float ) : Void {
		
		var pointer : Vector2 = core.app.input.getPointerPosition(0);
		primaryPointerTarget = null;
		
		for ( item in items ) {
			
			if ( item.isPointerEnabled && item.getHitSprite() != null && item.getHitSprite().hitTestPoint( pointer ) ) {
				item.isPointerOver = true;
				if( hasPriority( item, primaryPointerTarget ) ) primaryPointerTarget = item;
			}else {
				item.isPointerOver = false;
			}
		}
		
		if ( primaryPointerTarget != null ) {
			Mouse.cursor = MouseCursor.POINTER;
		}else {
			Mouse.cursor = MouseCursor.ARROW;
		}
	}
	
	public function onPointerDown( pointerData : TouchData ) : Void {
		
		if ( pointerData.touchId == 0 ) {
			var pointer : Vector2 = pointerData.lastTouchStart;
			if ( primaryPointerTarget != null ) primaryPointerTarget.pointerDown.dispatch();
		}

	}
	
	public function onPointerUp( pointerData : TouchData ) : Void {
		
		if ( pointerData.touchId == 0 ) {
			var pointer : Vector2 = pointerData.lastTouchEnd;
			if ( primaryPointerTarget != null ) primaryPointerTarget.pointerUp.dispatch();
		}
	}
	
	public function hasPriority( item : UITouchListener, vs : UITouchListener ) : Bool {
		// check whether this item would override the last item through being rendered on top
		if ( vs == null ) {
			return true;
		}else if ( item.gameObject.displayIndex > vs.gameObject.displayIndex ) {
			return true;
		}
		
		return false;
	}
}