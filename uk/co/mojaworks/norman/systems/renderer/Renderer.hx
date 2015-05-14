package uk.co.mojaworks.norman.systems.renderer;
import lime.graphics.RenderContext;
import lime.math.Matrix3;
import uk.co.mojaworks.norman.geom.Transform;
import uk.co.mojaworks.norman.systems.renderer.Canvas;
import uk.co.mojaworks.norman.systems.renderer.ShaderManager;
import uk.co.mojaworks.norman.systems.renderer.shaders.DefaultFillShader;
import uk.co.mojaworks.norman.systems.renderer.TextureManager;
import uk.co.mojaworks.norman.utils.Color;

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
	
	public function render() : Void {
		
		canvas.begin();
		
		var transform : Transform = new Transform();
		transform.x = 100;
		transform.y = 100;
		
		canvas.fillRect( 100, 100, Color.rgb( 255, 0, 0 ), transform.worldMatrix, DefaultFillShader.ID );
		canvas.end();
	}
	
}