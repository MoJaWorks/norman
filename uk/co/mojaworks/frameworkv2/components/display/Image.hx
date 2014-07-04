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
	private var _sourceRect : Rectangle = null;
	
	// Colour multipliers
	public var red : Float = 1;
	public var green : Float = 1;
	public var blue : Float = 1;
		
	public function new( textureId : String, subTextureId : String = null ) 
	{
		super();	
		this.subTextureId = subTextureId;
		
		var textureManager : TextureManager = core.root.get(Renderer).textureManager;
		if ( !textureManager.hasTexture( textureId ) ) {
			textureManager.loadTexture( textureId );
		}
		
		if ( subTextureId == null ) {
			_sourceRect = WHOLE_IMAGE;
		}else {
			_sourceRect = text
		}
	}
	
	override public function render(canvas:ICanvas):Void 
	{
		if ( subTextureId != null ) {
			canvas.drawSubImage( textureData, textureData.getUVFor( subTextureId ), new Matrix(), getFinalAlpha(), red, green, blue );
		}else {
			canvas.drawSubImage( textureData, textureData.getUVFor( subTextureId ), new Matrix(), getFinalAlpha(), red, green, blue );
		}
	}
	
}