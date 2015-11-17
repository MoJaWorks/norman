package uk.co.mojaworks.norman.components.ui.layout;

import lime.math.Rectangle;
import uk.co.mojaworks.norman.components.Component;

/**
 * ...
 * @author Simon
 */
class VerticalLayout extends LayoutItemContainer
{
	public var spacing : Float = 0;

	public function new() 
	{
		super();
	}
	
	override public function layoutChildren( ) : Void 
	{
		var layouts : Array<LayoutItem> = [];
		
		// Get all of the layouts
		for ( child in gameObject.transform.children ) {
			var layout : LayoutItem = LayoutItem.getFromObject( child.gameObject );
			if ( layout != null ) layouts.push( layout );
		}
		
		// Get the fixed widths and weights
		var fixedHeights : Float = 0;
		var totalWeights : Float = 0;
		
		for ( layout in layouts ) {
			if ( layout.requestHeight != null ) fixedHeights += layout.requestHeight;
			else totalWeights += layout.weightHeight;
		}
		
		var availableExpandingSpace : Float = Math.max( 0, availableHeight - fixedHeights - ( spacing * (layouts.length - 1) ));
		var currentY : Float = internalVerticalPadding;
		
		
		for ( layout in layouts ) {
			
			if ( layout.requestHeight != null ) 
			{
				layout.layout( new Rectangle( internalHorizontalPadding, currentY, availableWidth, layout.requestHeight ) );
				currentY += layout.requestHeight;
			}
			else 
			{
				var height : Float = ( layout.weightHeight / totalWeights ) * availableExpandingSpace;
				layout.layout( new Rectangle( internalHorizontalPadding, currentY, availableWidth, height ) );
				currentY += height;
			}
			
			currentY += spacing;
			
		}
				
	}
}