package uk.co.mojaworks.norman.renderer.gl;

import lime.graphics.GLRenderContext;
import lime.graphics.Image;
import lime.graphics.opengl.GL;
import lime.graphics.RenderContext;
import uk.co.mojaworks.norman.renderer.ITextureManager;

/**
 * ...
 * @author Simon
 */
class GLTextureManager implements ITextureManager
{

	private var _textures : Map<String, GLTextureData>;
	private var _context : GLRenderContext;
	
	public function new( context : GLRenderContext ) 
	{
	}
	
	/**
	 * Creates a texture, also assigns a texture map in the form of a json string
	 * Given an id, it can be referenced multiple times while only loaded once
	 * 
	 * @param	data
	 * @param	map
	 */
	public function createTexture( id : String, data : Image, map : String = null ) : ITextureData {
		
		_context.createTexture();
		return null;
	}
	
}