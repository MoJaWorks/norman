package uk.co.mojaworks.norman.systems.renderer.gl ;
import lime.utils.Float32Array;
import uk.co.mojaworks.norman.systems.renderer.shaders.IShaderProgram;

/**
 * ...
 * @author Simon
 */
class GLRenderBatch
{

	public var shader : GLShaderProgram;
	public var texture : GLTextureData;
	public var vertices : Array<Float>;
	public var indices : Array<Int>;
	public var started : Bool;
	
	public function new() 
	{
		reset();
	}
	
	public function reset() : Void {
		shader = null;
		texture = null;
		vertices = [];
		indices = [];
		started = false;
	}
	
}