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
		
		root.scaleX = Systems.viewport.scale;
		root.scaleY = Systems.viewport.scale;
		root.x = Systems.viewport.marginLeft * Systems.viewport.scale;
		root.y = Systems.viewport.marginTop * Systems.viewport.scale;
		
	}
	
	public function registerSprite( id : String, sprite : Sprite ) : Void {
		sprites.set( id, sprite );
	}
	
	public function getSpriteWithID( id : String ) : Void {
		sprites.get( id );
	}
		
	public function removeSprite( id : String ) : Void {
		sprites.remove( id );
	}
	
}