package uk.co.mojaworks.norman.components.renderer;
import geoff.renderer.Shader;
import geoff.renderer.Texture;
import uk.co.mojaworks.norman.core.renderer.Canvas;
import uk.co.mojaworks.norman.utils.ShaderUtils;

/**
 * ...
 * @author Simon
 */
class RenderTextureRenderer extends BaseRenderer
{
	public static var defaultShader( get, null ) : Shader = null;
	private static function get_defaultShader( ) : Shader {
		if ( RenderTextureRenderer.defaultShader == null ) {
			trace("Creating default render shader");
			
			var atts : Array<ShaderAttribute> = [
				new ShaderAttribute( "aVertexPosition", 0, 2 ),
				new ShaderAttribute( "aVertexColor", 2, 4 ),
				new ShaderAttribute( "aVertexUV", 6, 2 )
			];
			RenderTextureRenderer.defaultShader = Core.instance.renderer.createShader( ShaderUtils.getDefaultImageVertexSource(), ShaderUtils.getDefaultRenderTextureFragSource(), atts );
		}
		return RenderTextureRenderer.defaultShader;
	}
	
	public var target( get, null ) : Texture;
	var _textureArray : Array<Texture>;
	var _renderToCanvas : Bool = true;
	
	
	public function new( ) 
	{
		super( );
		_textureArray = [null];
	}
	
	public function setSize( width : Int, height : Int ) : Void {
		if ( target != null ) {
			Core.instance.renderer.unloadTexture( "@norman/renderSprite/" + gameObject.id );
		}
		
		_textureArray[0] = Core.instance.renderer.createBlankTexture( "@norman/renderSprite/" + gameObject.id, width, height, 0 );
		_textureArray[0].smoothing = false;
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
		if ( _renderToCanvas ) {
			canvas.draw( _textureArray, RenderTextureRenderer.defaultShader, canvas.buildTexturedQuadVertexData( target, Canvas.WHOLE_IMAGE, gameObject.transform.renderMatrix, color.r, color.g, color.b, getCompositeAlpha() * color.a ), Canvas.QUAD_INDICES );
		}
	}
	
	inline private function get_target() : Texture {
		return _textureArray[0];
	}
	
	override private function get_width():Float 
	{
		return _textureArray[0].width;
	}
	
	override private function get_height():Float 
	{
		return _textureArray[0].height;
	}
	
	/**
	 * Forces the sprite to render its children to a texture. Can be used to render textures for post-processing before displaying.
	 */
	public function renderTexture() : Void {
		_renderToCanvas = false;
		Core.instance.renderer.renderLevel( this.gameObject.transform );
		_renderToCanvas = true;
	}
}