package uk.co.mojaworks.norman.components.renderer;
import lime.math.Vector2;
import uk.co.mojaworks.norman.components.Component;
import uk.co.mojaworks.norman.core.renderer.Canvas;
import uk.co.mojaworks.norman.systems.Systems;
import uk.co.mojaworks.norman.utils.Color;

/**
 * Incomplete/Abstract class should not be instantiated
 * @author Simon
 */

class BaseRenderer extends Component
{
	
	public var shouldRenderChildren( default, default ) : Bool = true;
	public var visible( default, default ) : Bool = true;
	public var alpha( default, default ) : Float = 1;
	public var color( default, default ) : Color = Color.WHITE;
	public var width( get, set ) : Float;
	public var height( get, set ) : Float;
	public var scaledWidth( get, set ) : Float;
	public var scaledHeight( get, set ) : Float;
		
	public function preRender( canvas : Canvas ) : Void {};
	public function render( canvas : Canvas ) : Void {};
	public function postRender( canvas : Canvas ) : Void {};
	public function dispose() : Void {};
		
	public function new( ) { 
		super( );
	}
	
	/**
	 * Shared functions
	 * @return
	 */
	public function getCompositeAlpha() : Float {
		
		var transform : Transform = gameObject.transform;
		
		while ( transform != null ) {
			
			if ( transform.parent != null ) {
				var parentRenderer : BaseRenderer = cast transform.parent.gameObject.renderer;
				if ( parentRenderer != null ) {
					return parentRenderer.getCompositeAlpha() * alpha;
				}else {
					transform = transform.parent;
				}
			}else {
				return alpha;
			}
			
		}
		
		return alpha;

	}
	
	public function hitTest( global : Vector2 ) : Bool {
		var local : Vector2 = gameObject.transform.globalToLocal( global );
		return ( local.x >= 0 && local.x < width && local.y >= 0 && local.y < height );
	}
	
	private function get_width( ) : Float { return 0; }
	private function get_height( ) : Float { return 0; }
	
	private function set_width( val : Float ) : Float { trace("You cannot set height of this type of renderer"); return this.width; }
	private function set_height( val : Float ) : Float { trace("You cannot set height of this type of renderer"); return this.height; }
	
	inline private function get_scaledWidth() : Float 
	{
		return width * gameObject.transform.scaleX;
	}
	
	inline private function get_scaledHeight() : Float 
	{
		return height * gameObject.transform.scaleY;
	}
	
	inline private function set_scaledWidth( val : Float ) : Float 
	{
		if ( width > 0 ) {
			return gameObject.transform.scaleX = val / width;
		}else {
			return 0;
		}
	}
	
	inline private function set_scaledHeight( val : Float ) : Float 
	{
		if ( height > 0 ) {
			return gameObject.transform.scaleY = val / height;
		}else {
			return 0;
		}
	}
}