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
	public var parent( get, never ) : LayoutItem;
	
	public var align : LayoutItemAlign;
	public var verticalAlign : LayoutItemVerticalAlign;
	
	public var requestWidth : Null<Float> = null;
	public var requestHeight : Null<Float> = null;
	
	public var currentWidth : Float;
	public var currentHeight : Float;
	public var stretchRendererToFill : Bool = false;
	
	// Greater weights will take up more room when stretching to fill and there's not enough room
	public var weightWidth : Float = 1;
	public var weightHeight : Float = 1;

	public function new( ) 
	{
		super();
	}
	
	public function layout( bounds : Rectangle ) : Void {
		
		if ( stretchRendererToFill ) {
			gameObject.transform.scaleX = currentWidth / gameObject.renderer.width;
			gameObject.transform.scaleY = currentHeight / gameObject.renderer.height;
			currentWidth = bounds.width;
			currentHeight = bounds.height;
		}else {
			gameObject.transform.scale = Math.min( currentWidth / gameObject.renderer.width, currentHeight / gameObject.renderer.height );
			currentWidth = gameObject.renderer.width * gameObject.transform.scaleX;
			currentHeight = gameObject.renderer.height * gameObject.transform.scaleY;
		}
		
		var diffX : Float = bounds.width - currentWidth;
		var diffY : Float = bounds.height - currentHeight;
		
		switch( align ) {
			case Left:
				gameObject.transform.x = 0;
			case Right:
				gameObject.transform.x = bounds.x + diffX;
			case Center:
				gameObject.transform.x = bounds.x + (diffX * 0.5);
		}
		
		switch( verticalAlign ) {
			case Top:
				gameObject.transform.y = 0;
			case Bottom:
				gameObject.transform.y = bounds.y + diffY;
			case Center:
				gameObject.transform.y = bounds.y + (diffY * 0.5);
		}
						
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