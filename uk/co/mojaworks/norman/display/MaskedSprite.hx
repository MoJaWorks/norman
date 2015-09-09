package uk.co.mojaworks.norman.display;
import lime.math.Rectangle;
import lime.math.Vector2;
import uk.co.mojaworks.norman.systems.renderer.Canvas;
import uk.co.mojaworks.norman.systems.renderer.ShaderAttributeData;
import uk.co.mojaworks.norman.systems.renderer.ShaderData;
import uk.co.mojaworks.norman.systems.renderer.TextureData;
import uk.co.mojaworks.norman.systems.Systems;
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
			
			var atts : Array<ShaderAttributeData> = [
				new ShaderAttributeData( "aVertexPosition", 0, 2 ),
				new ShaderAttributeData( "aVertexAlpha", 2, 1 ),
				new ShaderAttributeData( "aVertexUV", 3, 2 ),
				new ShaderAttributeData( "aMaskUV", 5, 2 )
			];
			
			MaskedSprite.defaultShader = Systems.renderer.createShader( ShaderUtils.getDefaultMaskVertexSource(), ShaderUtils.getDefaultMaskFragSource(), atts );
		}
		return MaskedSprite.defaultShader;
	}
	
	public var target( get, null ) : TextureData;
	private var _textures : Array<TextureData>;
	
	private var _maskSubTextureId : String;
	private var _maskSubTextureRect : Rectangle;
	
	var _cachedTexturedQuadVertexData : Array<Float>;
	var _quadUVs : Array<Vector2>;
	
	
	public function new( texture : TextureData, subTextureId : String = null ) : Void {
		
		super();
		
		shouldRenderSelf = true;
		isRoot = true;
		
		_textures = [null, null];
		
		setMask( texture, subTextureId );
		_cachedTexturedQuadVertexData = [for ( i in 0...28) 0];
		
		_quadUVs = [
			new Vector2(1, 1),
			new Vector2(0, 1),
			new Vector2(1, 0 ),
			new Vector2(0, 0 )
		];
	}
	
		
	public function setMask( data : TextureData, subTextureId : String = null ) : Void {
		
		if ( target != null ) {
			Systems.renderer.unloadTexture( "@norman/maskedSprite/" + id );
		}
		
		var rect : Rectangle = data.getRectFor( subTextureId );
		_textures[0] = Systems.renderer.createTexture( "@norman/maskedSprite/" + id, Std.int(rect.width), Std.int(rect.height), 0 );
		_textures[0].isRenderTexture = true;
		
		_textures[1] = data;
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
		
		var points : Array<Vector2> = [
			new Vector2( target.width, target.height),
			new Vector2(0, target.height),
			new Vector2(target.width, 0),
			new Vector2(0, 0)
		];
		
		var mask_uv : Array<Vector2> = [
			new Vector2(_maskSubTextureRect.right, _maskSubTextureRect.bottom),
			new Vector2(_maskSubTextureRect.left, _maskSubTextureRect.bottom),
			new Vector2(_maskSubTextureRect.right, _maskSubTextureRect.top ),
			new Vector2(_maskSubTextureRect.left, _maskSubTextureRect.top )
		];
		
		// Make points global with transform
		for ( i in 0...4 ) {
			var transformed = renderMatrix.transformVector2( points[i] );
			_cachedTexturedQuadVertexData[(i * 7) + 0] = transformed.x;
			_cachedTexturedQuadVertexData[(i * 7) + 1] = transformed.y;
			_cachedTexturedQuadVertexData[(i * 7) + 2] = finalAlpha;
			_cachedTexturedQuadVertexData[(i * 7) + 3] = _quadUVs[i].x;
			_cachedTexturedQuadVertexData[(i * 7) + 4] = _quadUVs[i].y;
			_cachedTexturedQuadVertexData[(i * 7) + 5] = mask_uv[i].x;
			_cachedTexturedQuadVertexData[(i * 7) + 6] = mask_uv[i].y;
		}	
		
		canvas.draw( _textures, MaskedSprite.defaultShader, _cachedTexturedQuadVertexData, Canvas.QUAD_INDICES );
	}
	
	inline private function get_target() : TextureData {
		return _textures[0];
	}
	
}