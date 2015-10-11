package uk.co.mojaworks.norman.systems.ui;
import uk.co.mojaworks.norman.display.Sprite;
import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * ...
 * @author Simon
 */
class UISystem
{

	var _sprites : LinkedList<IUISprite>;
	
	public function new() 
	{
		_sprites = new LinkedList<IUISprite>();
	}
	
	public function addUISprite( sprite : IUISprite ) : Void {
		_sprites.push( sprite );
	}
	
	public function removeSprite( sprite : IUISprite ) : Void {
		_sprites.remove( sprite );
	}
	
	public function update( sprite : IUISprite ) : Void {
		
		//Bool hasHit = false;
		
		//for ( sprite in _sprites ) {
			
			//sprite.getUIComponent().wasMouseDownLastFrame = sprite.getUIComponent().mouseDown();
			//if ( sprite.getUITargetSprite().hitTest( 
			
		//}
		
		
	}
	
	public function displayListChanged() : Void {
		
		// Sort the objects	descending	
		
		var aSpr : Sprite;
		var bSpr : Sprite;
		
		_sprites.sort( function( a, b ) {
			
			aSpr = cast a;
			bSpr = cast b;
			
			if ( aSpr.displayOrder < bSpr.displayOrder ) return 1;
			else return -1;
			
		});
	}
		
}