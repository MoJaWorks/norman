package uk.co.mojaworks.norman.systems.renderer.batching;
import uk.co.mojaworks.norman.systems.renderer.TextureData;
import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * ...
 * @author Simon
 */
class TextureBatch
{

	public var textureData : TextureData = null;
	public var items : Array<ShaderBatch>;
	
	public function new() 
	{
		items = [];
	}
	
}