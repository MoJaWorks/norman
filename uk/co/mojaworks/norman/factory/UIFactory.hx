package uk.co.mojaworks.norman.factory;
import uk.co.mojaworks.norman.components.delegates.BaseUIDelegate;
import uk.co.mojaworks.norman.systems.renderer.TextureData;

/**
 * ...
 * @author Simon
 */
class UIFactory
{

	public function new() 
	{
		
	}
	
	public static function createImageButton( delegate : BaseUIDelegate, texture : TextureData, ?subTextureId : String = null, ?id : String = null ) : GameObject {
		
		var gameObject : GameObject = SpriteFactory.createImageSprite( texture, subTextureId, id );
		delegate.hitTarget = gameObject;
		gameObject.addComponent( delegate );
		
		return gameObject;
		
	}
	
}