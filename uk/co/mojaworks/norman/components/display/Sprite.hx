package uk.co.mojaworks.norman.components.display ;

import lime.math.Matrix4;
import uk.co.mojaworks.norman.core.Component;
import uk.co.mojaworks.norman.core.Messenger.MessageData;
import uk.co.mojaworks.norman.core.view.GameObject;
import uk.co.mojaworks.norman.systems.renderer.ICanvas;
import uk.co.mojaworks.norman.systems.renderer.shaders.IShaderProgram;

/**
 * ...
 * @author Simon
 */
class Sprite extends Component
{
		
	public var alpha : Float = 1;
	public var visible : Bool = true;
	
	public var anchorX( default, set ) : Float = 0;
	public var anchorY( default, set ) : Float = 0;
	public var anchorZ( default, set ) : Float = 0;
	
	public var paddingX( default, set ) : Float = 0;
	public var paddingY( default, set ) : Float = 0;
	
	public var renderTransform( get, never ) : Matrix4;
	private var _renderTransform : Matrix4;
	private var _renderTransformDirty : Bool = true;
	
	public function new( ) 
	{
		super( );
		initShader();
		_renderTransform = new Matrix4();
	}
	
	private function initShader() {
		// Initialise the shader
	}
	
	public function getShader() : IShaderProgram {
		// override and return the current shader
		return null;
	}
	
	override public function onAdded() : Void {
		addLocalMessageListener( Transform.MATRIX_DIRTY, invalidateMatrices );
	}
	
	override public function onRemoved() : Void {
		removeLocalMessageListener( Transform.MATRIX_DIRTY, invalidateMatrices );
	}
	
	private function invalidateMatrices( data : MessageData = null ) : Void 
	{
		_renderTransformDirty = true;
	}
	
	private function recalculateRenderTransform() : Void {
		_renderTransform = gameObject.transform.worldTransform.clone();
		_renderTransform.prependTranslation( paddingX - anchorX, paddingY - anchorY, -anchorZ );
		_renderTransformDirty = false;
	}

	/**
	 * Gets the bounds of one object in the space of another. If no space is passed, it will get it's bounds in it's own space
	 * @param	space
	 * @return
	 */
	//public function getBounds( space : GameObject = null ) : Rectangle {
		//
		//// Get the total bounds in this coordinate space with children and clippingRect applied
		//var bounds : Rectangle = getTotalBounds( gameObject );
		//
		//// Transform to the target coordinate space
		//if ( space != null && space != gameObject ) {
			//MathUtils.transformRect( bounds, gameObject.transform.worldTransform );
			//MathUtils.transformRect( bounds, space.transform.inverseWorldTransform );
		//}
//
		//return bounds;
		//
	//}
	
	//private function getTotalBounds( space : GameObject ) : Rectangle {
		//
		//var bounds : Rectangle = new Rectangle( 0, 0, getNaturalWidth(), getNaturalHeight() );
				//
		//// Get own bounds in this space
		//if ( space != gameObject ) {
			//MathUtils.transformRect( bounds, gameObject.transform.worldTransform );
			//MathUtils.transformRect( bounds, space.transform.inverseWorldTransform );
		//}
				//
		//// Adjust min and max for children
		//for ( child in gameObject.children ) {
			//if ( child.display != null ) {
				//bounds = bounds.union( child.display.getTotalBounds( space ) );
			//}
		//}
		//
		//// Clip if necessary
		//if ( clipRect != null ) {
			//return bounds.intersection( clipRect );
		//}else {
			//return bounds;
		//}
		//
	//}
	
	//public function hitTestPoint( global : Vector2 ) : Bool {
		//return getBounds().containsPoint( gameObject.transform.globalToLocal( global ) );
	//}
	
	public function getNaturalWidth() : Float {
		return 0;
	}
	
	public function getNaturalHeight() : Float {
		return 0;
	}
	
	public function getScaledWidth() : Float {
		return getNaturalWidth() * gameObject.transform.scaleX;
	}
	
	public function getScaledHeight() : Float {
		return getNaturalHeight() * gameObject.transform.scaleY;
	}
	
	public function getFinalAlpha() : Float {
		if ( gameObject.parent != null && gameObject.parent.sprite != null ) {
			return gameObject.parent.sprite.getFinalAlpha() * alpha;
		}else {
			return alpha;
		}
	}
	
	public function getVisibleInTree() : Bool {
		if ( gameObject.parent != null && gameObject.parent.sprite != null) {
			return visible && gameObject.parent.sprite.visible;
		}else {
			return visible;
		}
	}
		
	/**
	 * Pre-render returns whether this object and it's children should be rendered
	 * Can also perform canvs tasks prior to rendering an item and it's children
	 * @param	canvas
	 * @return
	 */ 
	public function preRender( canvas : ICanvas ) : Bool {
		return visible && (getFinalAlpha() > 0);
	}
	
	/**
	 * Render renders this item. This usually happens before all of it's children have been rendered
	 * @param	canvas
	 * @return
	 */ 
	public function render( canvas : ICanvas ) : Void {
		// Override to render content
	}
	
	/**
	 * Post render happens after all children have been rendered
	 * @param	canvas
	 * @return
	 */ 
	public function postRender( canvas : ICanvas ) : Void {
		// Override 
	}
		
	/**
	 * Centers the pivot based on the display
	 */
	
	public function centerAnchor() : Sprite {
		setAnchor( getNaturalWidth() * 0.5, getNaturalHeight() * 0.5 );
		return this;
	}
	
	public function setAnchor( x : Float, y : Float, z : Float = 0 ) : Sprite {
		anchorX = x;
		anchorY = y;
		anchorZ = z;
		return this;
	}
	
	public function setPadding( x : Float, y : Float ) : Sprite {
		paddingX = x;
		paddingY = y;
		return this;
	}
	
	/**
	 * Transform
	 */
	
	public function get_renderTransform() : Matrix4 { 
		if ( _renderTransformDirty ) recalculateRenderTransform();
		return _renderTransform;
	}
	 
	private function set_anchorX( _anchorX : Float ) : Float { anchorX = _anchorX; invalidateMatrices(); return anchorX; }
	private function set_anchorY( _anchorY : Float ) : Float { anchorY = _anchorY; invalidateMatrices(); return anchorY; }
	private function set_anchorZ( _anchorZ : Float ) : Float { anchorZ = _anchorZ; invalidateMatrices(); return anchorZ; }
	private function set_paddingX( _paddingX : Float ) : Float { paddingX = _paddingX; invalidateMatrices(); return paddingX; }
	private function set_paddingY( _paddingY : Float ) : Float { paddingY = _paddingY; invalidateMatrices(); return paddingY; }
			
}