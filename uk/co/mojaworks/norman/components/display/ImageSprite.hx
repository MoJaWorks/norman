package uk.co.mojaworks.norman.components.display;
import lime.Assets;
import lime.math.Rectangle;
import uk.co.mojaworks.norman.engine.NormanApp;
import uk.co.mojaworks.norman.systems.renderer.ICanvas;
import uk.co.mojaworks.norman.systems.renderer.shaders.DefaultImageFragmentShader;
import uk.co.mojaworks.norman.systems.renderer.shaders.DefaultImageVertexShader;
import uk.co.mojaworks.norman.systems.renderer.shaders.IShaderProgram;
import uk.co.mojaworks.norman.systems.renderer.TextureData;
import uk.co.mojaworks.norman.utils.Color;

/**
 * ...
 * @author Simon
 */
class ImageSprite extends Sprite
{

	public static var shader : IShaderProgram = null;
	
	private var _textureData : TextureData = null;
	private var _uvRect : Rectangle = null;
	private var _rect : Rectangle = null;
		
	// Colour multipliers
	public var color( default, default ) : Color;
		
	public function new( textureId : String, subTextureId : String = null ) 
	{
		super();
		
		color = 0xFFFFFFFF;
		setTexture( textureId, subTextureId );
		
	}
	
	override function initShader() 
	{
		super.initShader();
		if ( ImageSprite.shader == null ) {
			ImageSprite.shader = NormanApp.renderer.createShader( new DefaultImageVertexShader(), new DefaultImageFragmentShader() );
		}
	}
	
	override public function getShader():IShaderProgram 
	{
		return ImageSprite.shader;
	}
	
	public function setTexture( textureId : String, subTextureId : String = null ) : ImageSprite {
	
		// Unload the old one first
		if ( _textureData != null ) unlinkTexture();
		
		// Get the new texture
		if ( !NormanApp.renderer.hasTexture( textureId ) ) {
			_textureData = NormanApp.renderer.createTextureFromAsset( textureId );
		}else {
			_textureData = NormanApp.renderer.getTexture( textureId );
		}
		
		_textureData.useCount++;
		_uvRect = _textureData.getUVFor( subTextureId );
		_rect = _textureData.getRectFor( subTextureId );
		
		return this;
	}
	
	private function unlinkTexture() : Void {
		_textureData.useCount--;
		// Unload the texture if it is no longer in use
		if ( _textureData.useCount <= 0 ) NormanApp.renderer.destroyTexture( _textureData.id );
	}
	
	override public function onAdded():Void 
	{
		super.onAdded();
		setPadding( _rect.x, _rect.y );
	}
	
	override public function render(canvas:ICanvas):Void 
	{
		canvas.drawSubImage( _textureData, _uvRect, renderTransform, getShader(), color.r, color.g, color.b, color.a * getFinalAlpha() );
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
		
		_textureData = null;
		_uvRect = null;
		_rect = null;
	}
	
}