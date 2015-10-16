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
	
	public static function createFilledSprite( colour : Color, width : Float, height : Float, ?shape : FillShape = null, ?id : String = null ) : GameObject {
		
		var gameObject : GameObject = ObjectFactory.createGameObject( id );
		gameObject.addComponent( new ShapeRenderer( colour, width, height, shape ) );
		
		return gameObject;
	}
	
	public static function createImageSprite( texture : TextureData, ?subImageId : String = null, ?id : String = null ) : GameObject {
		
		var gameObject : GameObject = ObjectFactory.createGameObject( id );
		gameObject.addComponent( new ImageRenderer( texture, subImageId ) );
		
		return gameObject;
	}
	
	public static function createTextSprite( text : String, font : BitmapFont, ?id : String = null ) : GameObject {
		
		var gameObject : GameObject = ObjectFactory.createGameObject( id );
		gameObject.addComponent( new TextRenderer( text, font ) );
		
		return gameObject;
	}
	
	public static function createRenderTexture( width : Float, height : Float, ?id : String = null ) : GameObject
	{
		var gameObject : GameObject = ObjectFactory.createGameObject( id );
		
		var render : RenderTexture = new RenderTexture();
		gameObject.addComponent( render );
		
		render.setSize( Std.int(width), Std.int(height) );
		gameObject.transform.isRoot = true;
		
		return gameObject;
	}
	
	public static function createMask( texture : TextureData, ?subImageId : String = null, ?id : String = null ) : GameObject
	{
		var gameObject : GameObject = ObjectFactory.createGameObject( id );
		gameObject.addComponent( new Mask( texture, subImageId ) );
		gameObject.transform.isRoot = true;
		
		return gameObject;
	}
	
}