package uk.co.mojaworks.norman.factory;
import uk.co.mojaworks.hopper.components.game.common.BaseMovementComponent;
import uk.co.mojaworks.norman.components.debug.FPSController;
import uk.co.mojaworks.norman.components.delegates.BaseUIDelegate;
import uk.co.mojaworks.norman.components.renderer.ShapeRenderer.FillShape;
import uk.co.mojaworks.norman.components.renderer.TextRenderer.TextFormat;
import uk.co.mojaworks.norman.components.text.TextInput;
import uk.co.mojaworks.norman.components.text.TextInputKeyboardDelegate;
import uk.co.mojaworks.norman.components.text.TextInputUIDelegate;
import uk.co.mojaworks.norman.components.ui.BlockerView;
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
	
	public static function createTextInput( text : String, format : TextFormat, ?id : String = null ) : GameObject {
		
		var gameObject : GameObject = SpriteFactory.createTextSprite( text, format, id );
		gameObject.addComponent( new TextInput() );
		gameObject.addComponent( new TextInputUIDelegate() );
		gameObject.addComponent( new TextInputKeyboardDelegate() );
		
		return gameObject;
		
	}
	
	public static function createBlocker( color : Color ) : GameObject {
		
		var gameObject : GameObject = SpriteFactory.createFilledSprite( color, 100, 100, FillShape.Rectangle, "blocker" );
		var view : BlockerView = cast gameObject.addComponent( new BlockerView() );
		gameObject.addComponent( new BaseUIDelegate() ); // Absorb clicks
		
		view.resize();
		
		return gameObject;
		
	}
}