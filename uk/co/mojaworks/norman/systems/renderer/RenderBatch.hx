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
	public var texture : TextureData;
	public var target : FrameBuffer;
	public var started : Bool = false;
	
	public function new() 
	{
		reset();		
	}
	
	public function reset() : Void {
		vertices = [];
		indices = [];
		texture = null;
		shader = null;
	}
	
	public function isCompatible( shader : ShaderData, texture : TextureData ) : Bool {
		return (this.shader == shader) && (this.texture == texture);
	}
	
}