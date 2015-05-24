package uk.co.mojaworks.norman.display;
import uk.co.mojaworks.norman.systems.renderer.Canvas;
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
			trace("Creating default image shader");
			RenderSprite.defaultShader = Systems.renderer.createShader( ShaderUtils.getDefaultImageVertexSource(), ShaderUtils.getDefaultRenderTextureFragSource() );
		}
		return RenderSprite.defaultShader;
	}
	
	public var target : TextureData;
	
	public function new( width : Int, height : Int ) 
	{
		super();
		shouldRenderSelf = true;
		
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
		//canvas.drawTexture( target, transform.worldMatrix, 255, 255, 255, 1, RenderSprite.defaultShader );
	}
	
}