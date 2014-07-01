package uk.co.mojaworks.frameworkv2.components.display ;

import openfl.geom.Rectangle;
import uk.co.mojaworks.frameworkv2.core.Component;
import uk.co.mojaworks.frameworkv2.renderer.ICanvas;

/**
 * ...
 * @author Simon
 */
class Display extends Component
{

	public var alpha : Float = 1;
	public var visible : Bool = true;
	public var clipRect : Rectangle = null;
	
	public function new() 
	{
		super();
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
	
	public function render( canvas : ICanvas ) : Void {
		canvas.fillRect( width, height, getFinalAlpha, gameObject.transform.globalTransform );
	}

	
}