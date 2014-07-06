package uk.co.mojaworks.frameworkv2.components.display;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
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
	
	public function new( red : Float, green : Float, blue : Float, alpha : Float, width : Float = 0, height : Float = 0 ) 
	{
		
		super();
		
		this.red = red;
		this.green = green;
		this.blue = blue;
		this.alpha = alpha;
		this.width = width;
		this.height = height;
	}
	
	override public function getNaturalWidth() : Float {
		return width;
	}
	
	override public function getNaturalHeight() : Float {
		return height;
	}
	
	override public function render( canvas : ICanvas ) : Void {
		canvas.fillRect( red, green, blue, getFinalAlpha(), width, height, gameObject.transform.worldTransform );
	}
	
	
	
	
}