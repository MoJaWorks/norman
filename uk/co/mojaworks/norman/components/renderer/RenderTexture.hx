package uk.co.mojaworks.norman.components.renderer;
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
class RenderTexture extends BaseRenderer
{
	public static var defaultShader( get, null ) : ShaderData = null;
	public static function get_defaultShader( ) : ShaderData {
		if ( RenderTexture.defaultShader == null ) {
			trace("Creating default render shader");
			
			var atts : Array<ShaderAttributeData> = [
				new ShaderAttributeData( "aVertexPosition", 0, 2 ),
				new ShaderAttributeData( "aVertexColor", 2, 4 ),
				new ShaderAttributeData( "aVertexUV", 6, 2 )
			];
			RenderTexture.defaultShader = Systems.renderer.createShader( ShaderUtils.getDefaultImageVertexSource(), ShaderUtils.getDefaultRenderTextureFragSource(), atts );
		}
		return RenderTexture.defaultShader;
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
			Systems.renderer.unloadTexture( "@norman/renderSprite/" + gameObject.id );
		}
		
		_textureArray[0] = Systems.renderer.createTexture( "@norman/renderSprite/" + gameObject.id, width, height, 0 );
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
			canvas.draw( _textureArray, RenderTexture.defaultShader, canvas.buildTexturedQuadVertexData( target, Canvas.WHOLE_IMAGE, gameObject.transform.renderMatrix, color.r, color.g, color.b, getCompositeAlpha() * color.a ), Canvas.QUAD_INDICES );
		}
	}
	
	inline private function get_target() : TextureData {
		return _textureArray[0];
	}
	
	override public function getWidth():Float 
	{
		return _textureArray[0].width;
	}
	
	override public function getHeight():Float 
	{
		return _textureArray[0].height;
	}
	
	/**
	 * Forces the sprite to render its children to a texture. Can be used to render textures for post-processing before displaying.
	 */
	public function renderTexture() : Void {
		_renderToCanvas = false;
		Systems.renderer.renderLevel( this.gameObject.transform );
		_renderToCanvas = true;
	}
}