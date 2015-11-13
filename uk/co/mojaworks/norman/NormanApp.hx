package uk.co.mojaworks.norman;
import lime.ui.KeyModifier;

import haxe.Timer;
import lime.app.Application;
import lime.graphics.RenderContext;
import lime.graphics.Renderer;
import lime.ui.KeyCode;
import lime.ui.Window;
import uk.co.mojaworks.norman.controller.DisplayListChangedCommand;
import uk.co.mojaworks.norman.data.NormanConfigData;
import uk.co.mojaworks.norman.data.NormanMessages;
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
	var startupComplete : Bool = false;
	var _windowHasBeenDeactivated : Bool = false;
	
	public function new( config : NormanConfigData ) 
	{
		super();
		
		#if (cpp && HXCPP_DEBUGGER)
			new debugger.Local(true);
		#end
		
		this.normanConfig = config;
		
	}
	
	override public function onWindowCreate(window:Window):Void
	{

		super.onWindowCreate( window );
		
		Systems.init( );
		Systems.viewport.setTargetSize( normanConfig.targetScreenWidth, normanConfig.targetScreenHeight );
		Systems.renderer.init( window.renderer.context );
				
		//Custom commands
		Systems.switchboard.addCommand( NormanMessages.DISPLAY_LIST_CHANGED, new DisplayListChangedCommand() );
		
		initApp();
	
	}
	
	override public function exec():Int 
	{
		// Called after html5 preloader finishes
		
		onStartupComplete();
		onWindowResize( window, Std.int(window.width), Std.int(window.height) );
		
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

		trace("Window size: ", width, height, window.scale );
		
		Systems.viewport.resize( width * window.scale , height * window.scale );
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
		Systems.ui.update( seconds );
		Systems.animation.update( seconds );
		
		updateApp( seconds );
		
		Systems.renderer.render( Systems.director.rootObject.transform );
		
		Systems.input.update( seconds );
		
	}
	
	public function updateApp( seconds : Float ) : Void {
		// Override this one
	}
	
	override public function onMouseDown( window : Window, x : Float, y : Float, button : Int ) : Void 
	{
		super.onMouseDown( window, x, y, button);
		Systems.input.onMouseDown( x * window.scale, y * window.scale, button );
	}
	
	override public function onMouseUp( window : Window, x : Float, y : Float, button : Int ) : Void 
	{
		super.onMouseUp( window, x, y, button);
		Systems.input.onMouseUp( x * window.scale, y * window.scale, button );
	}
	
	override public function onMouseMove( window : Window, x : Float, y : Float ) : Void 
	{
		super.onMouseMove( window, x, y );
		Systems.input.onMouseMove( x * window.scale, y * window.scale );
	}
	
	override public function onKeyDown(window:Window, keyCode:KeyCode, modifier:KeyModifier):Void 
	{
		super.onKeyDown(window, keyCode, modifier);
		Systems.input.onKeyDown( keyCode, modifier );
	}
	
	override public function onKeyUp(window:Window, keyCode:KeyCode, modifier:KeyModifier):Void 
	{
		super.onKeyUp(window, keyCode, modifier);
		Systems.input.onKeyUp( keyCode, modifier );
	}
	
	override public function onTextInput( window:Window, text:String ) : Void 
	{
		trace("Text input: ", text );
		super.onTextInput(window, text);
		Systems.input.onTextEntry( text );
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