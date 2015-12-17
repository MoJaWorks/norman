package uk.co.mojaworks.norman.systems.ui;
import lime.ui.Mouse;
import lime.ui.MouseCursor;
import uk.co.mojaworks.norman.components.delegates.BaseUIDelegate;
import uk.co.mojaworks.norman.components.renderer.BaseRenderer;
import uk.co.mojaworks.norman.systems.input.InputSystem.MouseButton;
import uk.co.mojaworks.norman.systems.ui.MouseEvent.MouseEventType;
import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * ...
 * @author Simon
 */

class UISystem
{

	#if mobile
	public var isMobile : Bool = true;
	#else
	public var isMobile : Bool = false;
	#end
	
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
		var hitTarget : BaseRenderer;
		
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
			
			//if ( ui.gameObject.id == "creditbutton" ) trace("Checking sprite" );
			
			if ( ui.isEnabled() && !hasHit ) {			
				
				hitTarget = ui.hitTarget.renderer;
				
				if ( hitTarget != null && hitTarget.hitTest( Systems.input.mousePosition ) ) {
					
					ui.isMouseOver = true;
					
					#if !mobile 
						Mouse.cursor = ui.cursor;
					#end
					
					if ( !ui.wasMouseOverLastFrame ) {
						for ( i in 0...3 ) {
							if ( Systems.input.mouseIsDown[i] && Systems.input.mouseWasDownLastFrame[i] ) ui.wasMouseButtonDownElsewhere[i] = true;
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

							if ( ui.wasMouseButtonDownLastFrame[i] )
							{
								events.push( new MouseEvent( MouseEventType.Up, ui, i ) );

								if ( !ui.wasMouseButtonDownElsewhere[i] )
								{
									events.push( new MouseEvent( MouseEventType.Click, ui, i ) );
								}
							}
							ui.wasMouseButtonDownElsewhere[i] = false;

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
			
		}
		
		if ( !hasHit ) {
			Mouse.cursor = MouseCursor.DEFAULT;
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