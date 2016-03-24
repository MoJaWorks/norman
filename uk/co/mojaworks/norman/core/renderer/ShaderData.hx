package uk.co.mojaworks.norman.core.renderer;
import lime.graphics.opengl.GLProgram;

/**
 * ...
 * @author Simon
 */
class ShaderData
{
	public var attributes : Array<ShaderAttributeData>;
	public var fragmentSource : String;
	public var vertexSource : String;
	public var glProgram : GLProgram;
	public var vertexSize : Int;
	
	public function new( vs : String, fs : String, atts : Array<ShaderAttributeData> ) 
	{
		vertexSource = vs;
		fragmentSource = fs;
		attributes = atts;
		
		vertexSize = 0;
		for ( att in atts ) {
			vertexSize += att.size;
		}
	}
	
}