package uk.co.mojaworks.norman.components.display ;

import openfl.geom.Point;
import openfl.geom.Rectangle;
import uk.co.mojaworks.norman.core.Component;
import uk.co.mojaworks.norman.core.GameObject;
import uk.co.mojaworks.norman.renderer.ICanvas;

/**
 * ...
 * @author Simon
 */
class Display extends Component
{

	public var alpha : Float = 1;
	public var visible : Bool = true;
	public var clipRect : Rectangle = null;
	public var bounds( get, never ) : Rectangle;
	
	private var _bounds : Rectangle;	
	private var _isBoundsDirty : Bool = true;
	
	public function new() 
	{
		super();
		_bounds = new Rectangle();
	}
	
	override public function onAdded():Void 
	{
		super.onAdded();
		gameObject.messenger.attachListener( Transform.MATRIX_DIRTY, onMatricesDirty );
	}
	
	override public function onRemoved():Void 
	{
		super.onRemoved();
		gameObject.messenger.removeListener( Transform.MATRIX_DIRTY, onMatricesDirty );
	}
	
	private function onMatricesDirty( object : GameObject, param : Dynamic = null ) : Void {
		invalidateBounds();
	}
	
	private function invalidateBounds( fromParent : Bool = false ) : Void {
		
		_isBoundsDirty = true;
		
		if ( !fromParent && gameObject.parent != null && gameObject.parent.display != null ) {
			gameObject.parent.display.invalidateBounds();
		}
		
		for ( child in gameObject.children ) {
			if ( child.display != null ) {
				child.display.invalidateBounds( true );
			}
		}
	}
	
	public function get_bounds() : Rectangle {
		if ( _isBoundsDirty ) {
			recalculateBounds();
		}
		return _bounds;
	}
	
	private function recalculateBounds() : Void {
		
		var xMin : Float = Math.POSITIVE_INFINITY;
		var xMax : Float = Math.NEGATIVE_INFINITY;
		var yMin : Float = Math.NEGATIVE_INFINITY;
		var yMax : Float = Math.POSITIVE_INFINITY;
				
		var pts : Array<Point> = [
			gameObject.transform.worldTransform.transformPoint( new Point( 0, 0 ) ),
			gameObject.transform.worldTransform.transformPoint( new Point( 0, getNaturalHeight() ) ),
			gameObject.transform.worldTransform.transformPoint( new Point( getNaturalWidth(), getNaturalHeight() ) ),
			gameObject.transform.worldTransform.transformPoint( new Point( getNaturalWidth(), 0 ) )
		];
		
		// Bounds of own display
		for ( pt in pts ) {
			if ( pt.x < xMin ) xMin = pt.x;
			if ( pt.x > xMax ) xMax = pt.x;
			if ( pt.y < yMin ) yMin = pt.y;
			if ( pt.y > yMax ) yMax = pt.y;
		}	
		
		// Bounds including children		
		for ( child in gameObject.children ) {
			if ( child.display != null ) {
				if ( child.display.bounds.left < xMin ) xMin = child.display.bounds.left;
				if ( child.display.bounds.right > xMax ) xMax = child.display.bounds.right;
				if ( child.display.bounds.top < yMin ) yMin = child.display.bounds.top;
				if ( child.display.bounds.bottom > yMax ) yMax = child.display.bounds.bottom;
			}
		}
		
		// Account for clippingRect
		
		
		_bounds.x = xMin;
		_bounds.y = yMin;
		_bounds.width = xMax - xMin;
		_bounds.height = yMax - yMin;	
		
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