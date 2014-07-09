package uk.co.mojaworks.norman.components.display;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import uk.co.mojaworks.norman.renderer.ICanvas;

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
	
	public function new( colour : Int, alpha : Float, width : Float = 0, height : Float = 0 ) 
	{
		
		super();
		
		this.red = (colour & 0xFF0000) >> 4;
		this.green = (colour & 0x00FF00) >> 2;
		this.blue = (colour & 0x0000FF);
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