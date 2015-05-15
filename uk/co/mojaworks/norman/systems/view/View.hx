package uk.co.mojaworks.norman.systems.view;
import uk.co.mojaworks.norman.display.Sprite;

/**
 * ...
 * @author test
 */
class View
{

	public var root : Sprite;
	public var sprites : Map<String,Sprite>;
	
	public function new() 
	{
		sprites = new Map<String,Sprite>();
	}
	
	public function init() : Void {
		root = new Sprite();
	}
	
	public function resize() : Void {
		for ( sprite in sprites ) {
			sprite.resize();
		}
	}
	
	public function registerSprite( sprite : Sprite ) : Void {
		sprites.set( sprite.id, sprite );
	}
	
	public function getSpriteWithID( id : String ) : Void {
		sprites.get( id );
	}
		
	public function removeSprite( id : String ) : Void {
		sprites.remove( id );
	}
	
}