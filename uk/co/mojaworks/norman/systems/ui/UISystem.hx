package uk.co.mojaworks.norman.systems.ui;

import lime.math.Vector2;
import lime.ui.Mouse;
import lime.ui.MouseCursor;
import uk.co.mojaworks.norman.components.ui.UIItem;
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

	public var items : LinkedList<UIItem>; 
	
	public function new() 
	{
		super();
		items = new LinkedList<UIItem>();
		
		addMessageListener( InputSystem.POINTER_DOWN, onPointerDown );
		addMessageListener( InputSystem.POINTER_UP, onPointerUp );
	}
	
	public function add( item : UIItem ) : Void {
		items.push( item );
	}
	
	public function remove( item : UIItem ) : Void {
		items.remove( item );
	}
	
	public function update( seconds : Float ) : Void {
		
		var pointer : Vector2 = core.app.input.getPointerPosition(0);
		var hitItem : UIItem = null;
		
		for ( item in items ) {
			
			item.isPointerOver = false;
			if ( item.isPointerEnabled && item.getHitSprite() != null && item.getHitSprite().hitTestPoint( pointer ) && hasPriority( item, hitItem ) ) {
				if ( hitItem != null ) hitItem.update( seconds );
				hitItem = item;
			}else {
				item.update( seconds );
			}
		}
		
		if ( hitItem != null ) {
			hitItem.isPointerOver = true;
			hitItem.update( seconds );
			
			if ( hitItem.isInteractive ) Mouse.cursor = MouseCursor.POINTER;
			else Mouse.cursor = MouseCursor.ARROW;
			//trace("Mouse over " + hitItem.gameObject.autoId );
		}else {
			Mouse.cursor = MouseCursor.ARROW;
		}
	}
	
	public function onPointerDown( messageData : MessageData ) : Void {
		
		var pointerData : TouchData = cast messageData.data;
		
		if ( pointerData.touchId == 0 ) {
			var pointer : Vector2 = pointerData.lastTouchStart;
			var hitItem : UIItem = null;
			
			for ( item in items ) {
				
				item.isPointerDown = false;
				if ( item.isPointerEnabled && item.getHitSprite() != null && item.getHitSprite().hitTestPoint( pointer ) && hasPriority( item, hitItem ) ) {
					if ( hitItem != null ) hitItem.update( 0 );
					hitItem = item;
				}else{
					item.update( 0 );
				}
			}
			
			if ( hitItem != null ) {
				hitItem.isPointerDown = true;
				hitItem.update( 0 );
				//trace("Mouse down " + hitItem.gameObject.autoId );
			}
		}
	}
	
	public function onPointerUp( messageData : MessageData ) : Void {
		
		var pointerData : TouchData = cast messageData.data;
		
		if ( pointerData.touchId == 0 ) {
			var pointer : Vector2 = pointerData.lastTouchEnd;
			var hitItem : UIItem = null;
			
			for ( item in items ) {
				item.isPointerDown = false;
				if ( item.isPointerEnabled && item.getHitSprite() != null && item.getHitSprite().hitTestPoint( pointer ) && hasPriority( item, hitItem ) ) {
					hitItem = item;
				}
				item.update( 0 );
			}
			
		}
	}
	
	public function hasPriority( item : UIItem, vs : UIItem ) : Bool {
		// check whether this item would override the last item through being rendered on top
		if ( vs == null ) {
			return true;
		}else if ( item.gameObject.displayIndex > vs.gameObject.displayIndex ) {
			return true;
		}
		
		return false;
	}
}