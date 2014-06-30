package uk.co.mojaworks.frameworkv2.components.display;
import openfl.geom.ColorTransform;
import uk.co.mojaworks.frameworkv2.renderer.ICanvas;

/**
 * ...
 * @author Simon
 */
class Fill extends Display
{

	public var red : Float;
	public var green : Float;
	public var blue : Float;
	public var width( default, default ) : Float;
	public var height( default, default ) : Float;
	
	public function new( red : Float, green : Float, blue : Float, alpha : Float ) 
	{
		this.red = red;
		this.green = green;
		this.blue = blue;
		this.alpha = alpha;
	}
	
	override public function getNaturalWidth() : Float {
		return width;
	}
	
	override public function getNaturalHeight() : Float {
		return height;
	}
	
	public function render( canvas : ICanvas ) : Void {
		canvas.fillRect( width, height, getGlobalAlpha, gameObject.transform.globalTransform );
	}
	
	
	
	
}