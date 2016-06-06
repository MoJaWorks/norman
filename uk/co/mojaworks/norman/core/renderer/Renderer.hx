package uk.co.mojaworks.norman.core.renderer;
import geoff.renderer.IRenderContext;
import geoff.renderer.Shader;
import geoff.renderer.Shader.ShaderAttribute;
import geoff.renderer.Texture;
import geoff.utils.Color;
import uk.co.mojaworks.norman.components.Transform;
import uk.co.mojaworks.norman.components.renderer.BaseRenderer;
import uk.co.mojaworks.norman.core.renderer.Canvas;
import uk.co.mojaworks.norman.core.renderer.ShaderManager;
import uk.co.mojaworks.norman.core.renderer.TextureManager;

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
	
	public function init( context : IRenderContext ) 
	{
		
		canvas = new Canvas();
		canvas.init( );
		canvas.onContextCreated( context );
		
		shaderManager = new ShaderManager();
		shaderManager.init( );
		shaderManager.onContextCreated( context );
		
		textureManager = new TextureManager();
		textureManager.init();
		textureManager.onContextCreated( context );
		
	}
	
	//////////////
	///  RENDER
	/////////////
	

	public function render( root : Transform ) : Void {
		
		//trace("Render begin");
		canvas.clear( clearColor );
		
		canvas.begin();
			renderLevel( root );
		canvas.end();
	}
	
	public function renderLevel( transform : Transform ) : Void {
		
		//trace("Rendering level starting at", sprite.transform.x, sprite.transform.y );
		
		if ( transform.gameObject.enabled ) {
		
			var sprite : BaseRenderer = transform.gameObject.renderer;
					
			if ( sprite != null ) 
			{
				sprite.preRender( canvas );
				if ( sprite.visible && sprite.getCompositeAlpha() > 0 ) {
					
					if ( sprite.color.a > 0 ) sprite.render( canvas );
					
					if ( sprite.shouldRenderChildren ) {
						for ( child in transform.children ) {
							renderLevel( child );
						}
					}
					
				}
				sprite.postRender( canvas );
			}
			else 
			{
				for ( child in transform.children ) {
					renderLevel( child );
				}
			}
		}
		
	}
	
	//////////////
	///  TEXTURES
	/////////////
	
	public function createTextureFromAsset( id : String ) : Texture {
		return textureManager.createTextureFromAsset( id );
	}
		
	public function unloadTexture( id : String ) : Void {
		return textureManager.unloadTexture( id );
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
	
	public function createShader( vertexSource : String, fragmentSource : String, attributes : Array<ShaderAttribute> ) : Shader {
		return shaderManager.createShader( vertexSource, fragmentSource, attributes );
	}
	
}