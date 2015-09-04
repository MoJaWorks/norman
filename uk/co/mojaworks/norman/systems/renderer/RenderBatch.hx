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
	public var textures : Array<TextureData>;
	public var target : FrameBuffer;
	public var started : Bool = false;
	
	public function new() 
	{
		reset();		
	}
	
	public function reset() : Void {
		vertices = [];
		indices = [];
		textures = null;
		shader = null;
	}
	
	public function isCompatible( shader : ShaderData, textures : Array<TextureData> ) : Bool {
		
		var compatible : Bool = true;
		
		compatible = compatible && (this.shader == shader);
		compatible = compatible && ((this.textures != null && textures != null) || (this.textures == null && textures == null));
		compatible = compatible && textures.length == this.textures.length;
		
		if ( compatible ) {
			for ( i in 0...textures.length ) {
				compatible = compatible && (this.textures[i] == textures[i]);
				if ( !compatible ) break;
			}
		}
		
		return compatible;
	}
	
}