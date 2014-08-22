package uk.co.mojaworks.norman.engine ;

import haxe.Timer;
import openfl.display.Stage;
import openfl.events.Event;
import uk.co.mojaworks.norman.components.display.Display;
import uk.co.mojaworks.norman.components.Viewport;
import uk.co.mojaworks.norman.core.Core;
import uk.co.mojaworks.norman.core.CoreObject;
import uk.co.mojaworks.norman.renderer.Renderer;
import uk.co.mojaworks.norman.systems.director.Director;
import uk.co.mojaworks.norman.systems.input.InputSystem;

/**
 * This class is intended to be extended and used as a root controller
 * It sets up the game, viewport and some core components
 * 
 * @author Simon
 */

class NormanApp extends CoreObject
{
	public var input( default, null ) : InputSystem;
	public var viewport( default, null ) : Viewport;
	public var director( default, null ) : Director;
	public var renderer( default, null ) : Renderer;
	
	var _lastTick : Float = 0;
	var _elapsed : Float = 0;
	
	public function new( stage : Stage, stageWidth : Int, stageHeight : Int ) 
	{
		super();
		
		initCore( stage );
		initViewport( stageWidth, stageHeight );
		initCoreModules();
		initSystems();
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
		Core.init( this, stage );
	}
	
	private function initViewport( stageWidth : Int, stageHeight : Int ) : Void {
		
		viewport = new Viewport();
		viewport.init( stageWidth, stageHeight );
		
	}
	
	private function initCoreModules() : Void {
		core.root.add( new Display() );
	}
	
	private function initSystems() : Void {
		
		director = new Director();
		input = new InputSystem();
		
	}
	
	private function initCanvas( ) : Void {
		
		renderer = new Renderer();		
		renderer.init( viewport.screenRect );
		
		// Flash stage3D doesn't need adding to display list
		#if ( !flash ) 
			core.stage.addChild( renderer.getDisplayObject() );
		#end
		
		core.root.add( renderer );
		
	}
	
	private function initView() : Void {
		core.root.addChild( director.root );
	}
	
	private function onStartupComplete() : Void {
		// Override
	}
	
	
	/**
	 * Ongoing
	 */
	
	private function resize( e : Event = null ) : Void {
						
		// Resize the viewport to scale everything to the screen size
		viewport.resize();
		renderer.resize( viewport.screenRect );
			
		// Resize any active screens/panels
		director.resize();
		
	}
	
	private function onEnterFrame( e : Event ) : Void {
				
		_elapsed = Timer.stamp() - _lastTick;
		_lastTick = Timer.stamp();
		
		onUpdate( _elapsed );
		
		renderer.render( core.root );
		
	}
	
	public function onUpdate( seconds : Float ) : Void {
		// This is the one that will be overriden
		input.onUpdate( seconds );
		director.onUpdate( seconds );
	}
	
	/**
	 * End
	 */
	
	public function destroy():Void 
	{
		core.stage.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
	}
		
	
	
}