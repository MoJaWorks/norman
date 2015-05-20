package uk.co.mojaworks.norman.display;
import lime.math.Rectangle;
import uk.co.mojaworks.norman.systems.renderer.Canvas;
import uk.co.mojaworks.norman.systems.renderer.ShaderData;
import uk.co.mojaworks.norman.systems.renderer.TextureData;
import uk.co.mojaworks.norman.systems.Systems;
import uk.co.mojaworks.norman.utils.Color;
import uk.co.mojaworks.norman.utils.ShaderUtils;

/**
 * ...
 * @author Simon
 */
class ImageSprite extends Sprite
{

	// Set up default shader
	public static var defaultShader( get, null ) : ShaderData = null;
	public static function get_defaultShader( ) : ShaderData {
		if ( ImageSprite.defaultShader == null ) {
			trace("Creating default image shader");
			ImageSprite.defaultShader = Systems.renderer.createShader( ShaderUtils.getDefaultImageVertexSource(), ShaderUtils.getDefaultImageFragSource() );
		}
		return ImageSprite.defaultShader;
	}
	
	public var color( default, default ) : Color;
	
	public var texture( default, null ) : TextureData;
	public var subTextureId( default, null ) : String;
	
	public var imageRect( default, null ) : Rectangle;
	public var imageUVRect( default, null ) : Rectangle;
	
	public function new( texture : TextureData, subTextureId : String = null ) 
	{
		super( );
		color = Color.WHITE;
		setTexture( texture, subTextureId );
		
		shouldRenderSelf = true;
		
	}
	
	public function setTexture( texture : TextureData, subTextureId : String = null ) : Void {
		
		if ( this.texture != texture ) {
			
			if ( this.texture != null ) this.texture.useCount--;			
			this.texture = texture;
			if ( this.texture != null ) this.texture.useCount++;
		}
		
		imageRect = texture.getRectFor( subTextureId );
		imageUVRect = texture.getUVFor( subTextureId );
		
	}
	
	override public function render(canvas:Canvas):Void 
	{
		canvas.drawSubtexture( texture, imageUVRect, transform.worldMatrix, color.r, color.g, color.b, color.a * finalAlpha, ImageSprite.defaultShader );
	}
	
}