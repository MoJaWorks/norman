package uk.co.mojaworks.norman.factory;
import lime.math.Rectangle;
import uk.co.mojaworks.norman.components.renderer.ImageRenderer;
import uk.co.mojaworks.norman.components.renderer.Mask;
import uk.co.mojaworks.norman.components.renderer.RenderTexture;
import uk.co.mojaworks.norman.components.renderer.Scale3ImageRenderer;
import uk.co.mojaworks.norman.components.renderer.Scale3ImageRenderer.Scale3Type;
import uk.co.mojaworks.norman.components.renderer.Scale9ImageRenderer;
import uk.co.mojaworks.norman.components.renderer.ShapeRenderer;
import uk.co.mojaworks.norman.components.renderer.ShapeRenderer.FillShape;
import uk.co.mojaworks.norman.components.renderer.TextRenderer;
import uk.co.mojaworks.norman.components.Component;
import uk.co.mojaworks.norman.systems.renderer.TextureData;
import uk.co.mojaworks.norman.systems.Systems;
import uk.co.mojaworks.norman.text.BitmapFont;
import uk.co.mojaworks.norman.utils.Color;

/**
 * ...
 * @author Simon
 */
class SpriteFactory
{

	public function new() 
	{
		
	}
	
	public static function createFilledSprite( colour : Color, width : Float, height : Float, ?shape : FillShape = null, ?name : String = null ) : GameObject {
		
		var gameObject : GameObject = ObjectFactory.createGameObject( name );
		gameObject.addComponent( new ShapeRenderer( colour, width, height, shape ) );
		
		return gameObject;
	}
	
	public static function createImageSprite( texture : TextureData, ?subImageId : String = null, ?name : String = null ) : GameObject {
		
		var gameObject : GameObject = ObjectFactory.createGameObject( name );
		gameObject.addComponent( new ImageRenderer( texture, subImageId ) );
		
		return gameObject;
	}
	
	public static function createImageSpriteFromAsset( assetId : String, ?subImageId : String = null, ?name : String = null ) : GameObject {
		
		var gameObject : GameObject = ObjectFactory.createGameObject( name );
		gameObject.addComponent( new ImageRenderer( Systems.renderer.createTextureFromAsset( assetId ), subImageId ) );
		
		return gameObject;
	}
	
	public static function createScale9ImageSprite( texture : TextureData, rect : Rectangle, ?subImageId : String = null, ?name : String = null ) : GameObject {
		
		var gameObject : GameObject = ObjectFactory.createGameObject( name );
		var renderer : Scale9ImageRenderer = cast gameObject.addComponent( new Scale9ImageRenderer( texture, subImageId ) );
		renderer.setScale9Rect( rect );
		
		return gameObject;
	}
	
	public static function createScale9ImageSpriteFromAsset( assetId : String, rect : Rectangle, ?subImageId : String = null, ?name : String = null ) : GameObject {
		
		var gameObject : GameObject = ObjectFactory.createGameObject( name );
		var renderer : Scale9ImageRenderer = cast gameObject.addComponent( new Scale9ImageRenderer( Systems.renderer.createTextureFromAsset( assetId ), subImageId ) );
		renderer.setScale9Rect( rect );
		
		return gameObject;
	}
	
	public static function createScale3ImageSprite( texture : TextureData, rect : Rectangle, type : Scale3Type, ?subImageId : String = null, ?name : String = null ) : GameObject {
		
		var gameObject : GameObject = ObjectFactory.createGameObject( name );
		var renderer : Scale3ImageRenderer = cast gameObject.addComponent( new Scale3ImageRenderer( texture, subImageId ) );
		renderer.setScale3Rect( rect );
		renderer.setScale3Type( type );
		
		return gameObject;
	}
	
	public static function createScale3ImageSpriteFromAsset( assetId : String, rect : Rectangle, type : Scale3Type, ?subImageId : String = null, ?name : String = null ) : GameObject {
		
		var gameObject : GameObject = ObjectFactory.createGameObject( name );
		var renderer : Scale3ImageRenderer = cast gameObject.addComponent( new Scale3ImageRenderer( Systems.renderer.createTextureFromAsset( assetId ), subImageId ) );
		renderer.setScale3Rect( rect );
		renderer.setScale3Type( type );
		
		return gameObject;
	}
	
	public static function createTextSprite( text : String, format : TextFormat, ?name : String = null ) : GameObject {
		
		var gameObject : GameObject = ObjectFactory.createGameObject( name );
		gameObject.addComponent( new TextRenderer( text, format ) );
		
		return gameObject;
	}
	
	public static function createRenderTexture( width : Float, height : Float, ?name : String = null ) : GameObject
	{
		var gameObject : GameObject = ObjectFactory.createGameObject( name );
		
		var render : RenderTexture = new RenderTexture();
		gameObject.addComponent( render );
		
		render.setSize( Std.int(width), Std.int(height) );
		gameObject.transform.isRoot = true;
		
		return gameObject;
	}
	
	public static function createMask( texture : TextureData, ?subImageId : String = null, ?name : String = null ) : GameObject
	{
		var gameObject : GameObject = ObjectFactory.createGameObject( name );
		gameObject.addComponent( new Mask( texture, subImageId ) );
		gameObject.transform.isRoot = true;
		
		return gameObject;
	}
	
}