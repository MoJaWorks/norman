package uk.co.mojaworks.norman.components.ui.layout;

import lime.math.Rectangle;
import uk.co.mojaworks.norman.components.Component;

/**
 * ...
 * @author Simon
 */
class HorizontalLayout extends LayoutItemContainer
{

	public var spacing : Float = 0;
	
	public function new() 
	{
		super();
	}
	
	override public function layoutChildren( ):Void 
	{
		
		var layouts : Array<LayoutItem> = [];
		
		// Get all of the layouts
		for ( child in gameObject.transform.children ) {
			var layout : LayoutItem = LayoutItem.getFromObject( child.gameObject );
			if ( layout != null ) layouts.push( layout );
		}
		
		// Get the fixed widths and weights
		var fixedWidths : Float = 0;
		var totalWeights : Float = 0;
		
		for ( layout in layouts ) {
			if ( layout.requestWidth != null ) fixedWidths += layout.requestWidth;
			else totalWeights += layout.weightWidth;
		}
		
		var availableExpandingSpace : Float = Math.max( 0, availableWidth - fixedWidths - ( spacing * (layouts.length - 1) ));
		var currentX : Float = internalHorizontalPadding;
		
		
		for ( layout in layouts ) {
			
			if ( layout.requestWidth != null ) 
			{
				layout.layout( new Rectangle( currentX, internalVerticalPadding, layout.requestWidth, availableHeight ) );
				currentX += layout.requestWidth;
			}
			else 
			{
				var width : Float = (layout.weightWidth / totalWeights) * availableExpandingSpace;
				layout.layout( new Rectangle( currentX, internalVerticalPadding, width, availableHeight ) );
				currentX += width;
			}
			
			currentX += spacing;
			
		}
	}
}