package uk.co.mojaworks.norman.systems.renderer.batching;
import uk.co.mojaworks.norman.components.display.Sprite;
import uk.co.mojaworks.norman.systems.renderer.shaders.IShaderProgram;

/**
 * ...
 * @author Simon
 */
class ShaderBatch
{
	
	public var shader : IShaderProgram;
	public var items : Array<Sprite>;
	
	public function new() 
	{
		items = [];
	}
	
}