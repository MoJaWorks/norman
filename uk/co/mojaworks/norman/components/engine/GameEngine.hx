package uk.co.mojaworks.norman.components.engine ;

import haxe.Timer;
import openfl.display.Stage;
import openfl.events.Event;
import uk.co.mojaworks.norman.components.director.Director;
import uk.co.mojaworks.norman.components.display.Display;
import uk.co.mojaworks.norman.components.display.Fill;
import uk.co.mojaworks.norman.components.display.Image;
import uk.co.mojaworks.norman.components.Viewport;
import uk.co.mojaworks.norman.core.Component;
import uk.co.mojaworks.norman.core.Core;
import uk.co.mojaworks.norman.core.GameObject;
import uk.co.mojaworks.norman.renderer.Renderer;

/**
 * This class is intended to be extended and used as a root
 * It sets up the core and viewport and some core components
 * 
 * @author Simon
 */

class GameEngine extends Component
{
	
	var _renderer : Renderer;
	
	var _lastTick : Float = 0;
	var _elapsed : Float = 0;
	
	public function new( stage ) 
	{
		super();
		
		initCore( stage );
		initViewport();
		initCoreModules();
		initCanvas();
		initView();
		
		core.stage.addEventListener( Event.ENTER_FRAME, onEnterFrame );
		
		onStartupComplete();

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
		core.root.add( new Display() );
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
		
		_renderer.resize( core.root.get(Viewport).screenRect );
			
		// Resize any active screens/panels
		core.root.get(Director).resize();
		
	}
	
	private function initCanvas( ) : Void {
		
		_renderer = new Renderer();		
		_renderer.init( core.root.get(Viewport).screenRect );
		
		#if ( !flash ) 
			core.stage.addChild( _renderer.getDisplayObject() );
		#end
		
		core.root.add( _renderer );
		
	}
	
	private function onStartupComplete() : Void {
		// Override
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		
		core.stage.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
	}
		
	private function onEnterFrame( e : Event ) : Void {
				
		_elapsed = Timer.stamp() - _lastTick;
		_lastTick = Timer.stamp();
		
		onUpdate( _elapsed );
		_renderer.render( core.root );
	}
	
}