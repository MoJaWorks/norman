package uk.co.mojaworks.norman.display.ui.contextmenu;

import uk.co.mojaworks.norman.display.Sprite;

/**
 * ...
 * @author Simon
 */
class ContextMenu extends Sprite
{

	var items : Array<ContextMenuItem>;
	
	public function new( data : Array<ContextMenuItemData> ) 
	{
		super();
		
		items = [];
		
		for ( itemData in data ) {
			var item : ContextMenuItem = new ContextMenuItem( itemData );
			item.y = items.length * 40;
			item.uiComponent.enabled = true;
			addChild( item );
			items.push( item );
		}
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		items = null;
	}
	
}