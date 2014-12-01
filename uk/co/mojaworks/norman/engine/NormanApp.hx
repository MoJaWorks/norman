package uk.co.mojaworks.norman.engine ;

import lime.app.Application;
import lime.graphics.opengl.GL;
import lime.graphics.RenderContext;
import uk.co.mojaworks.norman.core.Core;
import uk.co.mojaworks.norman.core.view.GameObject;
import uk.co.mojaworks.norman.systems.renderer.gl.GLRenderer;
import uk.co.mojaworks.norman.systems.renderer.IRenderer;

/**
 * This class is intended to be extended and used as a root controller
 * It sets up the game, viewport and some core components
 * 
 * @author Simon
 */

class NormanApp extends Application
{
	
	public var core( get, never ) : Core;
	private function get_core() : Core { return Core.getInstance(); };
	
	private var _hasInit : Bool = false;
	
	// Public static vars for easy access
	//public static var viewport : Viewport;
	// TODO: Add sound engine
	public var renderer : IRenderer;
	
	/**
	 * 
	 */
	
	public function new( _stageWidth : Int, _stageHeight : Int ) 
	{
		super();
		Core.init( this );
	}
	
	override public function init( context : RenderContext ) {
		
		var canCompleteStartup : Bool = true;
		
		switch( context ) {
			case RenderContext.OPENGL(gl):
				
				// Set up the texture manager
				renderer = new GLRenderer( gl );
					
				
			case RenderContext.FLASH(sprite):
				
				#if flash
					
					// This should be the only bit that needs masking because we cant use flash while not in the flash runtime
					var stage3D : flash.display.Stage3D = flash.Lib.current.stage.stage3Ds[0];
					stage3D.addEventListener( flash.events.Event.CONTEXT3D_CREATE, function( e : flash.events.Event ) {
						renderer = new uk.co.mojaworks.norman.systems.renderer.stage3d.Stage3DRenderer( stage3D.context3D );
						_hasInit = true;
						onStartupComplete();
					});
					canCompleteStartup = false;
					
				#end
				
				
			default:
				// Nothing yet
				
		}
		
		if ( renderer != null ) renderer.resize( window.width, window.height );
		
		if ( canCompleteStartup ) {
			_hasInit = true;
			onStartupComplete();
		}
	}
		
	/**
	 * Boot
	 */
				
	private function onStartupComplete() : Void {
		// Override
	}
	
	
	/**
	 * Ongoing
	 */
	
	override public function onWindowResize( width : Int, height : Int ) : Void {
		
		if ( _hasInit ) {
			
		}
		
	}
		
	override public function update( deltaTime : Int ) : Void 
	{
		if ( _hasInit ) {
			super.update( deltaTime );
		}
	}
	
	override public function render (context:RenderContext):Void {
		
		if ( _hasInit ) {
			renderer.render( core.root );
		}
		
	}
	
	/**
	 * End
	 */
	
	public function destroy():Void 
	{

	}
	
}