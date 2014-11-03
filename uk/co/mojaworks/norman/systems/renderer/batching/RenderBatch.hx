package uk.co.mojaworks.norman.systems.renderer.batching;
import uk.co.mojaworks.norman.components.renderer.ICanvas;
import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * ...
 * @author Simon
 */
class RenderBatch
{

	public var items : LinkedList<TextureBatch>;
	public var target : ICanvas;
	
	public function new() 
	{
		
	}
	
}