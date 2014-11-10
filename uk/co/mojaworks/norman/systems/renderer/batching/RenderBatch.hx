package uk.co.mojaworks.norman.systems.renderer.batching;
import lime.utils.Float32Array;
import uk.co.mojaworks.norman.systems.renderer.shaders.IShaderProgram;

/**
 * ...
 * @author Simon
 */
class RenderBatch
{

	public var shader : IShaderProgram;
	public var texture : TextureData;
	public var target : TextureData;
	public var vertices : Array<Float>;
	public var indices : Array<Int>;
	
	public function new() 
	{
		vertices = [];
		indices = [];
	}
	
}