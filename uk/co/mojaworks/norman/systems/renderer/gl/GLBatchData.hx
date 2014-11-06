package uk.co.mojaworks.norman.systems.renderer.gl;
import lime.graphics.opengl.GLTexture;

/**
 * ...
 * @author Simon
 */
class GLBatchData
{

	public var start : Int;
	public var length : Int;
	public var shader : GLShaderProgram;
	public var texture : GLTexture;
	public var target : GLTexture;
	
	public function new() 
	{
		
	}
	
}