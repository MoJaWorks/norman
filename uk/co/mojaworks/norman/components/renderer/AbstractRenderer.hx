package uk.co.mojaworks.norman.components.renderer;
import uk.co.mojaworks.norman.components.Component;
import uk.co.mojaworks.norman.systems.renderer.Canvas;
import uk.co.mojaworks.norman.systems.Systems;

/**
 * Incomplete/Abstract class should not be instantiated
 * @author Simon
 */

class AbstractRenderer extends Component
{
	public static inline var TYPE : String = "Renderer";
	
	public var shouldRenderChildren( default, default ) : Bool = true;
	public var visible( default, default ) : Bool = true;
	public var alpha( default, default ) : Float = 1;
		
	public function preRender( canvas : Canvas ) : Void {};
	public function render( canvas : Canvas ) : Void {};
	public function postRender( canvas : Canvas ) : Void {};
	public function dispose() : Void {};
	
	public function getWidth() : Float { return 0; };
	public function getHeight() : Float { return 0; };
	
	public function new( subtype : String ) { 
		super( subtype, TYPE );
	}
	
	/**
	 * Shared functions
	 * @return
	 */
	public function getCompositeAlpha() : Float {
		
		var transform : Transform = gameObject.transform;
		
		while ( transform != null ) {
			
			if ( transform.parent != null ) {
				var parentRenderer : AbstractRenderer = cast transform.parent.gameObject.renderer;
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
	
}