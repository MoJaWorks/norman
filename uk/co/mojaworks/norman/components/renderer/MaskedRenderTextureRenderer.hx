package uk.co.mojaworks.norman.components.renderer;
import geoff.renderer.Shader;
import geoff.renderer.Texture;
import uk.co.mojaworks.norman.factory.GameObject;
import uk.co.mojaworks.norman.factory.ObjectFactory;
import uk.co.mojaworks.norman.factory.SpriteFactory;
import uk.co.mojaworks.norman.core.renderer.Canvas;
import uk.co.mojaworks.norman.systems.Systems;
import uk.co.mojaworks.norman.utils.ShaderUtils;

/**
 * ...
 * @author ...
 */
class MaskedRenderTextureRenderer extends RenderTextureRenderer
{

	private static var _defaultShader : Shader = null;
	public static var defaultShader( get, never ) : Shader;
	private static function get_defaultShader( ) : Shader {
		if ( MaskedRenderTextureRenderer._defaultShader == null ) MaskedRenderTextureRenderer._initShader();
		return MaskedRenderTextureRenderer._defaultShader;
	}
	
	private static function _initShader() 
	{
		if ( MaskedRenderTextureRenderer._defaultShader == null ) {
			trace("Creating default mask shader");
			
			var atts : Array<ShaderAttribute> = [
				new ShaderAttribute( "aVertexPosition", 0, 2 ),
				new ShaderAttribute( "aVertexColor", 2, 4 ),
				new ShaderAttribute( "aVertexUV", 6, 2 ),
			];
			
			MaskedRenderTextureRenderer._defaultShader = Core.instance.renderer.createShader( ShaderUtils.getDefaultMaskVertexSource(), ShaderUtils.getDefaultMaskFragSource(), atts );
		}
	}
	
	public var mask( default, null ) : GameObject;
	public var maskedTarget( get, null ) : Texture;
	private var _textures : Array<Texture>;
	
	public var renderMask : Bool = false;
	public var maskEnabled : Bool = true;
	
	
	public function new( ) : Void {
		
		super();
		if ( MaskedRenderTextureRenderer._defaultShader == null ) MaskedRenderTextureRenderer._initShader();
		_textureArray.push( null );
		
		mask = ObjectFactory.createGameObject("mask");
				
	}
	
	
	override public function setSize( width : Int, height : Int ) : Void {
		
		super.setSize( width, height );
		
		if ( target != null ) {
			Core.instance.renderer.unloadTexture( "@norman/maskedSprite/" + gameObject.id );
		}
		
		_textureArray[1] = Core.instance.renderer.createBlankTexture( "@norman/maskedSprite/" + gameObject.id, width, height, 0 );
		_textureArray[1].smoothing = false;
		
	}
		
	
	override public function postRender(canvas:Canvas):Void 
	{
		canvas.popRenderTarget();
		
		if ( mask != null && maskEnabled ) {
			
			canvas.pushRenderTarget( maskedTarget );
			canvas.clear(0);
			Core.instance.renderer.renderLevel( mask.transform );
			canvas.popRenderTarget();
						
			if ( _renderToCanvas ) {
				canvas.draw( _textureArray, MaskedRenderTextureRenderer.defaultShader, canvas.buildTexturedQuadVertexData( target, Canvas.WHOLE_IMAGE, gameObject.transform.renderMatrix, color.r, color.g, color.b, getCompositeAlpha() * color.a ), Canvas.QUAD_INDICES );
			}
			
			if ( renderMask ) {
				canvas.draw( [maskedTarget], ImageRenderer.defaultShader, canvas.buildTexturedQuadVertexData( target, Canvas.WHOLE_IMAGE, gameObject.transform.renderMatrix, color.r, color.g, color.b, getCompositeAlpha() * color.a * 0.2 ), Canvas.QUAD_INDICES );
			}
			
		}else {
			if ( _renderToCanvas ) {
				canvas.draw( _textureArray, RenderTextureRenderer.defaultShader, canvas.buildTexturedQuadVertexData( target, Canvas.WHOLE_IMAGE, gameObject.transform.renderMatrix, color.r, color.g, color.b, getCompositeAlpha() * color.a ), Canvas.QUAD_INDICES );
			}
		}
		
	}
	
	public function get_maskedTarget() : Texture {
		return _textureArray[1];
	}
	
	
}