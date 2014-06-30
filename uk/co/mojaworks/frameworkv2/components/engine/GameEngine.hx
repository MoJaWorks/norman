package uk.co.mojaworks.frameworkv2.components.engine ;

import openfl.display.Stage;
import openfl.events.Event;
import uk.co.mojaworks.frameworkv2.components.director.Director;
import uk.co.mojaworks.frameworkv2.components.Viewport;
import uk.co.mojaworks.frameworkv2.core.Component;
import uk.co.mojaworks.frameworkv2.core.Core;
import uk.co.mojaworks.frameworkv2.renderer.Renderer;

/**
 * This class is intended to be extended and used as a root
 * It sets up the core and viewport and some core components
 * 
 * @author Simon
 */

class GameEngine extends Component
{
	
	var _renderer : Renderer;
	
	public function new( stage ) 
	{
		super();
		
		initCore( stage );
		initViewport();
		initCoreModules();
		initView();
		initCanvas();

	}
	
	private function initCore( stage : Stage ) : Void {
		Core.init( stage );
	}
	
	private function initViewport( ) : Void {
		
		var viewport : Viewport = new Viewport();
		viewport.init( 1000, 600 );
		core.root.add( viewport );
		
	}
	
	private function initCoreModules() : Void {
		
		// Add self to core so can be retrieved by other components later
		core.root.add( this );
		core.root.add( new Director() );
		
	}
	
	private function initView() : Void {
			
		core.root.addChild( core.root.get(Director).root );
		
		// Respond to any changes in orientation/size
		core.stage.addEventListener( Event.RESIZE, resize );
		resize();
		
	}
	
	private function resize( e : Event = null ) : Void {
		
		// Resize the viewport to scale everything to the screen size
		core.root.get(Viewport).resize();
		
		// Resize any active screens/panels
		core.root.get(Director).resize();
		
	}
	
	private function initCanvas( ) : Void {
		
		_renderer = new Renderer();		
		_renderer.init( core.root.get(Viewport).screenRect );
		core.stage.addChild( _renderer.getDisplayObject() );
		
	}
	
}