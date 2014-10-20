package uk.co.mojaworks.norman.engine ;

import haxe.Timer;
import lime.app.Application;
import lime.graphics.RenderContext;
import uk.co.mojaworks.norman.components.director.Director;
import uk.co.mojaworks.norman.components.input.Input;
import uk.co.mojaworks.norman.components.input.TouchListener;
import uk.co.mojaworks.norman.components.renderer.Renderer;
import uk.co.mojaworks.norman.components.tick.Ticker;
import uk.co.mojaworks.norman.core.Root;
import uk.co.mojaworks.norman.core.RootObject;

/**
 * This class is intended to be extended and used as a root controller
 * It sets up the game, viewport and some core components
 * 
 * @author Simon
 */

class NormanApp extends Application
{
	
	private var _hasInit : Bool = false;
	
	public function new( ) 
	{
		super();
	}
	
	private function initNorman( stageWidth, stageHeight ) : Void {
				
		initRoot( stageWidth, stageHeight );		
		resize();
		onStartupComplete();
		
		
		
	}
	
	/**
	 * Boot
	 */
	
	private function initRoot( stage : Stage, width : Int, height : Int ) : Void {
		
		Root.init( stage );
		
		root.add( new Input() );
		root.add( new Ticker() );
		root.add( new TouchListener() );
		
		var director : Director = new Director();
		director.setViewportTarget( width, height );
		root.add( director );
		
		var renderer = new Renderer();
		renderer.init( director.viewport.screenRect );
		root.add( renderer );
		
		#if !flash
			root.stage.addChild( renderer.getDisplayObject() );
		#end
		
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
			// Resize any active screens/panels
			var director : Director = root.get(Director);
			director.resize( width, height );
			
			// Resize the viewport to scale everything to the screen size
			root.get(Renderer).resize( director.viewport.screenRect );
		}
		
	}
		
	override public function update( deltaTime : Int ) : Void 
	{
		if ( _hasInit ) {
			super.update( deltaTime );
			root.get(Input).onUpdate( seconds );
			root.get(Ticker).onUpdate( seconds );
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