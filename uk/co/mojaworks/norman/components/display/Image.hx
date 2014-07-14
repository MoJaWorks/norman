package uk.co.mojaworks.norman.components.display;
import flash.display.BitmapData;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import uk.co.mojaworks.norman.renderer.ICanvas;
import uk.co.mojaworks.norman.renderer.Renderer;
import uk.co.mojaworks.norman.renderer.TextureData;
import uk.co.mojaworks.norman.renderer.TextureManager;

/**
 * ...
 * @author Simon
 */
class Image extends Display
{

	public var textureData : TextureData;
	private var _uvRect : Rectangle = null;
	private var _rect : Rectangle = null;
	
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
		
		_uvRect = textureData.getUVFor( subTextureId );
		_rect = textureData.getRectFor( subTextureId );
			
		trace("Creating image with texture data", textureData, _uvRect, _rect );
	}
	
	override public function onAdded():Void 
	{
		super.onAdded();
		gameObject.transform.setPadding( _rect.x, _rect.y );
	}
	
	override public function render(canvas:ICanvas):Void 
	{
		canvas.drawSubImage( textureData, _uvRect, gameObject.transform.worldTransform, getFinalAlpha(), red, green, blue );
	}
	
	override public function getNaturalWidth():Float 
	{
		return _rect.width;
	}
	
	override public function getNaturalHeight():Float 
	{
		return _rect.height;
	}
	
}