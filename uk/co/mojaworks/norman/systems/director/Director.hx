package uk.co.mojaworks.norman.systems.director;
import uk.co.mojaworks.norman.display.Sprite;

/**
 * ...
 * @author Simon
 */
class Director
{

	public var root : Sprite;
	public var sprites : Map<String,Sprite>;
	
	var displayStack : Array<Screen>;
	
	public function new() 
	{
		sprites = new Map<String,Sprite>();
		displayStack = [];
		root = new Sprite();
	}
	
	public function moveToScreen( screen : Screen, transition : Transition = null, delay : Float = 0 ) : Void {
		
		if ( transition == null ) transition = new Transition();
		transition.transition( screen, displayStack, delay );
		
		displayStack = [];
		displayStack.push( screen );
		
	}
	
	public function addScreen( screen : Screen, transition : Transition = null, delay : Float = 0 ) : Void {
		
		if ( transition == null ) transition = new Transition();
		transition.transition( screen, null, delay );
		
		displayStack.push( screen );
	}
	
	public function update( seconds : Float ) : Void 
	{
		for ( screen in displayStack ) {
			screen.update( seconds );
		}
	}
	
	public function resize() : Void {
		
		root.scaleX = Systems.viewport.scale;
		root.scaleY = Systems.viewport.scale;
		root.x = Systems.viewport.marginLeft * Systems.viewport.scale;
		root.y = Systems.viewport.marginTop * Systems.viewport.scale;
		
		for ( screen in displayStack ) {
			screen.resize();
		}
	}
	
	public function registerSprite( sprite : Sprite, id : String ) : Void {
		sprites.set( id, sprite );
	}
	
	public function getSpriteWithID( id : String ) : Sprite {
		return sprites.get( id );
	}
		
	public function removeSprite( id : String ) : Void {
		sprites.remove( id );
	}
		
}