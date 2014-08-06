package uk.co.mojaworks.norman.components.engine ;

import haxe.Timer;
import openfl.display.Stage;
import openfl.events.Event;
import uk.co.mojaworks.norman.components.director.Director;
import uk.co.mojaworks.norman.components.display.Display;
import uk.co.mojaworks.norman.components.input.Input;
import uk.co.mojaworks.norman.components.Viewport;
import uk.co.mojaworks.norman.core.Component;
import uk.co.mojaworks.norman.core.Core;
import uk.co.mojaworks.norman.renderer.Renderer;

/**
 * This class is intended to be extended and used as a root controller
 * It sets up the game, viewport and some core components
 * 
 * @author Simon
 */

class GameEngine extends Component
{
	
	var _renderer : Renderer;
	
	var _lastTick : Float = 0;
	var _elapsed : Float = 0;
	
	public function new( stage : Stage, stageWidth : Int, stageHeight : Int ) 
	{
		super();
		
		initCore( stage );
		initViewport( stageWidth, stageHeight );
		initCoreModules();
		initCanvas();
		initView();
		
		core.stage.addEventListener( Event.ENTER_FRAME, onEnterFrame );
		core.stage.addEventListener( Event.RESIZE, resize );
		
		resize();
		
		onStartupComplete();

	}
	
	/**
	 * Boot
	 */
	
	private function initCore( stage : Stage ) : Void {
		Core.init( stage );
	}
	
	private function initViewport( stageWidth : Int, stageHeight : Int ) : Void {
		
		var viewport : Viewport = new Viewport();
		viewport.init( stageWidth, stageHeight );
		core.root.add( viewport );
		
	}
	
	private function initCoreModules() : Void {
		
		// Add self to core so can be retrieved by other components later
		core.root.add( this );
		core.root.add( new Display() );
		core.root.add( new Director() );
		core.root.add( new Input() );
		
		
	}
	
	private function initCanvas( ) : Void {
		
		_renderer = new Renderer();		
		_renderer.init( core.root.get(Viewport).screenRect );
		
		// Flash stage3D doesn't need adding to display list
		#if ( !flash ) 
			core.stage.addChild( _renderer.getDisplayObject() );
		#end
		
		core.root.add( _renderer );
		
	}
	
	private function initView() : Void {
		core.root.addChild( core.root.get(Director).root );
	}
	
	private function onStartupComplete() : Void {
		// Override
	}
	
	
	/**
	 * Ongoing
	 */
	
	private function resize( e : Event = null ) : Void {
						
		// Resize the viewport to scale everything to the screen size
		core.root.get(Viewport).resize();
		
		_renderer.resize( core.root.get(Viewport).screenRect );
			
		// Resize any active screens/panels
		core.root.get(Director).resize();
		
	}
	
	private function onEnterFrame( e : Event ) : Void {
				
		_elapsed = Timer.stamp() - _lastTick;
		_lastTick = Timer.stamp();
		
		onUpdate( _elapsed );
		
		_renderer.render( core.root );
		
	}
	
	override public function onUpdate( seconds : Float ) : Void {
		// This is the one that will be overriden
		core.root.get(Input).onUpdate( seconds );
	}
	
	/**
	 * End
	 */
	
	override public function destroy():Void 
	{
		super.destroy();
		
		core.stage.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
	}
		
	
	
}