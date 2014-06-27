package uk.co.mojaworks.frameworkv2.renderer;
import flash.display.BitmapData;
import openfl.gl.GLTexture;

/**
 * ...
 * @author Simon
 */
class TextureData
{

	// The source bitmap and an ID used to keep track of it
	public var sourceBitmap : BitmapData;
	public var id : String;
	
	// Only used for GL rendering
	public var texture : GLTexture;
	public var boundUnit : Int = -1;
	
	// This will be a parsed JSON object
	public var spriteMap : Dynamic;
	
	public function new() 
	{
		
	}
	
}