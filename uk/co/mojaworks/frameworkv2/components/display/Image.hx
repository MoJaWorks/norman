package uk.co.mojaworks.frameworkv2.components.display;
import flash.display.BitmapData;
import openfl.geom.Rectangle;
import uk.co.mojaworks.frameworkv2.renderer.TextureData;

/**
 * ...
 * @author Simon
 */
class Image extends Display
{

	public var textureData : TextureData;
	public var subTextureId : String = null;
		
	public var rect : Rectangle = null;
	
	// Colour multipliers
	public var red : Float = 1;
	public var green : Float = 1;
	public var blue : Float = 1;
		
	public function new( textureId : String, subTextureId : String = null ) 
	{
		super();		
	}
	
}