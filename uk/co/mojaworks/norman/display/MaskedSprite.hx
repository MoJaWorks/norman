package uk.co.mojaworks.norman.display;
import lime.math.Rectangle;
import uk.co.mojaworks.norman.systems.renderer.Canvas;
import uk.co.mojaworks.norman.systems.renderer.ShaderAttributeData;
import uk.co.mojaworks.norman.systems.renderer.ShaderData;
import uk.co.mojaworks.norman.systems.renderer.TextureData;
import uk.co.mojaworks.norman.utils.ShaderUtils;

/**
 * ...
 * @author Simon
 */
class MaskedSprite extends Sprite
{

	public static var defaultShader( get, null ) : ShaderData = null;
	public static function get_defaultShader( ) : ShaderData {
		if ( MaskedSprite.defaultShader == null ) {
			trace("Creating default mask shader");
			
			var maskUV : ShaderAttributeData = new ShaderAttributeData( "aMaskUV", 0, 2 );
			MaskedSprite.defaultShader = Systems.renderer.createShader( ShaderUtils.getDefaultMaskVertexSource(), ShaderUtils.getDefaultMaskFragSource(), [aMaskUV] );
		}
		return MaskedSprite.defaultShader;
	}
	
	public var target : TextureData;
	private var _mask : TextureData;
	private var _maskSubTextureId : String;
	private var _maskSubTextureRect : Rectangle;
	
	
	public function new( texture : TextureData, subTextureId : String = null ) : Void {
		setMask( texture, subTextureId );
	}
	
		
	public function setMask( data : TextureData, subTextureId : String = null ) : Void {
		
		if ( target != null ) {
			Systems.renderer.unloadTexture( "@norman/maskedSprite/" + id );
		}
		
		var rect : Rectangle = data.getRectFor( subTextureId );
		target = Systems.renderer.createTexture( "@norman/maskedSprite/" + id, rect.width, rect.height, 0 );
		
		_mask = data;
		_maskSubTextureId = subTextureId;
		_maskSubTextureRect = data.getUVFor( _maskSubTextureId );
	}
	
	override public function preRender(canvas:Canvas):Void 
	{
		super.preRender(canvas);
		canvas.pushRenderTarget( target );
		canvas.clear( 0 );
	}
	
	override public function postRender(canvas:Canvas):Void 
	{
		super.postRender(canvas);
		canvas.popRenderTarget();
		canvas.drawSubTextures( [target, _mask], [Canvas.WHOLE_IMAGE, _maskSubTextureRect], renderMatrix, 255, 255, 255, finalAlpha, MaskedSprite.defaultShader, _mask );
	}
	
	override function get_width():Float 
	{
		return target.width;
	}
	
	override function get_height():Float 
	{
		return target.height;
	}
	
}