package uk.co.mojaworks.norman.factory;
import uk.co.mojaworks.norman.components.renderer.ImageRenderer;
import uk.co.mojaworks.norman.systems.components.Component;
import uk.co.mojaworks.norman.systems.renderer.TextureData;
import uk.co.mojaworks.norman.systems.Systems;

/**
 * ...
 * @author Simon
 */
class SpriteFactory
{

	public function new() 
	{
		
	}
	
	public static function createImageSprite( texture : TextureData, subImageId : String, id : String = null ) : GameObject {
		
		var gameObject : GameObject = ObjectFactory.createGameObject( id );
		gameObject.addComponent( new ImageRenderer( texture, subImageId ) );
		
		return gameObject;
	}
	
}