package uk.co.mojaworks.norman.systems.ui;
import lime.ui.Mouse;
import lime.ui.MouseCursor;
import uk.co.mojaworks.norman.components.delegates.BaseUIDelegate;
import uk.co.mojaworks.norman.components.renderer.BaseRenderer;
import uk.co.mojaworks.norman.core.io.pointer.PointerInput;
import uk.co.mojaworks.norman.core.io.pointer.PointerInput.MouseButton;
import uk.co.mojaworks.norman.systems.SubSystem;
import uk.co.mojaworks.norman.systems.ui.PointerEvent.PointerEventType;
import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * ...
 * @author Simon
 */

class UISystem extends SubSystem
{

	#if mobile
	public var isMobile : Bool = true;
	#else
	public var isMobile : Bool = false;
	#end
	
	var _uiComponents : LinkedList<BaseUIDelegate>;
	
	public function new() 
	{
		super();
		_uiComponents = new LinkedList<BaseUIDelegate>();
	}
	
	public function add( component : BaseUIDelegate ) : Void {
		_uiComponents.push( component );
		displayListChanged();
	}
	
	public function remove( component : BaseUIDelegate ) : Void {
		_uiComponents.remove( component );
	}
	
	override public function update( seconds : Float ) : Void {
		
		var hasHit : Bool = false;
		var events : Array<PointerEvent> = [];
		var event : PointerEvent;
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
			
			if ( ui.isEnabled() && !hasHit ) {			
				
				hitTarget = ui.hitTarget.renderer;
				
				if ( hitTarget != null && hitTarget.hitTest( core.io.pointer.get(0).position ) ) {
					
					ui.isMouseOver = true;
					
					#if !mobile 
						Mouse.cursor = ui.cursor;
					#end
					
					if ( !ui.wasMouseOverLastFrame ) {
						for ( i in 0...PointerInput.MAX_BUTTONS ) {
							if ( core.io.pointer.get(0).buttonIsDown(i) && core.io.pointer.get(0).buttonWasDownLastFrame(i) ) ui.wasMouseButtonDownElsewhere[i] = true;
						}
						
						events.push( new PointerEvent( PointerEventType.Over, ui, 0, MouseButton.None ) );
						
					}
					
					for ( i in 0...PointerInput.MAX_BUTTONS ) {
						if ( core.io.pointer.get(0).buttonIsDown(i) ) {
							
							ui.isMouseButtonDown[i] = true;
							if ( !ui.wasMouseButtonDownLastFrame[i] && !ui.wasMouseButtonDownElsewhere[i] ) 
							{
								events.push( new PointerEvent( PointerEventType.Down, ui, 0, i ) );
							}
							
						}else {

							if ( ui.wasMouseButtonDownLastFrame[i] )
							{
								events.push( new PointerEvent( PointerEventType.Up, ui, 0, i ) );

								if ( !ui.wasMouseButtonDownElsewhere[i] )
								{
									events.push( new PointerEvent( PointerEventType.Click, ui, 0, i ) );
								}
							}
							ui.wasMouseButtonDownElsewhere[i] = false;

						}
					}
					ui.isCurrentTarget = !hasHit;
					hasHit = true;
					
				}else {
					
					if ( ui.wasMouseOverLastFrame ) {
						events.push( new PointerEvent( PointerEventType.Out, ui, 0, MouseButton.None ) );
					}
					
					for ( i in 0...PointerInput.MAX_BUTTONS ) {
						ui.wasMouseButtonDownElsewhere[i] = false;
					}
					
				}
			}else {
				
				if ( ui.wasMouseOverLastFrame ) {
					events.push( new PointerEvent( PointerEventType.Out, ui, 0, MouseButton.None ) );
				}
				for ( i in 0...PointerInput.MAX_BUTTONS ) {
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