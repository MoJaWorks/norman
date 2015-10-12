package uk.co.mojaworks.norman.systems.ui;
import lime.math.Vector2;
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
		displayListChanged();
	}
	
	public function removeSprite( sprite : IUISprite ) : Void {
		_sprites.remove( sprite );
	}
	
	public function update( seconds : Float ) : Void {
		
		//trace("Update UI:", _sprites.length, _sprites.first.next == null );
		
		var hasHit : Bool = false;
		var mousePosition : Vector2 = Systems.input.mousePosition;
		var mouseDown : Bool = Systems.input.mouseIsDown;
		var ui : UIComponent;
		
		// First reset all
		for ( sprite in _sprites ) {
			
			ui = sprite.getUIComponent();
			ui.wasMouseDownLastFrame = ui.isMouseDown;
			ui.wasMouseOverLastFrame = ui.isMouseOver;
			
			ui.isMouseDown = false;
			ui.isMouseOver = false;
			ui.isCurrentTarget = false;
			
		}
		
		// then find the active sprite
		for ( sprite in _sprites ) {
			
			ui = sprite.getUIComponent();
			
			//trace("Checking sprite", _sprites.length );
			
			if ( ui.enabled && !hasHit ) {			
				
				if ( sprite.getUITargetSprite().hitTest( mousePosition ) ) {
					
					ui.isMouseOver = true;
					if ( !ui.wasMouseOverLastFrame ) {
						if ( mouseDown ) ui.wasMouseDownElsewhere = true;
						ui.mouseOver.dispatch();
					}
					
					if ( mouseDown ) {
						
						ui.isMouseDown = true;
						if ( !hasHit && !ui.wasMouseDownLastFrame && !ui.wasMouseDownElsewhere ) {
							ui.mouseDown.dispatch();
						}
						
					}else {

						ui.wasMouseDownElsewhere = false;
						if ( !hasHit && ui.wasMouseDownLastFrame ) {
							ui.mouseUp.dispatch();
							if ( !ui.wasMouseDownElsewhere ) ui.clicked.dispatch();
						}
						
					}
					
					ui.isCurrentTarget = !hasHit;
					hasHit = true;
					
				}else {
					
					if ( ui.wasMouseOverLastFrame ) ui.mouseOut.dispatch();
					ui.wasMouseDownElsewhere = false;
					
				}
			}else {
				
				if ( ui.wasMouseOverLastFrame ) ui.mouseOut.dispatch();
				ui.wasMouseDownElsewhere = false;
				
			}
			
		}
		
		
	}
	
	public function displayListChanged() : Void {
		
		// Sort the objects	descending	
		
		if ( _sprites.length == 0 ) return;
		
		var aSpr : Sprite;
		var bSpr : Sprite;
		
		_sprites.sort( function( a, b ) {
			
			aSpr = cast a;
			bSpr = cast b;
			
			trace("Comparing ", aSpr.displayOrder, "to", bSpr.displayOrder, aSpr.displayOrder < bSpr.displayOrder );
			
			if ( aSpr.displayOrder < bSpr.displayOrder ) return 1;
			else return -1;
			
		});
		
	}
		
}