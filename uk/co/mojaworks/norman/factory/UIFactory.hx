package uk.co.mojaworks.norman.factory;
import uk.co.mojaworks.norman.components.debug.FPSController;
import uk.co.mojaworks.norman.components.delegates.BaseUIDelegate;
import uk.co.mojaworks.norman.components.renderer.ShapeRenderer.FillShape;
import uk.co.mojaworks.norman.components.renderer.TextRenderer.TextFormat;
import uk.co.mojaworks.norman.systems.renderer.TextureData;
import uk.co.mojaworks.norman.text.BitmapFont;
import uk.co.mojaworks.norman.utils.Color;
import uk.co.mojaworks.norman.utils.FontUtils;

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
	
	public static function createFPS( ) : GameObject {
		
		var font : BitmapFont = FontUtils.createFontFromAsset( "default/arial.fnt" );
		var gameObject = SpriteFactory.createTextSprite( "-- fps", new TextFormat(font), "fps" );
		gameObject.addComponent( new FPSController() );
		
		return gameObject;
		
	}
	
	public static function createPanelForm() : GameObject {
		
		return null;
		
	}
	
	public static function createPanel() : GameObject {
		
		var gameObject : GameObject = SpriteFactory.createFilledSprite( Color.WHITE, 0, 0, FillShape.Rectangle, "panel" );
		return gameObject;
		
	}
	
}