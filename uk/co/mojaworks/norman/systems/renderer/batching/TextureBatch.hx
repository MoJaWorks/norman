package uk.co.mojaworks.norman.systems.renderer.batching;
import uk.co.mojaworks.norman.components.renderer.TextureData;
import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * ...
 * @author Simon
 */
class TextureBatch
{

	public var texture : TextureData;
	public var items : LinkedList<ShaderBatch>;
	
	public function new() 
	{
		items = LinkedList<ShaderBatch>();
	}
	
}