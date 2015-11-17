package uk.co.mojaworks.norman.components.ui.layout;

import haxe.macro.Expr.Var;
import lime.math.Rectangle;
import uk.co.mojaworks.norman.components.Component;
import uk.co.mojaworks.norman.components.Transform;
import uk.co.mojaworks.norman.utils.MathUtils;

/**
 * ...
 * @author Simon
 */

enum LayoutItemAlign {
	Left;
	Right;
	Center;
}

enum LayoutItemVerticalAlign {
	Top;
	Bottom;
	Center;
}
 
class LayoutItem extends Component
{
	public var availableWidth : Float = 0;
	public var availableHeight : Float = 0;
	
	public var parent( get, never ) : LayoutItem;
	
	public var verticalPadding : Float = 0;
	public var horizontalPadding : Float = 0;
	
	public var align : LayoutItemAlign = LayoutItemAlign.Left;
	public var verticalAlign : LayoutItemVerticalAlign = LayoutItemVerticalAlign.Top;
	
	public var requestWidth : Null<Float> = null;
	public var requestHeight : Null<Float> = null;
	
	public var currentWidth : Float;
	public var currentHeight : Float;
	public var stretchRendererToFill : Bool = false;
	public var maintainRendererAspect : Bool = false;
	
	// Greater weights will take up more room when stretching to fill and there's not enough room
	public var weightWidth : Float = 1;
	public var weightHeight : Float = 1;

	public function new( ) 
	{
		super();
	}
	
	public function layout( bounds : Rectangle ) : Void {
		
		availableWidth = bounds.width - (horizontalPadding * 2);
		availableHeight = bounds.height - (verticalPadding * 2);
				
		if ( gameObject.renderer != null ) {
			if ( stretchRendererToFill ) {
				if ( !maintainRendererAspect ) {
					gameObject.transform.scaleX = availableWidth / gameObject.renderer.width;
					gameObject.transform.scaleY = availableHeight / gameObject.renderer.height;
					currentWidth = availableWidth;
					currentHeight = availableHeight;
				}else  {
					gameObject.transform.scale = Math.min( availableWidth / gameObject.renderer.width, availableHeight / gameObject.renderer.height );
					currentWidth = gameObject.renderer.width * gameObject.transform.scaleX;
					currentHeight = gameObject.renderer.height * gameObject.transform.scaleY;
				}
			}else {
				currentWidth = gameObject.renderer.width * gameObject.transform.scaleX;
				currentHeight = gameObject.renderer.height * gameObject.transform.scaleY;
			}
		}else {
			currentWidth = availableWidth;
			currentHeight = availableHeight;
		}
		
		var diffX : Float = availableWidth - currentWidth;
		var diffY : Float = availableHeight - currentHeight;
		
		switch( align ) {
			case Left:
				gameObject.transform.x = bounds.x + horizontalPadding;
			case Right:
				gameObject.transform.x = bounds.x + horizontalPadding + diffX;
			case Center:
				gameObject.transform.x = bounds.x + horizontalPadding + (diffX * 0.5);
		}
		
		switch( verticalAlign ) {
			case Top:
				gameObject.transform.y = bounds.y + verticalPadding;
			case Bottom:
				gameObject.transform.y = bounds.y + verticalPadding + diffY;
			case Center:
				gameObject.transform.y = bounds.y + verticalPadding + (diffY * 0.5);
		}
		
		trace("Laying out ", gameObject.id, bounds, availableWidth, availableHeight, gameObject.transform.x, gameObject.transform.y );
						
	}
	
	public function get_parent( ) : LayoutItem {
		
		var parent_transform : Transform = gameObject.transform.parent;
		var parent_layout : LayoutItem = null;
		
		while ( parent_transform != null ) {
			parent_layout = LayoutItem.getFromObject( parent_transform.gameObject );
			if ( parent_layout != null ) return parent_layout;
		}
		
		return null;
		
	}
	
}