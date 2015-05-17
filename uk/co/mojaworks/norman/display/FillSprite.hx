package uk.co.mojaworks.norman.display;
import uk.co.mojaworks.norman.systems.renderer.Canvas;
import uk.co.mojaworks.norman.systems.renderer.shaders.DefaultFillShader;
import uk.co.mojaworks.norman.systems.renderer.shaders.ShaderData;
import uk.co.mojaworks.norman.systems.Systems;
import uk.co.mojaworks.norman.utils.Color;

/**
 * ...
 * @author test
 */
class FillSprite extends Sprite
{
	// Set up default shader
	public static var defaultShader( get, null ) : ShaderData = null;
	public static function get_defaultShader( ) : ShaderData {
		if ( FillSprite.defaultShader == null ) {
			trace("Creating default fill shader");
			FillSprite.defaultShader = Systems.renderer.createShader( new DefaultFillShader() );
		}
		return FillSprite.defaultShader;
	}
	
	public var color( default, default ) : Color;
	public var shader( default, default ) : ShaderData; 

	public function new( color : Color, width : Float, height : Float ) 
	{
		super( );
		
		this.color = color;
		this.width = width;
		this.height = height;
	}
	
	override public function render(canvas:Canvas):Void 
	{
		
		trace("Render fillsprite");
		
		super.render(canvas);
		canvas.fillRect( width, height, transform.worldMatrix, color.r, color.g, color.b, color.a * finalAlpha, FillSprite.defaultShader );
	}
	
}