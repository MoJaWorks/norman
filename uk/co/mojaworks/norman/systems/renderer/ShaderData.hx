package uk.co.mojaworks.norman.systems.renderer;
import lime.graphics.opengl.GLProgram;

/**
 * ...
 * @author Simon
 */
class ShaderData
{
	public var numTextures : Int;
	public var attributes : Array<ShaderAttributeData>;
	public var fragmentSource : String;
	public var vertexSource : String;
	public var glProgram : GLProgram;
	public var dataSize : Int = 0;
	public var vertexSize( get, never ) : Int;
	
	public function new( vs : String, fs : String ) 
	{
		vertexSource = vs;
		fragmentSource = fs;
	}
	
	private function get_vertexSize() : Int {
		return dataSize + Canvas.VERTEX_SIZE;
	}
	
}