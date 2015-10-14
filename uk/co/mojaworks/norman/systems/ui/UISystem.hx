package uk.co.mojaworks.norman.systems.ui;
import lime.math.Vector2;
import uk.co.mojaworks.norman.display.Sprite;
import uk.co.mojaworks.norman.systems.input.InputSystem.MouseButton;
import uk.co.mojaworks.norman.systems.ui.MouseEvent.MouseEventType;
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
		var events : Array<MouseEvent> = [];
		var event : MouseEvent;
		
		// First reset all
		for ( ui in _uiComponents ) {
			
			for ( i in 0...3 ) {
				ui.wasMouseButtonDownLastFrame[i] = ui.isMouseButtonDown[i];
				ui.isMouseButtonDown[i] = false;
			}
			
			ui.wasMouseOverLastFrame = ui.isMouseOver;
			ui.isMouseOver = false;
			ui.isCurrentTarget = false;
			
		}
		
		// then find the active sprite
		for ( ui in _uiComponents ) {
			
			//trace("Checking sprite", _sprites.length );
			
			if ( ui.enabled && !hasHit ) {			
				
				if ( ui.targetSprite.hitTest( Systems.input.mousePosition ) ) {
					
					ui.isMouseOver = true;
					if ( !ui.wasMouseOverLastFrame ) {
						for ( i in 0...3 ) {
							if ( Systems.input.mouseIsDown[i] ) ui.wasMouseButtonDownElsewhere[i] = true;
						}
						//if ( mouseDown ) ui.wasMouseDownElsewhere = true;
						//ui.mouseOver.dispatch( new MouseEvent( MouseButton.None ) );
						event = new MouseEvent();
						event.button = MouseButton.None;
						event.type = MouseEventType.Over;
						event.target = ui;
						events.push( event );
					}
					
					for ( i in 0...3 ) {
						if ( Systems.input.mouseIsDown[i] ) {
							
							ui.isMouseButtonDown[i] = true;
							if ( !ui.wasMouseButtonDownLastFrame[i] && !ui.wasMouseButtonDownElsewhere[i] ) {
								//ui.mouseDown.dispatch(new MouseEvent() );
								event = new MouseEvent();
								event.button = i;
								event.type = MouseEventType.Down;
								event.target = ui;
								events.push( event );
							}
							
						}else {

							ui.wasMouseButtonDownElsewhere[i] = false;
							if ( ui.wasMouseButtonDownLastFrame[i] ) {
								//ui.mouseUp.dispatch( new MouseEvent( MouseButton.Left ) );
								//if ( !ui.wasMouseDownElsewhere ) ui.clicked.dispatch( new MouseEvent( MouseButton.Left ) );
								
								event = new MouseEvent();
								event.button = i;
								event.type = MouseEventType.Up;
								event.target = ui;
								events.push( event );
								
								if ( !ui.wasMouseButtonDownElsewhere[i] ) {
									event = new MouseEvent();
									event.button = i;
									event.type = MouseEventType.Click;
									event.target = ui;
									events.push( event );
								}
							}
							
						}
					}
					ui.isCurrentTarget = !hasHit;
					hasHit = true;
					
				}else {
					
					if ( ui.wasMouseOverLastFrame ) {
						//ui.mouseOut.dispatch( new MouseEvent( MouseButton.None ) );
						event = new MouseEvent();
						event.target = ui;
						event.type = MouseEventType.Out;
						event.button = MouseButton.None;
						events.push( event );
					}
					
					for ( i in 0...3 ) {
						ui.wasMouseButtonDownElsewhere[i] = false;
					}
					
				}
			}else {
				
				if ( ui.wasMouseOverLastFrame ) {
					//ui.mouseOut.dispatch( new MouseEvent( MouseButton.None ) );
					event = new MouseEvent();
					event.target = ui;
					event.type = MouseEventType.Out;
					event.button = MouseButton.None;
					events.push( event );
				}
				for ( i in 0...3 ) {
					ui.wasMouseButtonDownElsewhere[i] = false;
				}
				
			}
			
		}
		
		for ( event in events ) {
			
			if ( event.target.enabled ) {
				switch( event.type  ) {
					case MouseEventType.Up:
						event.target.mouseUp.dispatch( event );
					case MouseEventType.Down:
						event.target.mouseDown.dispatch( event );
					case MouseEventType.Out:
						event.target.mouseOut.dispatch( event );
					case MouseEventType.Over:
						event.target.mouseOver.dispatch( event );
					case MouseEventType.Click:
						event.target.clicked.dispatch( event );
				}
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