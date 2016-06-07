package uk.co.mojaworks.norman.components.renderer;
import geoff.math.Rect;
import geoff.renderer.Shader;
import geoff.renderer.Texture;
import geoff.utils.Color;
import geoff.utils.TextureUtils;
import uk.co.mojaworks.norman.components.Transform;
import uk.co.mojaworks.norman.components.Component;
import uk.co.mojaworks.norman.core.renderer.Canvas;
import uk.co.mojaworks.norman.systems.Systems;
import uk.co.mojaworks.norman.utils.ShaderUtils;

/**
 * ...
 * @author Simon
 */
class ImageRenderer extends BaseRenderer
{
	public static var defaultShader( get, null ) : Shader = null;
	private static function get_defaultShader( ) : Shader {
		if ( ImageRenderer.defaultShader == null ) {
			trace("Creating default image shader");
			
			var atts : Array<ShaderAttribute> = [
				new ShaderAttribute( "aVertexPosition", 0, 2 ),
				new ShaderAttribute( "aVertexColor", 2, 4 ),
				new ShaderAttribute( "aVertexUV", 6, 2 )
			];
			ImageRenderer.defaultShader = Core.instance.renderer.createShader( ShaderUtils.getDefaultImageVertexSource(), ShaderUtils.getDefaultImageFragSource(), atts );
			
		}
		return ImageRenderer.defaultShader;
	}
	
	public var texture( get, null ) : Texture;
	public var subTextureId( default, set ) : String;
	
	public var imageRect( default, null ) : Rect = null;
	public var imageUVRect( default, null ) : Rect = null;
	
	var _textureArray : Array<Texture>;
	
	public function new( texture : Texture, subTextureId : String = null ) 
	{
		super();
		_textureArray = [null];
		color = Color.WHITE;
		setTexture( texture, subTextureId );
		
	}
	
	inline private function get_texture() : Texture {
		return _textureArray[0];
	}
	
	public function setTexture( texture : Texture, subTextureId : String = null ) : Void {
		
		if ( this.texture != texture ) {
			
			if ( this.texture != null ) {
				this.texture.useCount--;			
				if ( this.texture.useCount <= 0 ) core.renderer.unloadTexture( this.texture.id );
			}
			_textureArray[0] = texture;
			if ( this.texture != null ) this.texture.useCount++;
		}
				
		this.subTextureId = subTextureId;
		
	}
	
	private function set_subTextureId( id : String ) : String {
		
		this.subTextureId = id;
		
		if ( texture != null ) {
			imageRect = TextureUtils.getRect( texture, subTextureId );
			imageUVRect = TextureUtils.getUV( texture, subTextureId );
		}else {
			imageRect = null;
			imageUVRect = null;
		}
		
		return this.subTextureId;
	}
	
	
	
	
	override public function render(canvas:Canvas):Void 
	{
		//trace("Rendering ", gameObject.id );
		
		super.render( canvas );
		
		if ( texture != null ) {
			
			var vertexData : Array<Float> = canvas.buildTexturedQuadVertexData( texture, imageUVRect, gameObject.transform.renderMatrix, color.r, color.g, color.b, color.a * getCompositeAlpha() );
			canvas.draw( _textureArray, ImageRenderer.defaultShader, vertexData, Canvas.QUAD_INDICES );
			
		}
	}
	
	override private function get_width():Float 
	{
		if ( texture != null ) {
			return imageRect.width;
		}else {
			return 0;
		}
	}
	
	override private function get_height():Float 
	{
		if ( texture != null ) {
			return imageRect.height;
		}else {
			return 0;
		}
	}
			
	override public function dispose():Void 
	{
		texture = null;
		imageRect = null;
		imageUVRect = null;
		_textureArray = null;
	}
}