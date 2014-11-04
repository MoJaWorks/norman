package uk.co.mojaworks.norman.systems.renderer.batching;
import uk.co.mojaworks.norman.systems.renderer.ICanvas;

/**
 * ...
 * @author Simon
 */
class RenderBatch
{

	public var items : Array<TextureBatch>;
	public var target : ICanvas;
	
	public function new() 
	{
		items = [];
	}
	
	public function reset() {
		items = [];
		target = null;
	}
	
	
	
}