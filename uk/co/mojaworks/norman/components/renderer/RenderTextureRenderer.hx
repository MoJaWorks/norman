package uk.co.mojaworks.norman.components.renderer;
import uk.co.mojaworks.norman.core.renderer.Canvas;
import uk.co.mojaworks.norman.core.renderer.ShaderAttributeData;
import uk.co.mojaworks.norman.core.renderer.ShaderData;
import uk.co.mojaworks.norman.core.renderer.TextureData;
import uk.co.mojaworks.norman.systems.Systems;
import uk.co.mojaworks.norman.utils.ShaderUtils;

/**
 * ...
 * @author Simon
 */
class RenderTextureRenderer extends BaseRenderer
{
	public static var defaultShader( get, null ) : ShaderData = null;
	private static function get_defaultShader( ) : ShaderData {
		if ( RenderTextureRenderer.defaultShader == null ) {
			trace("Creating default render shader");
			
			var atts : Array<ShaderAttributeData> = [
				new ShaderAttributeData( "aVertexPosition", 0, 2 ),
				new ShaderAttributeData( "aVertexColor", 2, 4 ),
				new ShaderAttributeData( "aVertexUV", 6, 2 )
			];
			RenderTextureRenderer.defaultShader = Core.instance.renderer.createShader( ShaderUtils.getDefaultImageVertexSource(), ShaderUtils.getDefaultRenderTextureFragSource(), atts );
		}
		return RenderTextureRenderer.defaultShader;
	}
	
	public var target( get, null ) : TextureData;
	var _textureArray : Array<TextureData>;
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
		
		_textureArray[0] = Core.instance.renderer.createTexture( "@norman/renderSprite/" + gameObject.id, width, height, 0 );
		_textureArray[0].isRenderTexture = true;
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
	
	inline private function get_target() : TextureData {
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