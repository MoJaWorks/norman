package uk.co.mojaworks.norman.display;
import uk.co.mojaworks.norman.systems.renderer.Canvas;
import uk.co.mojaworks.norman.systems.renderer.shaders.DefaultFillShader;
import uk.co.mojaworks.norman.systems.renderer.shaders.ShaderData;
import uk.co.mojaworks.norman.utils.Color;

/**
 * ...
 * @author test
 */
class FillSprite extends Sprite
{
	
	public var color( default, default ) : Color;
	public var shader( default, default ) : ShaderData; 

	public function new( color : Color, width : Float, height : Float, id : String = null ) 
	{
		super( id );
		
		this.color = color;
		this.width = width;
		this.height = height;
	}
	
	override public function render(canvas:Canvas):Void 
	{
		
		trace("Render fillsprite");
		
		super.render(canvas);
		canvas.fillRect( width, height, transform.worldMatrix, color.r, color.g, color.b, color.a * finalAlpha, DefaultFillShader.ID );
	}
	
}