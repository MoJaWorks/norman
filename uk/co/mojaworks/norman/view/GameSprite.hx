package uk.co.mojaworks.norman.view;

import openfl.display.Sprite;

/**
 * ...
 * @author Simon
 */
class GameSprite extends Sprite
{

	public function new() 
	{
		super();
		
	}
	
	public function dispose() : Void {
		if ( parent != null ) parent.removeChild( this );
		while ( numChildren > 0 ) {
			if ( Std.is( getChildAt(0), GameSprite ) ) {
				var gameChild : GameSprite = cast getChildAt(0);
				gameChild.dispose();
			}else {
				removeChildAt( 0 );
			}
		}
	}
	
}