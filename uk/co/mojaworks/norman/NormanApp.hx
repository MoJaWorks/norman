package uk.co.mojaworks.norman;

import haxe.Timer;
import lime.app.Application;
import lime.graphics.RenderContext;
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
	
	public function new( config : NormanConfigData ) 
	{
		super();
		
		this.normanConfig = config;
		
	}
	
	public override function init( context : RenderContext ) : Void 
	{

		Systems.init( );
		Systems.viewport.setTargetSize( normanConfig.targetScreenWidth, normanConfig.targetScreenHeight );
		Systems.renderer.init( context );
		Systems.view.init();
				
		initApp();
				
	}
	
	override public function exec():Int 
	{
		
		onStartupComplete();
		onWindowResize( window.width, window.height );
		
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
	
	override public function onWindowResize(width:Int, height:Int):Void 
	{
		
		Systems.viewport.resize( width, height );
		Systems.view.resize();
		
		Systems.director.resize();
		
	}
	
	override public function update( deltaTime : Int ) : Void 
	{
		super.update( deltaTime );
			
		var seconds : Float = deltaTime * 0.001;
		Systems.director.update( seconds );
		Systems.scripting.update( seconds );
		
		updateApp( seconds );
		
		Systems.renderer.render( Systems.view.root );
		
	}
	
	public function updateApp( seconds : Float ) : Void {
		// Override this one
	}
	
	override public function onMouseDown( x : Float, y : Float, button : Int ) : Void 
	{
		super.onMouseDown(x, y, button);
		Systems.input.onMouseDown( x, y );
	}
	
	override public function onMouseUp( x : Float, y : Float, button : Int ) : Void 
	{
		super.onMouseUp( x, y, button);
		Systems.input.onMouseUp( x, y );
	}
	
	override public function onMouseMove( x : Float, y : Float ) : Void 
	{
		super.onMouseMove( x, y );
		Systems.input.onMouseMove( x, y );
	}
	
	override public function onRenderContextRestored(context:RenderContext):Void 
	{
		super.onRenderContextRestored(context);
		trace("OnContextRestored");
	}
	
	override public function onRenderContextLost():Void 
	{
		super.onRenderContextLost();
		trace("OnContextLost");
	}
		
}