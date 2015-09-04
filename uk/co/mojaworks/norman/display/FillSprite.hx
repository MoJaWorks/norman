package uk.co.mojaworks.norman.display;
import uk.co.mojaworks.norman.systems.renderer.Canvas;
import uk.co.mojaworks.norman.systems.renderer.ShaderAttributeData;
import uk.co.mojaworks.norman.systems.renderer.ShaderData;
import uk.co.mojaworks.norman.systems.Systems;
import uk.co.mojaworks.norman.utils.Color;
import uk.co.mojaworks.norman.utils.ShaderUtils;

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
			
			var atts : Array<ShaderAttributeData> = [
				new ShaderAttributeData( "aVertexPosition", 0, 2 ),
				new ShaderAttributeData( "aVertexColor", 2, 4 ),
			];
			
			FillSprite.defaultShader = Systems.renderer.createShader( ShaderUtils.getDefaultFillVertexSource(), ShaderUtils.getDefaultFillFragSource(), atts );
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
		
		shouldRenderSelf = true;
	}
	
	override public function render(canvas:Canvas):Void 
	{
		super.render( canvas );
		//canvas.fillRect( width, height, renderMatrix, color.r, color.g, color.b, color.a * finalAlpha, FillSprite.defaultShader );
		
		canvas.draw( null, FillSprite.defaultShader, canvas.buildQuadVertexData( width, height, renderMatrix, color.r, color.g, color.b, color.a * finalAlpha ), Canvas.QUAD_INDICES );
	}
	
}