package uk.co.mojaworks.norman.factory;
import lime.math.Rectangle;
import uk.co.mojaworks.norman.components.renderer.ImageRenderer;
import uk.co.mojaworks.norman.components.renderer.MaskedRenderTextureRenderer;
import uk.co.mojaworks.norman.components.renderer.RenderTextureRenderer;
import uk.co.mojaworks.norman.components.renderer.Scale3ImageRenderer;
import uk.co.mojaworks.norman.components.renderer.Scale3ImageRenderer.Scale3Type;
import uk.co.mojaworks.norman.components.renderer.Scale9ImageRenderer;
import uk.co.mojaworks.norman.components.renderer.ShapeRenderer;
import uk.co.mojaworks.norman.components.renderer.ShapeRenderer.FillShape;
import uk.co.mojaworks.norman.components.renderer.TextRenderer;
import uk.co.mojaworks.norman.components.Component;
import uk.co.mojaworks.norman.core.renderer.TextureData;
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
		gameObject.add( new ShapeRenderer( colour, width, height, shape ) );
		
		return gameObject;
	}
	
	public static function createImageSprite( texture : TextureData, ?subImageId : String = null, ?name : String = null ) : GameObject {
		
		var gameObject : GameObject = ObjectFactory.createGameObject( name );
		gameObject.add( new ImageRenderer( texture, subImageId ) );
		
		return gameObject;
	}
	
	public static function createImageSpriteFromAsset( assetId : String, ?subImageId : String = null, ?name : String = null ) : GameObject {
		
		var gameObject : GameObject = ObjectFactory.createGameObject( name );
		gameObject.add( new ImageRenderer( Core.instance.renderer.createTextureFromAsset( assetId ), subImageId ) );
		
		return gameObject;
	}
	
	public static function createScale9ImageSprite( texture : TextureData, rect : Rectangle, ?subImageId : String = null, ?name : String = null ) : GameObject {
		
		var gameObject : GameObject = ObjectFactory.createGameObject( name );
		var renderer : Scale9ImageRenderer = cast gameObject.add( new Scale9ImageRenderer( texture, subImageId ) );
		renderer.setScale9Rect( rect );
		
		return gameObject;
	}
	
	public static function createScale9ImageSpriteFromAsset( assetId : String, rect : Rectangle, ?subImageId : String = null, ?name : String = null ) : GameObject {
		
		var gameObject : GameObject = ObjectFactory.createGameObject( name );
		var renderer : Scale9ImageRenderer = cast gameObject.add( new Scale9ImageRenderer( Core.instance.renderer.createTextureFromAsset( assetId ), subImageId ) );
		renderer.setScale9Rect( rect );
		
		return gameObject;
	}
	
	public static function createScale3ImageSprite( texture : TextureData, rect : Rectangle, type : Scale3Type, ?subImageId : String = null, ?name : String = null ) : GameObject {
		
		var gameObject : GameObject = ObjectFactory.createGameObject( name );
		var renderer : Scale3ImageRenderer = cast gameObject.add( new Scale3ImageRenderer( texture, subImageId ) );
		renderer.setScale3Rect( rect );
		renderer.setScale3Type( type );
		
		return gameObject;
	}
	
	public static function createScale3ImageSpriteFromAsset( assetId : String, rect : Rectangle, type : Scale3Type, ?subImageId : String = null, ?name : String = null ) : GameObject {
		
		var gameObject : GameObject = ObjectFactory.createGameObject( name );
		var renderer : Scale3ImageRenderer = cast gameObject.add( new Scale3ImageRenderer( Core.instance.renderer.createTextureFromAsset( assetId ), subImageId ) );
		renderer.setScale3Rect( rect );
		renderer.setScale3Type( type );
		
		return gameObject;
	}
	
	public static function createTextSprite( text : String, format : TextFormat, ?name : String = null ) : GameObject {
		
		var gameObject : GameObject = ObjectFactory.createGameObject( name );
		gameObject.add( new TextRenderer( text, format ) );
		
		return gameObject;
	}
	
	public static function createRenderTexture( width : Float, height : Float, ?name : String = null ) : GameObject
	{
		var gameObject : GameObject = ObjectFactory.createGameObject( name );
		
		var render : RenderTextureRenderer = new RenderTextureRenderer();
		gameObject.add( render );
		
		render.setSize( Std.int(width), Std.int(height) );
		gameObject.transform.isRoot = true;
		
		return gameObject;
	}
	
	public static function createMask( width : Int, height : Int, ?name : String = null ) : GameObject
	{
		var gameObject : GameObject = ObjectFactory.createGameObject( name );
		var mask : MaskedRenderTextureRenderer = cast gameObject.add( new MaskedRenderTextureRenderer() );
		
		mask.setSize( width, height );
		gameObject.transform.isRoot = true;
		
		return gameObject;
	}
	
}