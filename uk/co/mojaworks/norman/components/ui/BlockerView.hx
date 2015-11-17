package uk.co.mojaworks.norman.components.ui;

import uk.co.mojaworks.norman.components.delegates.BaseViewDelegate;
import uk.co.mojaworks.norman.systems.Systems;

/**
 * ...
 * @author Simon
 */
class BlockerView extends BaseViewDelegate
{

	public function new() 
	{
		super();
		
	}
	
	override public function resize():Void 
	{
		super.resize();
		
		gameObject.transform.x = Systems.viewport.left;
		gameObject.transform.y = Systems.viewport.top;
		gameObject.transform.scaleX = Systems.viewport.totalWidth / gameObject.renderer.width;
		gameObject.transform.scaleY = Systems.viewport.totalHeight / gameObject.renderer.height;
		
	}
	
}