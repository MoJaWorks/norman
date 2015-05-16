package uk.co.mojaworks.norman.display;
import uk.co.mojaworks.norman.utils.Color;

/**
 * ...
 * @author Simon
 */
class ImageSprite extends Sprite
{

	public var color( default, default ) : Color;
	public var textureId( default, default ) : String;
	
	public function new( textureId : String, id : String = null ) 
	{
		super( id );
	}
	
}