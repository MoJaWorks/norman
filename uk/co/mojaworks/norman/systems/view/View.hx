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
		
		trace( "Resizing view", Systems.viewport.scale );
			
		root.transform.scaleX = Systems.viewport.scale;
		root.transform.scaleY = Systems.viewport.scale;
		root.transform.x = Systems.viewport.marginLeft * Systems.viewport.scale;
		root.transform.y = Systems.viewport.marginTop * Systems.viewport.scale;
		
		trace( root.transform.worldMatrix );
		if ( root.children.length > 0 ) {
			trace( root.children.get(0).transform.worldMatrix );
		}
		
		for ( sprite in sprites ) {
			sprite.resize();
		}
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