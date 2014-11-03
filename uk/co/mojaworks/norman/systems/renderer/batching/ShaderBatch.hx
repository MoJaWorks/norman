package uk.co.mojaworks.norman.systems.renderer.batching;
import uk.co.mojaworks.norman.components.display.Sprite;
import uk.co.mojaworks.norman.systems.renderer.shaders.IShaderProgram;
import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * ...
 * @author Simon
 */
class ShaderBatch
{
	
	public var shader : IShaderProgram;
	public var items : LinkedList<Sprite>;
	
	public function new() 
	{
		items = LinkedList<Sprite>();
	}
	
}