package uk.co.mojaworks.norman.components.display;
import uk.co.mojaworks.norman.components.renderer.ICanvas;
import uk.co.mojaworks.norman.utils.Color;

/**
 * ...
 * @author Simon
 */
class Fill extends Display
{

	public var color( default, default ) : Color;
	public var width( default, default ) : Float;
	public var height( default, default ) : Float;
	
	public function new( color : Int, width : Float = 100, height : Float = 100 ) 
	{
		
		super();
		
		this.color = color;
		this.width = width;
		this.height = height;
	}
	
	public function setSize( width : Float, height : Float ) : Fill {
		this.width = width;
		this.height = height;
		return this;
	}
	
	public function setColor( color : Int ) : Fill {
		this.color = color;
		return this;
	}
	
	override public function getNaturalWidth() : Float {
		return width;
	}
	
	override public function getNaturalHeight() : Float {
		return height;
	}
	
	override public function render( canvas : ICanvas ) : Void {
		canvas.fillRect( color.r, color.g, color.b, getFinalAlpha() * color.a, width, height, gameObject.transform.renderTransform );
	}
	
	
	
	
}