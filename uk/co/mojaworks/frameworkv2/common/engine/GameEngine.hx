package uk.co.mojaworks.frameworkv2.common.engine;

import openfl.display.Stage;
import openfl.events.Event;
import uk.co.mojaworks.frameworkv2.common.view.Viewport;
import uk.co.mojaworks.frameworkv2.core.Component;
import uk.co.mojaworks.frameworkv2.core.Core;

/**
 * This class is intended to be extended and used as a root
 * It sets up the core and viewport and some core components
 * 
 * @author Simon
 */

class GameEngine extends Component
{
	
	public var viewport(default, null) : Viewport;
	
	public function new( stage ) 
	{
		super();
		
		initCore( stage );
		addCoreModules();
		createView();

	}
	
	private function initCore( stage : Stage ) : Void {
		Core.init( stage );
	}
	
	private function addCoreModules() : Void {
		//core.add( this );
		//core.add( new Messenger() );
		//core.add( new Director() );
	}
	
	private function createView() : Void {
		
		// Create a viewport to scale everything to fit different screens
		viewport = new Viewport();
		
		// Add the director to the viewport 
		//viewport.display.addChild( core.get(Director).root );
		
		// Respond to any changes in orientation/size
		core.stage.addEventListener( Event.RESIZE, resize );
		resize();
		
	}
	
	private function resize( e : Event = null ) : Void {
		
		// Resize the viewport to scale everything to the screen size
		viewport.resize();
		
		// Resize all windows so they can take advantage of margins
		//core.get(Director).resize();
		
	}
	
}