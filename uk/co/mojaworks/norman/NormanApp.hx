package uk.co.mojaworks.norman;

import haxe.Timer;
import lime.app.Application;
import lime.graphics.RenderContext;
import lime.graphics.Renderer;
import lime.ui.Window;
import uk.co.mojaworks.norman.data.NormanConfigData;
import uk.co.mojaworks.norman.display.Sprite;
import uk.co.mojaworks.norman.systems.Systems;

/**
 * ...
 * @author Simon
 */
class NormanApp extends Application
{

	// This may only be valid at startup as it is not updated with changes and any changes made will not be reflected in the app
	public var normanConfig( default, null ) : NormanConfigData;
	
	// Running vars
	var view : Sprite;
	var startupComplete : Bool = false;
	var _windowHasBeenDeactivated : Bool = false;
	
	public function new( config : NormanConfigData ) 
	{
		super();
		
		this.normanConfig = config;
		
	}
	
	override public function onWindowCreate(window:Window):Void
	{

		super.onWindowCreate( window );
		
		Systems.init( );
		Systems.viewport.setTargetSize( normanConfig.targetScreenWidth, normanConfig.targetScreenHeight );
		Systems.renderer.init( window.renderer.context );
				
		initApp();
				
	}
	
	override public function exec():Int 
	{
		
		onStartupComplete();
		onWindowResize( window, window.width, window.height );
		
		return super.exec();
	}
	
	private function initApp() : Void {
		// Override for any additional init steps
	}
	
	private function onStartupComplete() 
	{
		// Override for when startup is complete
		startupComplete = true;
	}
	
	/**
	 * Ongoing
	 */
	
	override public function onWindowResize( window : Window, width:Int, height:Int):Void 
	{
		
		super.onWindowResize( window, width, height );
		
		Systems.viewport.resize( width, height );
		Systems.director.resize();
		
	}
	
	override public function update( deltaTime : Int ) : Void 
	{
		super.update( deltaTime );
		
		// Ignore the first update after activation as its time delta is huge
		if ( _windowHasBeenDeactivated ) {
			_windowHasBeenDeactivated = false;
			return;
		}
			
		var seconds : Float = deltaTime * 0.001;
		Systems.director.update( seconds );
		Systems.scripting.update( seconds );
		
		updateApp( seconds );
		
		Systems.renderer.render( Systems.director.root );
		
	}
	
	public function updateApp( seconds : Float ) : Void {
		// Override this one
	}
	
	override public function onMouseDown( window : Window, x : Float, y : Float, button : Int ) : Void 
	{
		super.onMouseDown( window, x, y, button);
		Systems.input.onMouseDown( x, y );
	}
	
	override public function onMouseUp( window : Window, x : Float, y : Float, button : Int ) : Void 
	{
		super.onMouseUp( window, x, y, button);
		Systems.input.onMouseUp( x, y );
	}
	
	override public function onMouseMove( window : Window, x : Float, y : Float ) : Void 
	{
		super.onMouseMove( window, x, y );
		Systems.input.onMouseMove( x, y );
	}
	
	override public function onRenderContextRestored( renderer : Renderer, context:RenderContext ):Void 
	{
		super.onRenderContextRestored(renderer, context);
		trace("OnContextRestored");
	}
	
	override public function onRenderContextLost( ernderer : Renderer ):Void 
	{
		super.onRenderContextLost( renderer );
		trace("OnContextLost");
	}
	
	override public function onWindowDeactivate(window:Window):Void 
	{
		super.onWindowDeactivate(window);
		_windowHasBeenDeactivated = true;
	}
		
}