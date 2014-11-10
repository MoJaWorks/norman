package uk.co.mojaworks.norman.systems.renderer.gl;
import lime.graphics.GLRenderContext;
import lime.graphics.Image;
import lime.graphics.ImageBuffer;
import lime.utils.UInt8Array;
import uk.co.mojaworks.norman.systems.renderer.gl.GLCanvas;
import uk.co.mojaworks.norman.systems.renderer.gl.GLShaderProgram;
import uk.co.mojaworks.norman.systems.renderer.IRenderer;
import uk.co.mojaworks.norman.systems.renderer.shaders.IShaderProgram;
import uk.co.mojaworks.norman.systems.renderer.shaders.ShaderData;
import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * ...
 * @author Simon
 */
 
 
class GLRenderer implements IRenderer
{	
	
	// Keep a cache of shaders so if the context is lost they can all be recreated quickly.
	private var _shaders : LinkedList<GLShaderProgram>;
	private var _textures : Map<String, GLTextureData>;
	
	public var canvas : GLCanvas;
	
	public function new( context : GLRenderContext ) 
	{
		canvas = new GLCanvas();
		canvas.init( context );
	}
	
	/**
	 * 
	 */
	
	public function resize( width : Int, height : Int ) : Void {
		canvas.resize( width, height );
	}
	
		
	/**
	 * 	Shaders - native / stage3d only
	 */
	
	public function createShader( vs : ShaderData, fs : ShaderData ) : IShaderProgram {
		
		var shader GLShaderProgram = new GLShaderProgram( vs, fs );
		
		if ( canvas.getContext() != null ) {
			shader.compile( canvas.getContext() ); 
		}
		#if debug
			else {
				trace("Deferred creating shader until context is restored");
			}
		#end
		
		_shaders.push( shader );
		return shader;
	}
	
	/**
	 * Textures
	 */
	
	//public function createTexture( id : String, width : Int, height : Int ) : TextureData {
		//
		//var data : GLTextureData = new GLTextureData();
		//data.id = id;
		//data.sourceImage = new Image( new ImageBuffer( new UInt8Array( width * height * 4 ), width, height ), 0, 0, width, height );
		//data.texture = uploadTexture( data );
		//
		//return data;
		//
	//}
	//
	/**
	 * Creates a texture, also assigns a texture map in the form of a json string
	 * Given an id, it can be referenced multiple times while only loaded once
	 * 
	 * @param	data
	 * @param	map
	 */
	//public function createTextureFromImage( id : String, image : Image, map : String = null ) : TextureData {
		//
		//var data : GLTextureData = new GLTextureData();
		//data.id = id;
		//data.sourceImage = image;
		//if ( map != null ) data.map = Json.parse( map );
		//if ( _context != null ) data.texture = uploadTexture( data );
		//
		//return data;
	//}
	
	//public function removeTexture( id : String ) : Void {
		//
		//var data : GLTextureData = getTexture(id);
		//_context.deleteTexture( data.texture );
		//_textures.remove( id );
		//
	//}
	
	/**
	 * 
	 * @param	data
	 * @return
	 */
	
	//private function uploadTexture( data : GLTextureData ) : GLTexture {
		//
		//var tex : GLTexture = _context.createTexture();
		//
		//_context.bindTexture( GL.TEXTURE_2D, tex );
		//_context.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE );
		//_context.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE );
		//#if html5
			//_context.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, GL.RGBA, GL.UNSIGNED_BYTE, data.sourceBitmap.src );
		//#else
			//_context.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, data.sourceImage.buffer.width, data.sourceImage.buffer.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, data.sourceImage.data );
		//#end
		//_context.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR );
		//_context.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR );
		//_context.bindTexture( GL.TEXTURE_2D, null );
		//
		//return tex;
	//}
	
	/**
	 * 
	 */
	
	//public function getTexture( id : String ) : GLTextureData {
		//return _textures.get(id);
	//}
	//
	//public function hasTexture( id : String ) : Bool {
		//return (_textures.get(id) != null);
	//}
	
}