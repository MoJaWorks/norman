package uk.co.mojaworks.norman.components.renderer.gl ;
import openfl.gl.GLTexture;

/**
 * ...
 * @author Simon
 */
class GLBatchData
{

	public var start : Int;
	public var length : Int;
	public var shader : GLShaderWrapper;
	public var texture : GLTexture;
	public var mask : Int;
	
	public function new() 
	{
		
	}
	
}