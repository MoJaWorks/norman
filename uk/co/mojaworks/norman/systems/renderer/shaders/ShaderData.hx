package uk.co.mojaworks.norman.systems.renderer.shaders;
import lime.graphics.opengl.GLProgram;

/**
 * ...
 * @author Simon
 */
class ShaderData
{
	
	public var id : String;
	public var fragmentSource : String;
	public var vertexSource : String;
	public var glProgram : GLProgram;
	
	public function new() 
	{
		setupVertexSource();
		setupFragmentSource();
	}
	
	private function setupVertexSource() : Void {
		// Do vertexy things
	}
	
	private function setupFragmentSource() : Void {
		// Do fragmenty things
	}
	
}