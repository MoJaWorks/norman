package uk.co.mojaworks.norman.components.ui;

import uk.co.mojaworks.norman.components.director.BaseViewDelegate;
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
		
		gameObject.transform.x = core.view.left;
		gameObject.transform.y = core.view.top;
		gameObject.transform.scaleX = core.view.totalWidth / gameObject.renderer.width;
		gameObject.transform.scaleY = core.view.totalHeight / gameObject.renderer.height;
		
	}
	
}