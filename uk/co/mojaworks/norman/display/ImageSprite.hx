package uk.co.mojaworks.norman.display;
import lime.math.Rectangle;
import uk.co.mojaworks.norman.systems.renderer.TextureData;
import uk.co.mojaworks.norman.utils.Color;

/**
 * ...
 * @author Simon
 */
class ImageSprite extends Sprite
{

	public var color( default, default ) : Color;
	
	public var texture( default, set ) : TextureData;
	public var subTextureId( default, set ) : String;
	
	public var imageRect( default, null ) : Rectangle;
	public var imageUVRect( default, null ) : Rectangle;
	
	public function new( texture : TextureData, subTextureId : String = null ) 
	{
		super( );
		
		
	}
	
	public function textureId() : Void {
		
	}
	
}