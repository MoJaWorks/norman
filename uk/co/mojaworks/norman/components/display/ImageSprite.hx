package uk.co.mojaworks.norman.components.display;
import lime.math.Rectangle;
import uk.co.mojaworks.norman.core.Core;
import uk.co.mojaworks.norman.systems.renderer.ICanvas;
import uk.co.mojaworks.norman.systems.renderer.ITextureData;
import uk.co.mojaworks.norman.systems.renderer.shaders.DefaultImageFragmentShader;
import uk.co.mojaworks.norman.systems.renderer.shaders.DefaultImageVertexShader;
import uk.co.mojaworks.norman.systems.renderer.shaders.IShaderProgram;
import uk.co.mojaworks.norman.utils.Color;

/**
 * ...
 * @author Simon
 */
class ImageSprite extends Sprite
{

	public static var shader( get, null ) : IShaderProgram = null;
	private var _textureData : ITextureData = null;
	private var _uvRect : Rectangle = null;
	private var _rect : Rectangle = null;
		
	// Colour multipliers
	public var color( default, default ) : Color;
		
	// Make sure setTexture is called after to finish creation
	public function new( ) 
	{
		super();
		color = 0xFFFFFFFF;
	}
	
	private static function get_shader() : IShaderProgram {
		if ( ImageSprite.shader == null ) {
			#if gl_debug trace( "Compiling ImageSprite shader" ); #end
			ImageSprite.shader = Core.getInstance().app.renderer.createShader( new DefaultImageVertexShader(), new DefaultImageFragmentShader() );
		}
		return ImageSprite.shader;
	}
	
	override public function getShader():IShaderProgram 
	{
		return ImageSprite.shader;
	}
	
	public function setTexture( texture : ITextureData, subTextureId : String = null ) : ImageSprite {
	
		// Unload the old one first
		if ( _textureData != null ) unlinkTexture();
		
		_textureData = texture;
		
		if ( !_textureData.isValid ) core.app.renderer.reviveTexture( _textureData );
		
		_textureData.useCount++;
		_uvRect = _textureData.getUVFor( subTextureId );
		_rect = _textureData.getRectFor( subTextureId );
		
		trace("Created image", _rect.width, _rect.height );
		
		return this;
	}
	
	private function unlinkTexture() : Void {
		_textureData.useCount--;
		// Unload the texture if it is no longer in use
		if ( _textureData.useCount <= 0 ) core.app.renderer.destroyTexture( _textureData.id );
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