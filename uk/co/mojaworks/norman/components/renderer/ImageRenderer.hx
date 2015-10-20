package uk.co.mojaworks.norman.components.renderer;
import lime.math.Rectangle;
import uk.co.mojaworks.norman.components.Transform;
import uk.co.mojaworks.norman.components.Component;
import uk.co.mojaworks.norman.systems.renderer.Canvas;
import uk.co.mojaworks.norman.systems.renderer.ShaderAttributeData;
import uk.co.mojaworks.norman.systems.renderer.ShaderData;
import uk.co.mojaworks.norman.systems.renderer.TextureData;
import uk.co.mojaworks.norman.systems.Systems;
import uk.co.mojaworks.norman.utils.Color;
import uk.co.mojaworks.norman.utils.ShaderUtils;

/**
 * ...
 * @author Simon
 */
class ImageRenderer extends AbstractRenderer
{
	public static var defaultShader( get, null ) : ShaderData = null;
	public static function get_defaultShader( ) : ShaderData {
		if ( ImageRenderer.defaultShader == null ) {
			trace("Creating default image shader");
			
			var atts : Array<ShaderAttributeData> = [
				new ShaderAttributeData( "aVertexPosition", 0, 2 ),
				new ShaderAttributeData( "aVertexColor", 2, 4 ),
				new ShaderAttributeData( "aVertexUV", 6, 2 )
			];
			ImageRenderer.defaultShader = Systems.renderer.createShader( ShaderUtils.getDefaultImageVertexSource(), ShaderUtils.getDefaultImageFragSource(), atts );
			
		}
		return ImageRenderer.defaultShader;
	}
	
	public var color( default, default ) : Color;
	
	public var texture( get, null ) : TextureData;
	public var subTextureId( default, set ) : String;
	
	public var imageRect( default, null ) : Rectangle = null;
	public var imageUVRect( default, null ) : Rectangle = null;
	
	var _textureArray : Array<TextureData>;
	
	public function new( texture : TextureData, subTextureId : String = null ) 
	{
		super();
		_textureArray = [null];
		color = Color.WHITE;
		setTexture( texture, subTextureId );
		
	}
	
	inline private function get_texture() : TextureData {
		return _textureArray[0];
	}
	
	public function setTexture( texture : TextureData, subTextureId : String = null ) : Void {
		
		if ( this.texture != texture ) {
			
			if ( this.texture != null ) this.texture.useCount--;			
			_textureArray[0] = texture;
			if ( this.texture != null ) this.texture.useCount++;
		}
				
		this.subTextureId = subTextureId;
		
	}
	
	private function set_subTextureId( id : String ) : String {
		
		this.subTextureId = id;
		
		imageRect = texture.getRectFor( subTextureId );
		imageUVRect = texture.getUVFor( subTextureId );
		
		return this.subTextureId;
	}
	
	override public function render(canvas:Canvas):Void 
	{
		super.render( canvas );
		
		var vertexData : Array<Float> = canvas.buildTexturedQuadVertexData( texture, imageUVRect, gameObject.transform.renderMatrix, color.r, color.g, color.b, color.a * getCompositeAlpha() );
		canvas.draw( _textureArray, ImageRenderer.defaultShader, vertexData, Canvas.QUAD_INDICES );
	}
	
	override public function getWidth():Float 
	{
		return imageRect.width;
	}
	
	override public function getHeight():Float 
	{
		return imageRect.height;
	}
			
	override public function dispose():Void 
	{
		texture = null;
		imageRect = null;
		imageUVRect = null;
		_textureArray = null;
	}
}