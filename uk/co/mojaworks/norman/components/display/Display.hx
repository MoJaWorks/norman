package uk.co.mojaworks.norman.components.display ;

import openfl.geom.Point;
import openfl.geom.Rectangle;
import uk.co.mojaworks.norman.core.Component;
import uk.co.mojaworks.norman.core.GameObject;
import uk.co.mojaworks.norman.renderer.ICanvas;
import uk.co.mojaworks.norman.utils.MathUtils;

/**
 * ...
 * @author Simon
 */
class Display extends Component
{

	public var alpha : Float = 1;
	public var visible : Bool = true;
	public var clipRect : Rectangle = null;
	
	private var _isBoundsDirty : Bool = true;
	
	public function new() 
	{
		super();
	}
	
	override public function onAdded():Void 
	{
		super.onAdded();
	}
			
	/**
	 * Gets the bounds of one object in the space of another. If no space is passed, it will get it's bounds in it's own space
	 * @param	space
	 * @return
	 */
	public function getBounds( space : Transform = null ) : Rectangle {
		
		// Get the total bounds in this coordinate space with children and clippingRect applied
		var bounds : Rectangle = getTotalBounds( gameObject.transform );
				
		// Transform to the target coordinate space
		if ( space != null && space != gameObject.transform ) {
			
			MathUtils.transformRect( bounds, gameObject.transform.worldTransform );
			MathUtils.transformRect( bounds, space.inverseWorldTransform );
			
		}
			//var pts : Array<Point> = [
				//space.globalToLocal( gameObject.transform.localToGlobal( new Point( bounds.left, bounds.top ) ) ),
				//space.globalToLocal( gameObject.transform.localToGlobal( new Point( bounds.left, bounds.bottom ) ) ),
				//space.globalToLocal( gameObject.transform.localToGlobal( new Point( bounds.right, bounds.bottom ) ) ),
				//space.globalToLocal( gameObject.transform.localToGlobal( new Point( bounds.right, bounds.top ) ) )
				//
				////bounds.transform
			//];
			//
			//var xMin : Float = Math.NEGATIVE_INFINITY;
			//var xMax : Float = Math.POSITIVE_INFINITY;
			//var yMin : Float = Math.NEGATIVE_INFINITY;
			//var yMax : Float = Math.POSITIVE_INFINITY;
			//
			//for ( pt in pts ) {
				//if ( pt.x < xMin ) xMin = pt.x;
				//if ( pt.x > xMax ) xMax = pt.x;
				//if ( pt.x < yMin ) yMin = pt.y;
				//if ( pt.x > yMax ) yMax = pt.y;
			//}
					
			//return new Rectangle( xMin, yMin, xMax - xMin, yMax - yMin );
			
		//}else {
			return bounds;
		//}
		
	}
	
	private function getTotalBounds( space : Transform ) : Rectangle {
		
		var bounds : Rectangle = new Rectangle( 0, 0, getNaturalWidth(), getNaturalHeight() );
		//var xMin : Float = 0;
		//var xMax : Float = getNaturalWidth();
		//var yMin : Float = 0;
		//var yMax : Float = getNaturalHeight();
		
		// Get own bounds in this space
		if ( space != gameObject.transform ) {
			
			MathUtils.transformRect( bounds, gameObject.transform.worldTransform );
			MathUtils.transformRect( bounds, space.inverseWorldTransform );
			
			//var pts : Array<Point> = [
				//space.globalToLocal( gameObject.transform.localToGlobal( new Point( 0, 0 ) ) ),
				//space.globalToLocal( gameObject.transform.localToGlobal( new Point( 0, getNaturalHeight() ) ) ),
				//space.globalToLocal( gameObject.transform.localToGlobal( new Point( getNaturalWidth(), getNaturalHeight() ) ) ),
				//space.globalToLocal( gameObject.transform.localToGlobal( new Point( getNaturalWidth(), 0 ) ) ),
			//];
			//
			//for ( pt in pts ) {
				//if ( pt.x < xMin ) xMin = pt.x;
				//if ( pt.x > xMax ) xMax = pt.x;
				//if ( pt.x < yMin ) yMin = pt.y;
				//if ( pt.x > yMax ) yMax = pt.y;
			//}
		}
				
		//var childBounds : Rectangle;
		
		// Adjust min and max for children
		for ( child in gameObject.children ) {
			if ( child.display != null ) {
				bounds = bounds.union( child.display.getTotalBounds( space ) );
				//childBounds = child.display.getTotalBounds( space );
				//if ( childBounds.left < xMin ) xMin = childBounds.left;
				//if ( childBounds.right > xMax ) xMax = childBounds.right;
				//if ( childBounds.top < yMin ) yMin = childBounds.top;
				//if ( childBounds.bottom > yMax ) yMax = childBounds.bottom;
			}
		}
		
		if ( clipRect != null ) {
			return bounds.intersection( clipRect );
			//return new Rectangle( Math.max( xMin, clipRect.x ), Math.max( yMin, clipRect.y ), Math.min( xMax - xMin, clipRect.right ), Math.min( yMax - yMin, clipRect.bottom ) );
		}else {
			return bounds;
			//return new Rectangle( xMin, yMin, xMax - xMin, yMax - yMin );
		}
		
	}
	
	public function getNaturalWidth() : Float {
		return 0;
	}
	
	public function getNaturalHeight() : Float {
		return 0;
	}
	
	public function getFinalAlpha() : Float {
		if ( gameObject.parent != null ) {
			return gameObject.parent.get(Display).getFinalAlpha() * alpha;
		}else {
			return alpha;
		}
	}
	
	
	public function preRender( canvas : ICanvas ) : Void {
		if ( clipRect != null ) canvas.pushMask( clipRect, gameObject.transform.worldTransform );
	}
	
	public function render( canvas : ICanvas ) : Void {
		// Override to render content
	}
	
	public function postRender( canvas : ICanvas ) : Void {
		if ( clipRect != null ) canvas.popMask();
	}
	
}