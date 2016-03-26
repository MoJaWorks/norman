package uk.co.mojaworks.norman;
import lime.app.Application;
import lime.graphics.RenderContext;
import lime.graphics.Renderer;
import lime.ui.Window;
import uk.co.mojaworks.norman.controller.DisplayListChangedCommand;
import uk.co.mojaworks.norman.data.NormanConfigData;
import uk.co.mojaworks.norman.data.NormanMessages;
import uk.co.mojaworks.norman.systems.Systems;
import uk.co.mojaworks.norman.systems.animation.AnimationSystem;
import uk.co.mojaworks.norman.systems.director.Director;
import uk.co.mojaworks.norman.systems.script.ScriptRunner;
import uk.co.mojaworks.norman.systems.ui.UISystem;


/**
 * ...
 * @author Simon
 */
class NormanApp extends Application
{

	private var core( get, never ) : Core;
	@:noCompletion private function get_core( ) : Core
	{
		return Core.instance;
	}
	
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
	
	private function createDefaultSystems() : Void 
	{
		Core.instance.governor.addSubject( new Director(), DefaultSystem.Director, 10 );
		Core.instance.governor.addSubject( new ScriptRunner(), DefaultSystem.Scripting, 20 );
		Core.instance.governor.addSubject( new UISystem(), DefaultSystem.UI, 30 );
		Core.instance.governor.addSubject( new AnimationSystem(), DefaultSystem.Animation, 50 );
	}
	
	override public function onWindowCreate(window:Window):Void
	{

		super.onWindowCreate( window );
		
		Core.instance.init();
		Core.instance.view.setTargetSize( normanConfig.targetScreenWidth, normanConfig.targetScreenHeight );
		Core.instance.renderer.init( window.renderer.context );
		
		createDefaultSystems();
		
		//Custom commands
		Core.instance.switchboard.addCommand( NormanMessages.DISPLAY_LIST_CHANGED, new DisplayListChangedCommand() );
	
	}
	
	override public function exec():Int 
	{
		// Called after html5 preloader finishes
		
		onStartupComplete();
		onWindowResize( window, Std.int(window.width), Std.int(window.height) );
		
		return super.exec();
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
		
		Core.instance.view.resize( width * window.scale , height * window.scale );
		//Core.instance.director.resize();
		
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
		//Systems.director.update( seconds );
		//Systems.scripting.update( seconds );
		//Systems.ui.update( seconds );
		//Systems.animation.update( seconds );
		
		Core.instance.governor.update( seconds );
		Core.instance.renderer.render( Core.instance.view.root.transform );
		Core.instance.io.pointer.endFrame();
		
	}
		
	override public function onMouseWheel(window:Window, deltaX:Float, deltaY:Float):Void 
	{
		super.onMouseWheel(window, deltaX, deltaY);
		Core.instance.io.pointer.onMouseScroll( deltaX, deltaY );
	}
	
	override public function onMouseDown( window : Window, x : Float, y : Float, button : Int ) : Void 
	{
		super.onMouseDown( window, x, y, button);
		Core.instance.io.pointer.onMouseDown( x * window.scale, y * window.scale, button );
	}
	
	override public function onMouseUp( window : Window, x : Float, y : Float, button : Int ) : Void 
	{
		super.onMouseUp( window, x, y, button);
		Core.instance.io.pointer.onMouseUp( x * window.scale, y * window.scale, button );
	}
	
	override public function onMouseMove( window : Window, x : Float, y : Float ) : Void 
	{
		super.onMouseMove( window, x, y );
		Core.instance.io.pointer.onMouseMove( x * window.scale, y * window.scale );
	}
	
	/*override public function onKeyDown(window:Window, keyCode:KeyCode, modifier:KeyModifier):Void 
	{
		//trace( "Key down", keyCode );
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
		//trace("Text input", text );
		super.onTextInput(window, text);
		Systems.input.onTextEntry( text );
	}
	
	override public function onTextEdit(window:Window, text:String, start:Int, length:Int):Void 
	{
		//trace( "Text edit", text, start, length );
		super.onTextEdit(window, text, start, length);
		Systems.input.onTextEdit( text );
	}*/
	
	override public function onRenderContextRestored( renderer : Renderer, context:RenderContext ):Void 
	{
		super.onRenderContextRestored(renderer, context);
		trace("OnContextRestored");
	}
	
	override public function onRenderContextLost( renderer : Renderer ):Void 
	{
		super.onRenderContextLost( renderer );
		trace("OnContextLost");
	}
	
	override public function onWindowDeactivate( window : Window ):Void 
	{
		super.onWindowDeactivate(window);
		_windowHasBeenDeactivated = true;
	}
		
}