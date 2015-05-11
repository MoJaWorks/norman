package uk.co.mojaworks.norman.systems.renderer;
import lime.graphics.RenderContext;
import uk.co.mojaworks.norman.systems.renderer.Canvas;
import uk.co.mojaworks.norman.systems.renderer.ShaderManager;
import uk.co.mojaworks.norman.systems.renderer.TextureManager;

/**
 * ...
 * @author test
 */
class Renderer
{

	public var canvas( default, null ) : Canvas;
	public var shaderManager( default, null ) : ShaderManager;
	public var textureManager( default, null ) : TextureManager;
	
	public function new() {
		textureManager = new TextureManager();
	}
	
	public function init( context : RenderContext ) 
	{
		
		switch (context) 
		{
			case OPENGL(gl):
				
				canvas = new Canvas();
				canvas.init( );
				canvas.onContextCreated( gl );
				
				shaderManager = new ShaderManager();
				shaderManager.init( );
				shaderManager.onContextCreated( gl );
				
			case FLASH(sprite):
				// TODO: Set up Stage3D  render system (eventually, maybe never)
			case CANVAS(context):
				// TODO: Set up canvas render system (never)
			case DOM(context):
				// TODO: Set up DOM render system (never)
			default:
		}
		
	}
	
}