package uk.co.mojaworks.norman.systems.renderer.gl ;

import haxe.Json;
import lime.graphics.GLRenderContext;
import lime.graphics.Image;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLTexture;
import lime.graphics.RenderContext;
import uk.co.mojaworks.norman.systems.renderer.ITextureManager;

/**
 * ...
 * @author Simon
 */
class GLTextureManager implements ITextureManager
{

	private var _context : GLRenderContext;
	private var _textures : Map<String, GLTextureData> = null;
	
	/**
	 * 
	 * @param	context
	 */
	
	public function new( context : GLRenderContext ) 
	{
		_textures = new Map<String, GLTextureData>();
	}
	
	/**
	 * Creates a texture, also assigns a texture map in the form of a json string
	 * Given an id, it can be referenced multiple times while only loaded once
	 * 
	 * @param	data
	 * @param	map
	 */
	public function createTexture( id : String, image : Image, map : String = null ) : TextureData {
		
		var data : GLTextureData = new GLTextureData();
		data.id = id;
		data.sourceImage = image;
		if ( map != null ) data.map = Json.parse( map );
		if ( _context != null ) data.texture = uploadTexture( data );
		
		return data;
	}
	
	/**
	 * 
	 * @param	data
	 * @return
	 */
	
	private function uploadTexture( data : GLTextureData ) : GLTexture {
		
		var tex : GLTexture = _context.createTexture();
		
		_context.bindTexture( GL.TEXTURE_2D, tex );
		_context.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE );
		_context.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE );
		#if html5
			_context.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, GL.RGBA, GL.UNSIGNED_BYTE, data.sourceBitmap.src );
		#else
			_context.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, data.sourceImage.buffer.width, data.sourceImage.buffer.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, data.sourceImage.data );
		#end
		_context.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR );
		_context.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR );
		_context.bindTexture( GL.TEXTURE_2D, null );
		
		return tex;
	}
	
	/**
	 * 
	 */
	
	public function getTexture( id : String ) : GLTextureData {
		return _textures.get(id);
	}
	
	public function hasTexture( id : String ) : Bool {
		return (_textures.get(id) != null);
	}
	
}