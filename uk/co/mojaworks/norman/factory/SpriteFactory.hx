package uk.co.mojaworks.norman.factory;
import uk.co.mojaworks.norman.components.renderer.ImageRenderer;
import uk.co.mojaworks.norman.components.renderer.Mask;
import uk.co.mojaworks.norman.components.renderer.RenderTexture;
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