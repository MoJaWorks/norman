package uk.co.mojaworks.norman.components.renderer;
import lime.math.Rectangle;
import lime.math.Vector2;
import uk.co.mojaworks.norman.factory.GameObject;
import uk.co.mojaworks.norman.factory.ObjectFactory;
import uk.co.mojaworks.norman.factory.SpriteFactory;
import uk.co.mojaworks.norman.systems.renderer.Canvas;
import uk.co.mojaworks.norman.systems.renderer.ShaderAttributeData;
import uk.co.mojaworks.norman.systems.renderer.ShaderData;
import uk.co.mojaworks.norman.systems.renderer.TextureData;
import uk.co.mojaworks.norman.systems.Systems;
import uk.co.mojaworks.norman.utils.ShaderUtils;

/**
 * ...
 * @author ...
 */
class MaskedRenderTextureRenderer extends RenderTextureRenderer
{

	public static var defaultShader( get, null ) : ShaderData = null;
	private static function get_defaultShader( ) : ShaderData {
		if ( MaskedRenderTextureRenderer.defaultShader == null ) {
			trace("Creating default mask shader");
			
			var atts : Array<ShaderAttributeData> = [
				new ShaderAttributeData( "aVertexPosition", 0, 2 ),
				new ShaderAttributeData( "aVertexColor", 2, 4 ),
				new ShaderAttributeData( "aVertexUV", 6, 2 ),
			];
			
			MaskedRenderTextureRenderer.defaultShader = Systems.renderer.createShader( ShaderUtils.getDefaultMaskVertexSource(), ShaderUtils.getDefaultMaskFragSource(), atts );
		}
		return MaskedRenderTextureRenderer.defaultShader;
	}
	
	public var mask( default, null ) : GameObject;
	public var maskedTarget( get, null ) : TextureData;
	private var _textures : Array<TextureData>;
	
	public var renderMask : Bool = false;
	public var maskEnabled : Bool = true;
	
	
	public function new( ) : Void {
		
		super();
		_textureArray.push( null );
		
		mask = ObjectFactory.createGameObject("mask");
				
	}
	
	
	override public function setSize( width : Int, height : Int ) : Void {
		
		super.setSize( width, height );
		
		if ( target != null ) {
			Systems.renderer.unloadTexture( "@norman/maskedSprite/" + gameObject.id );
		}
		
		_textureArray[1] = Systems.renderer.createTexture( "@norman/maskedSprite/" + gameObject.id, width, height, 0 );
		_textureArray[1].isRenderTexture = true;
		
	}
		
	
	override public function postRender(canvas:Canvas):Void 
	{
		canvas.popRenderTarget();
		
		if ( mask != null && maskEnabled ) {
			
			canvas.pushRenderTarget( maskedTarget );
			canvas.clear(0);
			Systems.renderer.renderLevel( mask.transform );
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
	
	public function get_maskedTarget() : TextureData {
		return _textureArray[1];
	}
	
	
}