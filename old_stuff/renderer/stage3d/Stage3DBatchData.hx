package uk.co.mojaworks.norman.components.renderer.stage3d ;
import flash.display3D.textures.TextureBase;

/**
 * ...
 * @author Simon
 */
class Stage3DBatchData
{

	public var start : Int;
	public var length : Int;
	public var shader : Stage3DShaderWrapper;
	public var texture : TextureBase;
	public var mask : Int = -1;
	
	public function new() 
	{
		
	}
	
}