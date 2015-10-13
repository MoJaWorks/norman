package uk.co.mojaworks.norman.systems.ui;
import lime.math.Vector2;
import uk.co.mojaworks.norman.display.Sprite;
import uk.co.mojaworks.norman.systems.input.InputSystem.MouseButton;
import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * ...
 * @author Simon
 */
class UISystem
{

	var _uiComponents : LinkedList<UIComponent>;
	
	public function new() 
	{
		_uiComponents = new LinkedList<UIComponent>();
	}
	
	public function add( component : UIComponent ) : Void {
		_uiComponents.push( component );
		displayListChanged();
	}
	
	public function remove( component : UIComponent ) : Void {
		_uiComponents.remove( component );
	}
	
	public function update( seconds : Float ) : Void {
		
		//trace("Update UI:", _sprites.length, _sprites.first.next == null );
		
		var hasHit : Bool = false;
		var mousePosition : Vector2 = Systems.input.mousePosition;
		var mouseDown : Bool = Systems.input.mouseIsDown[ MouseButton.Left ];
		
		// First reset all
		for ( ui in _uiComponents ) {
			
			ui.wasMouseDownLastFrame = ui.isMouseDown;
			ui.wasMouseOverLastFrame = ui.isMouseOver;
			
			ui.isMouseDown = false;
			ui.isMouseOver = false;
			ui.isCurrentTarget = false;
			
		}
		
		// then find the active sprite
		for ( ui in _uiComponents ) {
			
			//trace("Checking sprite", _sprites.length );
			
			if ( ui.enabled && !hasHit ) {			
				
				if ( ui.targetSprite.hitTest( mousePosition ) ) {
					
					ui.isMouseOver = true;
					if ( !ui.wasMouseOverLastFrame ) {
						if ( mouseDown ) ui.wasMouseDownElsewhere = true;
						ui.mouseOver.dispatch( new MouseEvent( MouseButton.None ) );
					}
					
					if ( mouseDown ) {
						
						ui.isMouseDown = true;
						if ( !hasHit && !ui.wasMouseDownLastFrame && !ui.wasMouseDownElsewhere ) {
							ui.mouseDown.dispatch(new MouseEvent( MouseButton.Left ) );
						}
						
					}else {

						ui.wasMouseDownElsewhere = false;
						if ( !hasHit && ui.wasMouseDownLastFrame ) {
							ui.mouseUp.dispatch( new MouseEvent( MouseButton.Left ) );
							if ( !ui.wasMouseDownElsewhere ) ui.clicked.dispatch( new MouseEvent( MouseButton.Left ) );
						}
						
					}
					
					ui.isCurrentTarget = !hasHit;
					hasHit = true;
					
				}else {
					
					if ( ui.wasMouseOverLastFrame ) ui.mouseOut.dispatch( new MouseEvent( MouseButton.None ) );
					ui.wasMouseDownElsewhere = false;
					
				}
			}else {
				
				if ( ui.wasMouseOverLastFrame ) ui.mouseOut.dispatch( new MouseEvent( MouseButton.None ) );
				ui.wasMouseDownElsewhere = false;
				
			}
			
		}
		
		
	}
	
	public function displayListChanged() : Void {
		
		// Sort the objects	descending	
		
		if ( _uiComponents.length == 0 ) return;
		
		var aSpr : Sprite;
		var bSpr : Sprite;
		
		_uiComponents.sort( function( a, b ) {
			
			if ( a.ownerSprite.displayOrder < b.ownerSprite.displayOrder ) return 1;
			else return -1;
			
		});
		
	}
		
}