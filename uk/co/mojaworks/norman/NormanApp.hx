package uk.co.mojaworks.norman;

import haxe.Timer;
import lime.app.Application;
import uk.co.mojaworks.norman.data.NormanConfigData;
import uk.co.mojaworks.norman.systems.Systems;

/**
 * ...
 * @author Simon
 */
class NormanApp extends Application
{

	// This may only be valid at startup as it is not updated with changes and any changes made will not be reflected in the app
	public var config( default, null ) : NormanConfigData;
	
	// Running vars
	public var deltaTime( default, null ) : Float = 0;
	var _lastUpdateTime : Float = 0;
	
	var view : Sprite;
	
	public function new( config : NormanConfigData ) 
	{
		super();
		
		Systems.init( );
		Systems.viewport.setTargetSize( config.targetScreenWidth, config.targetScreenHeight );
		
		// Set the timer to now
		_lastUpdateTime = Timer.stamp();
		
		// Setup the app
		setupCommands();
		setupSystems();
		setupModel();
		setupView();
		
		resize();
		
		onStartupComplete();
	}
	
	private function onStartupComplete() 
	{
		
	}
	
	/**
	 * Setup
	 */
	
	private function setupCommands() : Void {
		// Override
	}
	
	private function setupModel() : Void {
		// Override
	}
	
	private function setupSystems() : Void {
		// Override
	}
	
	private function setupView() : Void {
		// Override
		view = new Sprite();
		addChild( view );
		
	}
	 
	/**
	 * Ongoing
	 */
	 
	public function resize( e : Event = null ) : Void {
		
		Systems.viewport.resize( Lib.current.stage.stageWidth, Lib.current.stage.stageHeight );
		view.scaleX = Systems.viewport.scale;
		view.scaleY = Systems.viewport.scale;
		view.x = Systems.viewport.marginLeft * Systems.viewport.scale;
		view.y = Systems.viewport.marginTop * Systems.viewport.scale;
		
		Systems.director.resize();
		
	}
	
	var gameUpdateId : Int = 0;
	
	function update( e : Event = null ) : Void {
		
		//trace("Start of game update", Timer.stamp(), gameUpdateId );
		
		deltaTime = Timer.stamp() - _lastUpdateTime;
		_lastUpdateTime = Timer.stamp();
		
		Systems.director.update( deltaTime );
		Systems.scripting.update( deltaTime );
		
		//trace("End of game update", Timer.stamp(), gameUpdateId++ );

	}
	
	
	
}