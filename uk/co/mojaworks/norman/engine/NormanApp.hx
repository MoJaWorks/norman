package uk.co.mojaworks.norman.engine ;

import lime.app.Application;
import lime.graphics.RenderContext;
import uk.co.mojaworks.norman.components.display.Camera;
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
	
	private var _hasInit : Bool = false;
	
	// Public static vars for easy access
	public static var renderer : IRenderer;
	public static var root : GameObject;
	
	public function new( ) 
	{
		super();
	}
	
	override public function init( context : RenderContext ) {
		
		root = new GameObject();
		
		switch( context ) {
			case RenderContext.OPENGL(gl):
				
				// Set up the texture manager
				renderer = new GLRenderer( gl );
								
			default:
				// Nothing yet
				
		}
		
		renderer.resize( window.width, window.height );
	}
	
	private function initNorman( stageWidth, stageHeight ) : Void {
				
		initRoot( stageWidth, stageHeight );		
		onStartupComplete();
		
	}
	
	/**
	 * Boot
	 */
	
	private function initRoot( width : Int, height : Int ) : Void {		
		_hasInit = true;	
	}
			
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
			renderer.render( root );
		}
		
	}
	
	/**
	 * End
	 */
	
	public function destroy():Void 
	{

	}
	
}