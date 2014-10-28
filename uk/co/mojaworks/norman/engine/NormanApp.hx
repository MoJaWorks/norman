package uk.co.mojaworks.norman.engine ;

import lime.app.Application;
import lime.graphics.RenderContext;
import uk.co.mojaworks.norman.components.tick.Ticker;
import uk.co.mojaworks.norman.core.GameObject;
import uk.co.mojaworks.norman.core.GameObjectManager;
import uk.co.mojaworks.norman.systems.renderer.gl.GLCanvas;
import uk.co.mojaworks.norman.systems.renderer.gl.GLTextureManager;
import uk.co.mojaworks.norman.systems.renderer.ICanvas;
import uk.co.mojaworks.norman.systems.renderer.ITextureManager;

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
	public static var canvas : ICanvas;
	public static var textureManager : ITextureManager;
	public static var root : GameObject;
	public static var gameObjectManager : GameObjectManager;
	
	public function new( ) 
	{
		super();
	}
	
	override public function init( context : RenderContext ) {
		
		gameObjectManager = new GameObjectManager();
		root = new GameObject();
		
		switch( context ) {
			case RenderContext.OPENGL(gl):
				
				// Set up the texture manager
				textureManager = new GLTextureManager( gl );
				
				// Set up the Canvas
				canvas = new GLCanvas();
				canvas.init( cast gl );
				canvas.resize( window.width, window.height );
				
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
		
		//Root.init( stage );
		
		//root.add( new Input() );
		//root.add( new Ticker() );
		//root.add( new TouchListener() );
			
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
			//root.get(Input).onUpdate( seconds );
			//root.get(Ticker).onUpdate( deltaTime );
		}
	}
	
	override public function render (context:RenderContext):Void {
		
		if ( _hasInit ) {
			switch (context) {
				
				case CANVAS (context):
					
					// TODO: Display error message
					context.fillStyle = "#BFFF00";
					context.fillRect (0, 0, window.width, window.height);
				
				case DOM (element):
					
					// TODO: Display error message
					element.style.backgroundColor = "#BFFF00";
				
				case FLASH (sprite):
					
					sprite.graphics.beginFill (0xBFFF00);
					sprite.graphics.drawRect (0, 0, window.width, window.height);
				
				case OPENGL (gl):
					
					gl.clearColor (0.75, 1, 0, 1);
					gl.clear (gl.COLOR_BUFFER_BIT);					

				
				default:
				
			}
		}
		
	}
	
	/**
	 * End
	 */
	
	public function destroy():Void 
	{

	}
	
}