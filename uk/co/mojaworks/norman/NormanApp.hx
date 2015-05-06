package uk.co.mojaworks.norman;

import haxe.Timer;
import lime.app.Application;
import lime.graphics.RenderContext;
import uk.co.mojaworks.norman.data.NormanConfigData;
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
	//var view : Sprite;
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
				
		initApp();
		
		onWindowResize( window.width, window.height );
		onStartupComplete();
		
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
		//view.scaleX = Systems.viewport.scale;
		//view.scaleY = Systems.viewport.scale;
		//view.x = Systems.viewport.marginLeft * Systems.viewport.scale;
		//view.y = Systems.viewport.marginTop * Systems.viewport.scale;
		
		Systems.director.resize();
		
	}
	
	override public function update( deltaTime : Int ) : Void 
	{
		super.update( deltaTime );
			
		var seconds : Float = deltaTime * 0.001;
		Systems.director.update( seconds );
		Systems.scripting.update( seconds );
		
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
	
	
}