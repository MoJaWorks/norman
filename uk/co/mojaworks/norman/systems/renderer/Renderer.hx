package uk.co.mojaworks.norman.systems.renderer;
import lime.graphics.opengl.GLShader;
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

	private var _canvas : Canvas;
	
	public var shaderManager( default, null ) : ShaderManager;
	public var textureManager( default, null ) : GLTextureManager;
	
	public function new() {
		textureManager = new TextureManager();
	}
	
	public function init( context : RenderContext ) 
	{
		
		switch (context) 
		{
			case OPENGL(gl):
				// TODO: Set up GL render system (main focus)
				var glCanvas : Canvas = new Canvas();
				glCanvas.init( gl );
				_canvas = glCanvas;
				
				var shaderManager : ShaderManager = new ShaderManager();
				shaderManager.init( );
				shaderManager.onContextCreated( gl );
				this.shaderManager = shaderManager;
				
			case FLASH(sprite):
				// TODO: Set up Stage3D  render system (eventually)
			case CANVAS(context):
				// TODO: Set up canvas render system (eventually)
			case DOM(context):
				// TODO: Set up DOM render system (eventually)
			default:
		}
		
	}
	
}