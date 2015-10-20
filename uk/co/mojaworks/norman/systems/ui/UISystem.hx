package uk.co.mojaworks.norman.systems.ui;
import uk.co.mojaworks.norman.components.delegates.BaseUIDelegate;
import uk.co.mojaworks.norman.components.renderer.AbstractRenderer;
import uk.co.mojaworks.norman.systems.input.InputSystem.MouseButton;
import uk.co.mojaworks.norman.systems.ui.MouseEvent.MouseEventType;
import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * ...
 * @author Simon
 */

class UISystem
{

	var _uiComponents : LinkedList<BaseUIDelegate>;
	
	public function new() 
	{
		_uiComponents = new LinkedList<BaseUIDelegate>();
	}
	
	public function add( component : BaseUIDelegate ) : Void {
		_uiComponents.push( component );
		displayListChanged();
	}
	
	public function remove( component : BaseUIDelegate ) : Void {
		_uiComponents.remove( component );
	}
	
	public function update( seconds : Float ) : Void {
		
		//trace("Update UI:", _uiComponents.length );
		
		var hasHit : Bool = false;
		var events : Array<MouseEvent> = [];
		var event : MouseEvent;
		var hitTarget : AbstractRenderer;
		
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
				
				hitTarget = ui.hitTarget.renderer;
				
				if ( hitTarget != null && hitTarget.hitTest( Systems.input.mousePosition ) ) {
					
					ui.isMouseOver = true;
					if ( !ui.wasMouseOverLastFrame ) {
						for ( i in 0...3 ) {
							if ( Systems.input.mouseIsDown[i] ) ui.wasMouseButtonDownElsewhere[i] = true;
						}
						
						events.push( new MouseEvent( MouseEventType.Over, ui, MouseButton.None ) );
						
					}
					
					for ( i in 0...3 ) {
						if ( Systems.input.mouseIsDown[i] ) {
							
							ui.isMouseButtonDown[i] = true;
							if ( !ui.wasMouseButtonDownLastFrame[i] && !ui.wasMouseButtonDownElsewhere[i] ) 
							{
								events.push( new MouseEvent( MouseEventType.Down, ui, i ) );
							}
							
						}else {

							ui.wasMouseButtonDownElsewhere[i] = false;
							if ( ui.wasMouseButtonDownLastFrame[i] ) 
							{
								events.push( new MouseEvent( MouseEventType.Up, ui, i ) );
								
								if ( !ui.wasMouseButtonDownElsewhere[i] ) 
								{
									events.push( new MouseEvent( MouseEventType.Click, ui, i ) );
								}
							}
							
						}
					}
					ui.isCurrentTarget = !hasHit;
					hasHit = true;
					
				}else {
					
					if ( ui.wasMouseOverLastFrame ) {
						events.push( new MouseEvent( MouseEventType.Out, ui, MouseButton.None ) );
					}
					
					for ( i in 0...3 ) {
						ui.wasMouseButtonDownElsewhere[i] = false;
					}
					
				}
			}else {
				
				if ( ui.wasMouseOverLastFrame ) {
					events.push( new MouseEvent( MouseEventType.Out, ui, MouseButton.None ) );
				}
				for ( i in 0...3 ) {
					ui.wasMouseButtonDownElsewhere[i] = false;
				}
				
			}
			
		}
		
		for ( event in events ) {
			
			event.target.processEvent( event );
			
			/*if ( event.target.enabled ) {
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
			}*/
			
		}
		
		
	}
	
	public function displayListChanged() : Void {
		
		// Sort the objects	descending	
		
		if ( _uiComponents.length == 0 ) return;
		
		_uiComponents.sort( function( a, b ) {
			
			if ( a.gameObject.transform.displayOrder < b.gameObject.transform.displayOrder ) return 1;
			else return -1;
			
		});
		
	}
		
}