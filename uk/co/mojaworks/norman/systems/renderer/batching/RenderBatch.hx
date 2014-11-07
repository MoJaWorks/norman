package uk.co.mojaworks.norman.systems.renderer.batching;
import uk.co.mojaworks.norman.components.renderer.TextureData;
import uk.co.mojaworks.norman.systems.renderer.shaders.IShaderProgram;

/**
 * ...
 * @author Simon
 */
class RenderBatch
{

	public var shader : IShaderProgram;
	public var texture : TextureData;
	public var start : Int;
	public var length : Int;
	public var target : TextureData;
	
	public function new() 
	{
	}
	
}