package uk.co.mojaworks.norman.components.display ;

import lime.math.Rectangle;
import lime.math.Vector2;
import uk.co.mojaworks.norman.core.Component;
import uk.co.mojaworks.norman.core.GameObject;
import uk.co.mojaworks.norman.engine.NormanApp;
import uk.co.mojaworks.norman.systems.renderer.ICanvas;
import uk.co.mojaworks.norman.systems.renderer.shaders.IShaderProgram;
import uk.co.mojaworks.norman.systems.renderer.shaders.ShaderData;
import uk.co.mojaworks.norman.utils.MathUtils;

/**
 * ...
 * @author Simon
 */
class Sprite extends Component
{
		
	public var alpha : Float = 1;
	public var visible : Bool = true;
	public var isRenderable : Bool = false;
	
	public function new() 
	{
		super();
		initShader();
	}
	
	private function initShader() {
		// Initialise the shader
	}
	
	public function getShader() : IShaderProgram {
		// override and return the current shader
		return null;
	}
	
	override public function onAdded():Void 
	{
		super.onAdded();
		NormanApp.renderer.addSprite( this );
	}
	
	override public function onRemoved():Void 
	{
		super.onRemoved();
		NormanApp.renderer.removeSprite( this );
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
		if ( gameObject.transform.parent != null ) {
			return gameObject.transform.parent.gameObject.sprite.getFinalAlpha() * alpha;
		}else {
			return alpha;
		}
	}
	
	public function getVisibleInTree() : Bool {
		if ( gameObject.transform.parent != null ) {
			return visible && gameObject.transform.parent.gameObject.sprite.visible;
		}else {
			return visible;
		}
	}
		
	public function preRender( canvas : ICanvas ) : Void {
		
		//if ( clipRect != null ) {
			//if ( gameObject.parent != null ) {
				//var transform : Matrix = gameObject.transform.localTransform.clone();
				//transform.concat( gameObject.parent.transform.renderTransform );
				//canvas.pushMask( getBounds(), transform );
			//}else {
				//canvas.pushMask( getBounds(), gameObject.transform.renderTransform );
			//}
		//}
	}
	
	public function render( canvas : ICanvas ) : Void {
		// Override to render content
	}
	
	public function postRender( canvas : ICanvas ) : Void {
		//if ( clipRect != null ) canvas.popMask();
	}
	
	private function set_clipRect( rect : Rectangle ) : Rectangle {
		gameObject.transform.invalidateMatrices();
		this.clipRect = rect;
		return rect;
	}
		
}