package uk.co.mojaworks.norman.systems.ui;

import lime.math.Vector2;
import uk.co.mojaworks.norman.components.ui.UIItem;
import uk.co.mojaworks.norman.core.CoreObject;
import uk.co.mojaworks.norman.core.view.GameObject;
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
			if ( item.isPointerEnabled && item.gameObject.sprite != null && item.gameObject.sprite.hitTestPoint( pointer ) && hasPriority( item, hitItem ) ) {
				hitItem = item;
			}
		}
		
		if ( hitItem != null ) {
			trace("Mouse over " + hitItem.gameObject.autoId );
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