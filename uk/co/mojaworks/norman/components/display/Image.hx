package uk.co.mojaworks.norman.components.display;
import openfl.geom.Rectangle;
import uk.co.mojaworks.norman.components.renderer.ICanvas;
import uk.co.mojaworks.norman.components.renderer.Renderer;
import uk.co.mojaworks.norman.components.renderer.TextureData;
import uk.co.mojaworks.norman.components.renderer.TextureManager;

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
	public var r : Float = 255;
	public var g : Float = 255;
	public var b : Float = 255;
	public var a : Float = 1;
		
	public function new( textureId : String, subTextureId : String = null ) 
	{
		super();
		
		var textureManager : TextureManager = root.get(Renderer).textureManager;
		if ( !textureManager.hasTexture( textureId ) ) {
			textureData = textureManager.loadTexture( textureId );
		}else {
			textureData = textureManager.getTexture( textureId );
		}
		
		textureData.useCount++;
		_uvRect = textureData.getUVFor( subTextureId );
		_rect = textureData.getRectFor( subTextureId );
		
	}
	
	override public function onAdded():Void 
	{
		super.onAdded();
		gameObject.transform.setPadding( _rect.x, _rect.y );
	}
	
	override public function render(canvas:ICanvas):Void 
	{
		canvas.drawSubImage( textureData, _uvRect, gameObject.transform.renderTransform, a * getFinalAlpha(), r, g, b );
	}
	
	override public function getNaturalWidth():Float 
	{
		return _rect.width;
	}
	
	override public function getNaturalHeight():Float 
	{
		return _rect.height;
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		textureData.useCount--;
		// Unload the texture if it is no longer in use
		if ( textureData.useCount <= 0 ) root.get(Renderer).textureManager.unloadTexture( textureData.id );
		
		textureData = null;
		_uvRect = null;
		_rect = null;
	}
	
}