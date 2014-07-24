package uk.co.mojaworks.norman.renderer.stage3d;
import flash.display3D.textures.TextureBase;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Simon
 */
class Stage3DFrameBufferData
{
	public var index : Int = -1;
	public var bounds : Rectangle;
	
	// Use two textures and flip between them to get around the "must clear texture on bind" bug
	public var textures : Array<TextureBase>;
	public var lastTextureUsed = -1;
	
	// Scissor to the corect size as textures must be power of 2
	public var scissor : Rectangle = null;
}