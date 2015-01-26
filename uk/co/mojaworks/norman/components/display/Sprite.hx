package uk.co.mojaworks.norman.components.display ;

import lime.math.Matrix3;
import lime.math.Matrix4;
import lime.math.Rectangle;
import lime.math.Vector2;
import uk.co.mojaworks.norman.core.Component;
import uk.co.mojaworks.norman.core.Messenger.MessageData;
import uk.co.mojaworks.norman.core.view.GameObject;
import uk.co.mojaworks.norman.systems.renderer.ICanvas;
import uk.co.mojaworks.norman.systems.renderer.shaders.IShaderProgram;
import uk.co.mojaworks.norman.utils.MathUtils;

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
	
	public var paddingX( default, set ) : Float = 0;
	public var paddingY( default, set ) : Float = 0;
	
	public var renderTransform( get, never ) : Matrix3;
	private var _renderTransform : Matrix3;
	private var _renderTransformDirty : Bool = true;
	
	public function new( ) 
	{
		super( );
		_renderTransform = new Matrix3();
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
		_renderTransform.identity();
		_renderTransform.translate( paddingX - anchorX, paddingY - anchorY );
		
		if ( gameObject.parent != null && gameObject.parent.transform.isRoot ) {
			_renderTransform.concat( gameObject.transform.localTransform );
		}else{
			_renderTransform.concat( gameObject.transform.worldTransform );
		}
		_renderTransformDirty = false;
	}
	
	public function hitTestPoint( global : Vector2 ) : Bool {
		return (new Rectangle( 0, 0, getNaturalWidth(), getNaturalHeight() )).containsPoint( gameObject.transform.globalToLocal( global ) );
	}
	
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
			if ( gameObject.parent.transform.isRoot ) {
				return gameObject.parent.sprite.alpha * alpha;
			}else {
				return gameObject.parent.sprite.getFinalAlpha() * alpha;
			}
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
	
	public function setAnchor( x : Float, y : Float ) : Sprite {
		anchorX = x;
		anchorY = y;
		//anchorZ = z;
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
	
	public function get_renderTransform() : Matrix3 { 
		if ( _renderTransformDirty ) recalculateRenderTransform();
		return _renderTransform;
	}
	 
	private function set_anchorX( _anchorX : Float ) : Float { anchorX = _anchorX; invalidateMatrices(); return anchorX; }
	private function set_anchorY( _anchorY : Float ) : Float { anchorY = _anchorY; invalidateMatrices(); return anchorY; }
	//private function set_anchorZ( _anchorZ : Float ) : Float { anchorZ = _anchorZ; invalidateMatrices(); return anchorZ; }
	private function set_paddingX( _paddingX : Float ) : Float { paddingX = _paddingX; invalidateMatrices(); return paddingX; }
	private function set_paddingY( _paddingY : Float ) : Float { paddingY = _paddingY; invalidateMatrices(); return paddingY; }
			
}