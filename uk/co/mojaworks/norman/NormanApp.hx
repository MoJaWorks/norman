package uk.co.mojaworks.norman;
import geoff.App;
import geoff.AppDelegate;
import geoff.event.PointerButton;
import geoff.renderer.IRenderContext;
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
class NormanApp extends AppDelegate
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
		core.governor.addSubject( new Director(), DefaultSystem.Director, 10 );
		core.governor.addSubject( new ScriptRunner(), DefaultSystem.Scripting, 20 );
		core.governor.addSubject( new UISystem(), DefaultSystem.UI, 30 );
		core.governor.addSubject( new AnimationSystem(), DefaultSystem.Animation, 50 );
	}
	
	override public function init( context : IRenderContext ):Void
	{

		core.init();
		core.view.setTargetSize( normanConfig.targetScreenWidth, normanConfig.targetScreenHeight );
		core.renderer.init( context );
		
		createDefaultSystems();
		
		core.view.root.transform.addChild( Systems.director.container.transform );
		
		//Custom commands
		core.switchboard.addCommand( NormanMessages.DISPLAY_LIST_CHANGED, new DisplayListChangedCommand() );
		
		onStartupComplete();
	
	}

	
	private function onStartupComplete() 
	{
		// Override for when startup is complete
		startupComplete = true;
	}
	
	/**
	 * Ongoing
	 */
	
	override public function resize( width:Int, height:Int ):Void 
	{
		core.view.resize( width, height );
		Systems.director.resize();
	}
	
	override public function update( context : IRenderContext, seconds : Float ) : Void 
	{
		// Ignore the first update after activation as its time delta is huge
		if ( _windowHasBeenDeactivated ) {
			_windowHasBeenDeactivated = false;
			return;
		}
		
		core.governor.update( seconds );
		core.renderer.render( Core.instance.view.root.transform );
		core.io.pointer.endFrame();
		
	}
		
	override public function onPointerScroll( pointerId : Int, deltaX : Int, deltaY : Int ) : Void 
	{
		core.io.pointer.onMouseScroll( deltaX, deltaY );
	}
	
	override public function onPointerDown( pointerId : Int, button : PointerButton, x : Int, y : Int ) : Void 
	{
		trace("Pointer down", App.current.platform.getTime(), x, y );
		core.io.pointer.onMouseDown( x, y, button );
	}
	
	override public function onPointerUp( pointerId : Int, button : PointerButton, x : Int, y : Int ) : Void 
	{
		trace("Pointer up", App.current.platform.getTime(), x, y );
		core.io.pointer.onMouseUp( x, y, button );
	}
	
	override public function onPointerMove( pointerId : Int, x : Int, y : Int ) : Void 
	{
		core.io.pointer.onMouseMove( x, y );
	}
	
	override public function onKeyDown( keyCode:Int, modifier:Int ):Void 
	{
		core.io.keyboard.onKeyDown( keyCode, modifier );
	}
	
	override public function onKeyUp( keyCode:Int, modifier:Int ):Void 
	{
		core.io.keyboard.onKeyUp( keyCode, modifier );
	}
	
	override public function onContextCreated( context : IRenderContext ):Void 
	{
		core.renderer.onContextCreated( context );
	}
	
	/*override public function onTextInput( window:Window, text:String ) : Void 
	{
		//trace("Text input", text );
		super.onTextInput(window, text);
		core.io.keyboard.onTextEntry( text );
	}
	
	override public function onTextEdit(window:Window, text:String, start:Int, length:Int):Void 
	{
		//trace( "Text edit", text, start, length );
		super.onTextEdit(window, text, start, length);
		core.io.keyboard.onTextEdit( text );
	}
	
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
	}*/
		
}