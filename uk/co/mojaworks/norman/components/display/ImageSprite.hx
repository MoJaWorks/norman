package uk.co.mojaworks.norman.components.display;
import openfl.geom.Rectangle;
import uk.co.mojaworks.norman.components.renderer.ICanvas;
import uk.co.mojaworks.norman.components.renderer.Renderer;
import uk.co.mojaworks.norman.components.renderer.TextureData;
import uk.co.mojaworks.norman.components.renderer.TextureManager;
import uk.co.mojaworks.norman.core.GameObject;
import uk.co.mojaworks.norman.utils.Color;

/**
 * ...
 * @author Simon
 */
class ImageSprite extends Sprite
{

	public var textureData : TextureData;
	private var _uvRect : Rectangle = null;
	private var _rect : Rectangle = null;
		
	// Colour multipliers
	public var color( default, default ) : Color;
		
	public function new( textureId : String, subTextureId : String = null ) 
	{
		super();
		
		isRenderable = true;
		
		color = 0xFFFFFFFF;
		setTexture( textureId, subTextureId );
		
	}
	
	public function setTexture( textureId : String, subTextureId : String = null ) : GameObject {
	
		// Unload the old one first
		if ( textureData != null ) unlinkTexture();
		
		// Get the new texture
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
	
	private function unlinkTexture() : Void {
		textureData.useCount--;
		// Unload the texture if it is no longer in use
		if ( textureData.useCount <= 0 ) root.get(Renderer).textureManager.unloadTexture( textureData.id );
	}
	
	override public function onAdded():Void 
	{
		super.onAdded();
		gameObject.transform.setPadding( _rect.x, _rect.y );
	}
	
	override public function render(canvas:ICanvas):Void 
	{
		canvas.drawSubImage( textureData, _uvRect, gameObject.transform.renderTransform, color.a * getFinalAlpha(), color.r, color.g, color.b );
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
		unlinkTexture();
		
		textureData = null;
		_uvRect = null;
		_rect = null;
	}
	
}