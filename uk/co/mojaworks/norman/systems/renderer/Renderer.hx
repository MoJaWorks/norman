package uk.co.mojaworks.norman.systems.renderer;
import lime.graphics.Image;
import lime.graphics.RenderContext;
import uk.co.mojaworks.norman.display.Sprite;
import uk.co.mojaworks.norman.systems.renderer.Canvas;
import uk.co.mojaworks.norman.systems.renderer.ShaderData;
import uk.co.mojaworks.norman.systems.renderer.ShaderManager;
import uk.co.mojaworks.norman.systems.renderer.TextureManager;
import uk.co.mojaworks.norman.utils.Color;

/**
 * ...
 * @author test
 */
class Renderer
{

	public var clearColor : Color = Color.BLACK;
	
	public var canvas( default, null ) : Canvas;
	public var shaderManager( null, null ) : ShaderManager;
	public var textureManager( null, null ) : TextureManager;
	
	//////////////
	///  INIT
	/////////////
	
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
				
				textureManager = new TextureManager();
				textureManager.init();
				textureManager.onContextCreated( gl );
				
			case FLASH(sprite):
				// TODO: Set up Stage3D  render system (eventually, maybe never)
			case CANVAS(context):
				// TODO: Set up canvas render system (never)
			case DOM(context):
				// TODO: Set up DOM render system (never)
			default:
		}
		
	}
	
	//////////////
	///  RENDER
	/////////////
	
	public function render( root : Sprite ) : Void {
		
		//trace("Render begin");
		canvas.clear( clearColor );
		
		canvas.begin();
			renderLevel( root );
		canvas.end();
	}
	
	private function renderLevel( sprite : Sprite ) : Void {
		
		//trace("Rendering level starting at", sprite.transform.x, sprite.transform.y );
		
		if ( sprite.shouldRenderSelf )	sprite.preRender( canvas );
		
		// Check again incase this changes in preRender function
		if ( sprite.shouldRenderSelf ) sprite.render( canvas );
		
		if ( sprite.shouldRenderChildren ) {
			for ( child in sprite.children ) {
				renderLevel( child );
			}
		}
		
		if ( sprite.shouldRenderSelf ) sprite.postRender( canvas );
	}
	
	//////////////
	///  TEXTURES
	/////////////
	
	public function createTextureFromAsset( id : String ) : TextureData {
		return textureManager.createTextureFromAsset( id );
	}
	
	public function createTextureFromImage( id : String, image : Image, map : Dynamic = null ) : TextureData {
		return textureManager.createTextureFromImage( id, image, map );
	}
	
	public function createTexture( id : String, width : Float, height : Float, fill : Color ) : TextureData {
		return textureManager.createTexture( id, width, height, fill );
	}
	
	
	//////////////
	///  SHADERS
	/////////////
	
	/**
	 * Create a shader to use in drawer operations
	 * @param	vertexSource
	 * @param	fragmentSource
	 * @return
	 */
	
	public function createShader( vertexSource : String, fragmentSource : String ) : ShaderData {
		return shaderManager.createShader( vertexSource, fragmentSource );
	}
	
}