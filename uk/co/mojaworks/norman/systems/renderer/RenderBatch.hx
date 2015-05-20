package uk.co.mojaworks.norman.systems.renderer;
import uk.co.mojaworks.norman.systems.renderer.ShaderData;

/**
 * ...
 * @author test
 */
class RenderBatch
{

	public var vertices : Array<Float>;
	public var indices : Array<Int>;
	public var shader : ShaderData;
	public var started : Bool = false;
	
	// public var target : RenderTexture;
	
	public function new() 
	{
		
		
	}
	
	public function reset() : Void {
		vertices = [];
		indices = [];
		shader = null;
	}
	
}