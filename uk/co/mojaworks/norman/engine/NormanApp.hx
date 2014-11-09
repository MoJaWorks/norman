package uk.co.mojaworks.norman.engine ;

import lime.app.Application;
import lime.graphics.RenderContext;
import uk.co.mojaworks.norman.components.display.Camera;
import uk.co.mojaworks.norman.core.GameObject;
import uk.co.mojaworks.norman.systems.renderer.gl.GLTextureManager;
import uk.co.mojaworks.norman.systems.renderer.ITextureManager;
import uk.co.mojaworks.norman.systems.renderer.Renderer;

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
	public static var renderer : Renderer;
	public static var textureManager : ITextureManager;
	public static var world : GameObject;
	public static var camera : GameObject;
	
	public function new( ) 
	{
		super();
	}
	
	override public function init( context : RenderContext ) {
		
		gameObjectManager = new GameObjectManager();
		world = new GameObject();
		camera = new GameObject().add( new Camera() );
		
		// initialise the renderer
		renderer = new Renderer( context );
		renderer.resize( window.width, window.height );
		
		switch( context ) {
			case RenderContext.OPENGL(gl):
				
				// Set up the texture manager
				textureManager = new GLTextureManager( gl );
								
			default:
				// Nothing yet
				
		}
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
			renderer.render( camera );
		}
		
	}
	
	/**
	 * End
	 */
	
	public function destroy():Void 
	{

	}
	
}