package uk.co.mojaworks.norman.systems.renderer.stage3d;

/**
 * ...
 * @author ...
 */
class Stage3DRenderBatch
{

	public var shader : Stage3DShaderProgram;
	public var texture : Stage3DTextureData;
	public var vertices : Array<Float>;
	public var indices : Array<Int>;
	public var started : Bool;
	
	public function new() 
	{
		reset();
	}
	
	public function reset() : Void {
		shader = null;
		texture = null;
		vertices = [];
		indices = [];
		started = false;
	}
	
}