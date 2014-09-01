package uk.co.mojaworks.norman.engine ;

import haxe.Timer;
import openfl.display.Stage;
import openfl.events.Event;
import uk.co.mojaworks.norman.components.director.Director;
import uk.co.mojaworks.norman.components.input.Input;
import uk.co.mojaworks.norman.components.renderer.Renderer;
import uk.co.mojaworks.norman.core.Root;
import uk.co.mojaworks.norman.core.RootObject;

/**
 * This class is intended to be extended and used as a root controller
 * It sets up the game, viewport and some core components
 * 
 * @author Simon
 */

class NormanApp extends RootObject
{

	var _lastTick : Float = 0;
	var _elapsed : Float = 0;
	
	// Temp variables to store width/height for setup
	var _stageWidth : Int;
	var _stageHeight : Int;
	
	public function new( stage : Stage, stageWidth : Int, stageHeight : Int ) 
	{
		super();
		
		_stageHeight = stageHeight;
		_stageWidth = stageWidth;
		
		initRoot( stage, stageWidth, stageHeight );
		initApp();
				
		root.stage.addEventListener( Event.ENTER_FRAME, onEnterFrame );
		root.stage.addEventListener( Event.RESIZE, resize );
		
		resize();
		
		onStartupComplete();

	}
	
	/**
	 * Boot
	 */
	
	private function initRoot( stage : Stage, width : Int, height : Int ) : Void {
		
		Root.init( stage );
		
		var director : Director = new Director();
		director.setViewportTarget( width, height );
		root.add( director );
		
		root.add( new Input() );
		
		var renderer = new Renderer();
		renderer.init( director.viewport.screenRect );
		root.add( renderer );
		
		#if !flash
			root.stage.addChild( renderer.getDisplayObject() );
		#end
			
	}
	
	private function initApp() : Void {
		
	}
			
	private function onStartupComplete() : Void {
		// Override
	}
	
	
	/**
	 * Ongoing
	 */
	
	private function resize( e : Event = null ) : Void {

		
		// Resize any active screens/panels
		var director : Director = root.get(Director);
		director.resize();
		
		trace("Resize", root.transform.scaleX, root.transform.scaleY, director.viewport.scale );
				
		// Resize the viewport to scale everything to the screen size
		root.get(Renderer).resize( director.viewport.screenRect );
		
	}
	
	private function onEnterFrame( e : Event ) : Void {
				
		_elapsed = Timer.stamp() - _lastTick;
		_lastTick = Timer.stamp();
		
		onUpdate( _elapsed );
		
		root.get(Renderer).render( root );
		
	}
	
	public function onUpdate( seconds : Float ) : Void {
		// This is the one that will be overriden
		root.get(Input).onUpdate( seconds );
		root.get(Director).onUpdate( seconds );
	}
	
	/**
	 * End
	 */
	
	public function destroy():Void 
	{
		root.stage.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
		root.stage.removeEventListener( Event.RESIZE, resize );
	}
	
}