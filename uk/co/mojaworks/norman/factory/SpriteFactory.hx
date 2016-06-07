package uk.co.mojaworks.norman.factory;
import geoff.math.Rect;
import geoff.renderer.Texture;
import geoff.utils.Color;
import uk.co.mojaworks.norman.components.renderer.ImageRenderer;
import uk.co.mojaworks.norman.components.renderer.MaskedRenderTextureRenderer;
import uk.co.mojaworks.norman.components.renderer.RenderTextureRenderer;
import uk.co.mojaworks.norman.components.renderer.Scale3ImageRenderer;
import uk.co.mojaworks.norman.components.renderer.Scale3ImageRenderer.Scale3Type;
import uk.co.mojaworks.norman.components.renderer.Scale9ImageRenderer;
import uk.co.mojaworks.norman.components.renderer.ShapeRenderer;
import uk.co.mojaworks.norman.components.renderer.ShapeRenderer.FillShape;
import uk.co.mojaworks.norman.components.renderer.TextRenderer;
import uk.co.mojaworks.norman.utils.ImagePath.ImageAssetPath;

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
	
	public static function createImageSprite( texture : Texture, ?subImageId : String = null, ?name : String = null ) : GameObject {
		
		var gameObject : GameObject = ObjectFactory.createGameObject( name );
		gameObject.add( new ImageRenderer( texture, subImageId ) );
		
		return gameObject;
	}
	
	public static function createImageSpriteFromAsset( image : ImageAssetPath, ?name : String = null ) : GameObject {
			
		var gameObject : GameObject = ObjectFactory.createGameObject( name );
		gameObject.add( new ImageRenderer( Core.instance.renderer.createTextureFromAsset( image.asset ), image.subImageId ) );
		
		return gameObject;
	}
	
	public static function createScale9ImageSprite( texture : Texture, rect : Rect, ?subImageId : String = null, ?name : String = null ) : GameObject {
		
		var gameObject : GameObject = ObjectFactory.createGameObject( name );
		var renderer : Scale9ImageRenderer = cast gameObject.add( new Scale9ImageRenderer( texture, subImageId ) );
		renderer.setScale9Rect( rect );
		
		return gameObject;
	}
	
	public static function createScale9ImageSpriteFromAsset( image : ImageAssetPath, rect : Rect, ?name : String = null ) : GameObject {
		
		var gameObject : GameObject = ObjectFactory.createGameObject( name );
		var renderer : Scale9ImageRenderer = cast gameObject.add( new Scale9ImageRenderer( Core.instance.renderer.createTextureFromAsset( image.asset ), image.subImageId ) );
		renderer.setScale9Rect( rect );
		
		return gameObject;
	}
	
	public static function createScale3ImageSprite( texture : Texture, rect : Rect, type : Scale3Type, ?subImageId : String = null, ?name : String = null ) : GameObject {
		
		var gameObject : GameObject = ObjectFactory.createGameObject( name );
		var renderer : Scale3ImageRenderer = cast gameObject.add( new Scale3ImageRenderer( texture, subImageId ) );
		renderer.setScale3Rect( rect );
		renderer.setScale3Type( type );
		
		return gameObject;
	}
	
	public static function createScale3ImageSpriteFromAsset( image : ImageAssetPath, rect : Rect, type : Scale3Type, ?name : String = null ) : GameObject {
		
		var gameObject : GameObject = ObjectFactory.createGameObject( name );
		var renderer : Scale3ImageRenderer = cast gameObject.add( new Scale3ImageRenderer( Core.instance.renderer.createTextureFromAsset( image.asset ), image.subImageId ) );
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