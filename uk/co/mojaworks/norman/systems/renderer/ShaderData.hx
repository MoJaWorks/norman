package uk.co.mojaworks.norman.systems.renderer;
import lime.graphics.opengl.GLProgram;

/**
 * ...
 * @author Simon
 */
class ShaderData
{
	
	public var fragmentSource : String;
	public var vertexSource : String;
	public var glProgram : GLProgram;
	
	public function new( vs : String, fs : String ) 
	{
		vertexSource = vs;
		fragmentSource = fs;
	}
	
}