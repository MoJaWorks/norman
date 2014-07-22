package uk.co.mojaworks.norman.renderer.stage3d;
import flash.display3D.textures.Texture;
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Simon
 */
class Stage3DFrameBufferData
{
	public var index : Int = -1;
	public var bounds : Rectangle;
	public var texture : Texture;
	public var scissor : Rectangle = null;
}