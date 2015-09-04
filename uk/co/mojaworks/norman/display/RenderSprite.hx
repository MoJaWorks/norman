package uk.co.mojaworks.norman.display;
import lime.graphics.opengl.GL;
import uk.co.mojaworks.norman.systems.renderer.Canvas;
import uk.co.mojaworks.norman.systems.renderer.ShaderAttributeData;
import uk.co.mojaworks.norman.systems.renderer.ShaderData;
import uk.co.mojaworks.norman.systems.renderer.TextureData;
import uk.co.mojaworks.norman.systems.Systems;
import uk.co.mojaworks.norman.utils.Color;
import uk.co.mojaworks.norman.utils.ShaderUtils;

/**
 * ...
 * @author Simon
 */
class RenderSprite extends Sprite
{

	public static var defaultShader( get, null ) : ShaderData = null;
	public static function get_defaultShader( ) : ShaderData {
		if ( RenderSprite.defaultShader == null ) {
			trace("Creating default render shader");
			
			var atts : Array<ShaderAttributeData> = [
				new ShaderAttributeData( "aVertexPosition", 0, 2 ),
				new ShaderAttributeData( "aVertexColor", 2, 4 ),
				new ShaderAttributeData( "aVertexUV", 6, 2 )
			];
			RenderSprite.defaultShader = Systems.renderer.createShader( ShaderUtils.getDefaultImageVertexSource(), ShaderUtils.getDefaultRenderTextureFragSource(), atts );
		}
		return RenderSprite.defaultShader;
	}
	
	public var target : TextureData;
	
	
	public function new( width : Int, height : Int ) 
	{
		super();
		shouldRenderSelf = true;
		isRoot = true;
		
		setSize( width, height );
	}
	
	public function setSize( width : Int, height : Int ) : Void {
		if ( target != null ) {
			Systems.renderer.unloadTexture( "@norman/renderSprite/" + id );
		}
		
		target = Systems.renderer.createTexture( "@norman/renderSprite/" + id, width, height, 0 );
	}
	
	override public function preRender(canvas:Canvas):Void 
	{
		super.preRender(canvas);
		canvas.pushRenderTarget( target );
		canvas.clear( 0 );
	}
	
	override public function postRender(canvas:Canvas):Void 
	{
		
		super.postRender(canvas);
		canvas.popRenderTarget();
		canvas.draw( [target], RenderSprite.defaultShader, canvas.buildTexturedQuadVertexData( target, Canvas.WHOLE_IMAGE, renderMatrix, 255, 255, 255, finalAlpha ), Canvas.QUAD_INDICES );
	}
	
}