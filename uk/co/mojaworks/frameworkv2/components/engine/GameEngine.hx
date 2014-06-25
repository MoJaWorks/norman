package uk.co.mojaworks.frameworkv2.components.engine ;

import openfl.display.Stage;
import openfl.events.Event;
import uk.co.mojaworks.frameworkv2.components.director.Director;
import uk.co.mojaworks.frameworkv2.core.Viewport;
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
	
	public function new( stage ) 
	{
		super();
		
		initCore( stage );
		addCoreModules();
		createView();

	}
	
	private function initCore( stage : Stage ) : Void {
		Core.init( stage, 1000, 600 );
	}
	
	private function addCoreModules() : Void {
		
		// Add self to core so can be retrieved by other components later
		core.root.add( this );
		
	}
	
	private function createView() : Void {
			
		core.root.addChild( core.root.get(Director).root );
		
		// Respond to any changes in orientation/size
		core.stage.addEventListener( Event.RESIZE, resize );
		resize();
		
	}
	
	private function resize( e : Event = null ) : Void {
		
		// Resize the viewport to scale everything to the screen size
		core.viewport.resize();
		
		// Resize any active screens/panels
		core.root.get(Director).resize();
		
		trace("Viewport is now", core.viewport.scale, core.viewport.stageRect );
		
		// Resize all windows so they can take advantage of margins
		//core.get(Director).resize();
		
	}
	
}