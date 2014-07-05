package uk.co.mojaworks.frameworkv2.components.display;
import flash.display.BitmapData;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import uk.co.mojaworks.frameworkv2.renderer.ICanvas;
import uk.co.mojaworks.frameworkv2.renderer.Renderer;
import uk.co.mojaworks.frameworkv2.renderer.TextureData;
import uk.co.mojaworks.frameworkv2.renderer.TextureManager;

/**
 * ...
 * @author Simon
 */
class Image extends Display
{

	private static var WHOLE_IMAGE : Rectangle = new Rectangle( 0, 0, 1, 1 );
	
	public var textureData : TextureData;
	private var _uvRect : Rectangle = null;
	
	// Colour multipliers
	public var red : Float = 1;
	public var green : Float = 1;
	public var blue : Float = 1;
		
	public function new( textureId : String, subTextureId : String = null ) 
	{
		super();	
		
		var textureManager : TextureManager = core.root.get(Renderer).textureManager;
		if ( !textureManager.hasTexture( textureId ) ) {
			textureData = textureManager.loadTexture( textureId );
		}else {
			textureData = textureManager.getTexture( textureId );
		}
		
		
		if ( subTextureId == null ) {
			_uvRect = WHOLE_IMAGE;
		}else {
			_uvRect = textureData.getUVFor( subTextureId );
		}
		trace("Creating image with texture data", textureData, _uvRect );
	}
	
	override public function render(canvas:ICanvas):Void 
	{
		canvas.drawSubImage( textureData, _uvRect, new Matrix(), getFinalAlpha(), red, green, blue );
	}
	
	override public function getNaturalWidth():Float 
	{
		return textureData.sourceBitmap.width;
	}
	
	override public function getNaturalHeight():Float 
	{
		return textureData.sourceBitmap.height;
	}
	
}