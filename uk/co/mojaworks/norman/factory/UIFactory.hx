package uk.co.mojaworks.norman.factory;
import uk.co.mojaworks.norman.components.debug.FPSUpdater;
import uk.co.mojaworks.norman.components.ui.UIDelegate;
import uk.co.mojaworks.norman.components.renderer.ShapeRenderer.FillShape;
import uk.co.mojaworks.norman.components.renderer.TextRenderer.TextFormat;
import uk.co.mojaworks.norman.components.text.TextInput;
import uk.co.mojaworks.norman.components.text.TextInputKeyboardDelegate;
import uk.co.mojaworks.norman.components.text.TextInputUIDelegate;
import uk.co.mojaworks.norman.components.ui.BlockerView;
import uk.co.mojaworks.norman.core.renderer.TextureData;
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
	
	public static function createImageButton( delegate : UIDelegate, texture : TextureData, ?subTextureId : String = null, ?name : String = null ) : GameObject {
		
		var gameObject : GameObject = SpriteFactory.createImageSprite( texture, subTextureId, name );
		delegate.hitTarget = gameObject;
		gameObject.add( delegate );
		
		return gameObject;
		
	}
	
	public static function createFPS( ) : GameObject {
		
		var font : BitmapFont = FontUtils.createFontFromAsset( "default/arial.fnt" );
		var gameObject = SpriteFactory.createTextSprite( "-- fps", new TextFormat(font), "fps" );
		gameObject.add( new FPSUpdater() );
		
		return gameObject;
		
	}
	
	public static function createTextInput( text : String, format : TextFormat, ?name : String = null ) : GameObject {
		
		var gameObject : GameObject = SpriteFactory.createTextSprite( text, format, name );
		gameObject.add( new TextInput() );
		gameObject.add( new TextInputUIDelegate() );
		gameObject.add( new TextInputKeyboardDelegate() );
		
		return gameObject;
		
	}
	
	public static function createBlocker( color : Color ) : GameObject {
		
		var gameObject : GameObject = SpriteFactory.createFilledSprite( color, 100, 100, FillShape.Rectangle, "blocker" );
		var view : BlockerView = cast gameObject.add( new BlockerView() );
		gameObject.add( new UIDelegate() ); // Absorb clicks
		
		view.resize();
		
		return gameObject;
		
	}
}