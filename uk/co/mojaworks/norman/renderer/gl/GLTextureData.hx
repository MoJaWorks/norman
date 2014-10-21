package uk.co.mojaworks.norman.renderer.gl;

import lime.graphics.Image;
import lime.graphics.opengl.GLTexture;

/**
 * ...
 * @author Simon
 */
class GLTextureData
{

	public var sourceImage : Image;
	public var map : Dynamic; // Interpreted JSON object
	public var texture : GLTexture;
	
	public function new() 
	{
		
	}
	
}