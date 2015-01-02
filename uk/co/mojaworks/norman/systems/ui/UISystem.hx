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
		
		for ( item in items ) {
			
			if ( item.isPointerEnabled && item.gameObject.sprite != null && item.gameObject.sprite.hitTestPoint( pointer ) ) {
				trace("Mouse over " + item.gameObject.autoId );
			}
		}
		
	}
}