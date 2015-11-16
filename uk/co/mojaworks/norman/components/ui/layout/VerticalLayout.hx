package uk.co.mojaworks.norman.components.ui.layout;

import lime.math.Rectangle;
import uk.co.mojaworks.norman.components.Component;

/**
 * ...
 * @author Simon
 */
class VerticalLayout extends LayoutItem
{
	public var padding : Float = 0;

	public function new() 
	{
		super();
	}
	
	override public function layout(bounds:Rectangle):Void 
	{
		super.layout(bounds);
		
		var layouts : Array<LayoutItem>;
		
		// Get all of the layouts
		for ( child in gameObject.transform.children ) {
			var layout : LayoutItem = LayoutItem.getFromObject( child.gameObject );
			if ( layout != null ) layouts.push( layout );
		}
		
		// Get the fixed widths and weights
		var fixedWidths : Float = 0;
		var totalWeights : Float = 0;
		
		
		
		
		
	}
}