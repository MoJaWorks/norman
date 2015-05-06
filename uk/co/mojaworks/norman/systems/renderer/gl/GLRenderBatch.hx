package uk.co.mojaworks.norman.systems.renderer.gl;

/**
 * ...
 * @author test
 */
class GLRenderBatch
{

	public var vertices : Array<Float>;
	public var indices : Array<Int>;
	public var shaderId : String;
	public var started : Bool = false;
	
	// public var target : RenderTexture;
	
	public function new() 
	{
		
		
	}
	
	public function reset() : Void {
		vertices = [];
		indices = [];
		shaderId = "";
	}
	
}