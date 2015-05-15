package uk.co.mojaworks.norman.display;
import uk.co.mojaworks.norman.systems.renderer.Canvas;
import uk.co.mojaworks.norman.systems.renderer.shaders.ShaderData;
import uk.co.mojaworks.norman.utils.Color;

/**
 * ...
 * @author test
 */
class FillSprite extends Sprite
{
	
	public var color( default, default ) : Color;

	public function new( color : Color, width : Float, height : Float, id : String = null ) 
	{
		super( id );
		
		this.color = color;
		this.width = width;
		this.height = height;
	}
	
	override public function render(canvas:Canvas):Void 
	{
		super.render(canvas);
		canvas.fillRect( width, height, color.r, color.g, color.b, color.a * finalAlpha, transform.worldMatrix, ShaderData.DEFAULT_FILL );
	}
	
}