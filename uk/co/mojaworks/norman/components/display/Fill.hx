package uk.co.mojaworks.norman.components.display;
import uk.co.mojaworks.norman.renderer.ICanvas;
import uk.co.mojaworks.norman.utils.ColourUtils;

/**
 * ...
 * @author Simon
 */
class Fill extends Display
{

	public var r : Float;
	public var g : Float;
	public var b : Float;
	public var a : Float; // a is separate to alpha so it doesn't affect children
	public var width( default, default ) : Float;
	public var height( default, default ) : Float;
	
	public function new( colour : Int, alpha : Float, width : Float = 0, height : Float = 0 ) 
	{
		
		super();
		
		this.r = ColourUtils.r( colour );
		this.g = ColourUtils.g( colour );
		this.b = ColourUtils.b( colour );
		this.a = alpha;
		this.width = width;
		this.height = height;
	}
	
	public function setSize( width : Float, height : Float ) : Fill {
		this.width = width;
		this.height = height;
		return this;
	}
	
	override public function getNaturalWidth() : Float {
		return width;
	}
	
	override public function getNaturalHeight() : Float {
		return height;
	}
	
	override public function render( canvas : ICanvas ) : Void {
		canvas.fillRect( r, g, b, getFinalAlpha() * a, width, height, gameObject.transform.renderTransform );
	}
	
	
	
	
}