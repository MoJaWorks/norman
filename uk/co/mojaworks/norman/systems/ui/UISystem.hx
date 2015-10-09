package uk.co.mojaworks.norman.systems.ui;
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
		
	}
	
	public function displayListChanged() : Void {
		
		// Sort the objects		
	}
		
}