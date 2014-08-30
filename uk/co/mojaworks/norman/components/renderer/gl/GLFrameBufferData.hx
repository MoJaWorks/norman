package uk.co.mojaworks.norman.components.renderer.gl ;
import openfl.geom.Rectangle;
import openfl.gl.GLFramebuffer;
import openfl.gl.GLTexture;

/**
 * ...
 * @author Simon
 */
class GLFrameBufferData
{
	public var index : Int = -1;
	public var bounds : Rectangle;
	public var texture : GLTexture;
	public var frameBuffer : GLFramebuffer;
}