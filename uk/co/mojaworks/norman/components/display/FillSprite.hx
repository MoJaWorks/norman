package uk.co.mojaworks.norman.components.display;
import uk.co.mojaworks.norman.components.renderer.ICanvas;
import uk.co.mojaworks.norman.systems.renderer.shaders.ShaderData;
import uk.co.mojaworks.norman.utils.Color;

/**
 * ...
 * @author Simon
 */
class FillSprite extends Sprite
{

	public var color( default, default ) : Color;
	public var width( default, default ) : Float;
	public var height( default, default ) : Float;
	
	public function new( color : Int, width : Float = 100, height : Float = 100 ) 
	{
		
		super();
		isRenderable = true;
		this.color = color;
		this.width = width;
		this.height = height;
		
		createShader();
	}
	
	private function createShader() {
		shader = new DefaultFillShader();
	}
	
	public function setSize( width : Float, height : Float ) : FillSprite {
		this.width = width;
		this.height = height;
		return this;
	}
	
	public function setColor( color : Int ) : FillSprite {
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
		canvas.fillRect( color.r, color.g, color.b, getFinalAlpha() * color.a, width, height, gameObject.transform.worldTransform );
	}
	
	
	
	
}