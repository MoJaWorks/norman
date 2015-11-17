package uk.co.mojaworks.norman.components.ui.layout;
import lime.math.Rectangle;

/**
 * ...
 * @author Simon
 */
class LayoutItemContainer extends LayoutItem
{
	
	public var internalHorizontalPadding : Float = 0;
	public var internalVerticalPadding : Float = 0;

	public function new() 
	{
		super();
		
	}
	
	override public function layout(bounds:Rectangle):Void 
	{
		super.layout(bounds);
		
		availableHeight -= internalVerticalPadding * 2;
		availableWidth -= internalHorizontalPadding * 2;
		
		layoutChildren();
	}
	
	private function layoutChildren() : Void 
	{
		
	}
	
}