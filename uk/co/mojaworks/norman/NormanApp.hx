package uk.co.mojaworks.norman ;

import lime.app.Application;
import lime.graphics.opengl.GL;
import lime.graphics.RenderContext;
import uk.co.mojaworks.norman.core.Core;
import uk.co.mojaworks.norman.core.view.GameObject;
import uk.co.mojaworks.norman.core.view.Viewport;
import uk.co.mojaworks.norman.systems.input.InputSystem;
import uk.co.mojaworks.norman.systems.renderer.gl.GLRenderer;
import uk.co.mojaworks.norman.systems.renderer.IRenderer;
import uk.co.mojaworks.norman.systems.ticker.TickerSystem;
import uk.co.mojaworks.norman.systems.ui.UISystem;

/**
 * This class is intended to be extended and used as a root controller
 * It sets up the game, viewport and some core components
 * 
 * @author Simon
 */

class NormanApp extends Application
{
	
	public static inline var RESIZE : String = "resize";
	
	public var core( get, never ) : Core;
	private function get_core() : Core { return Core.getInstance(); };
	
	private var _hasInit : Bool = false;
	
	// TODO: Add sound engine
	
	// Public vars for easy access
	public var viewport( default, null ) : Viewport;
	public var renderer( default, null ) : IRenderer;
	public var ticker( default, null ) : TickerSystem;
	public var input( default, null ) : InputSystem;
	public var ui( default, null ) : UISystem;
	
	/**
	 * 
	 */
	
	public function new( _stageWidth : Int, _stageHeight : Int ) 
	{
		super();
		Core.init( this );
		
		ticker = new TickerSystem();
		input = new InputSystem();
		ui = new UISystem();
		viewport = new Viewport();
		viewport.setTargetSize( _stageWidth, _stageHeight );
		
	}
	
	override public function init( context : RenderContext ) {
		
		switch( context ) {
			case RenderContext.OPENGL(gl):
				
				// Set up the texture manager
				renderer = new GLRenderer( gl );
				renderer.resize( window.width, window.height );
				_hasInit = true;
				onStartupComplete();
				
			case RenderContext.FLASH(sprite):
				
				#if flash
					
					// This should be the only bit that needs masking because we cant use flash while not in the flash runtime
					var stage3D : flash.display.Stage3D = flash.Lib.current.stage.stage3Ds[0];
					stage3D.addEventListener( flash.events.Event.CONTEXT3D_CREATE, function( _ ) {
						renderer = new uk.co.mojaworks.norman.systems.renderer.stage3d.Stage3DRenderer( stage3D.context3D );
						renderer.resize( window.width, window.height );
						_hasInit = true;
						trace("Context created - initialising");
						onStartupComplete();
					});
					stage3D.requestContext3D( /*flash.display3D.Context3DRenderMode.AUTO, flash.display3D.Context3DProfile.BASELINE*/ );
					
				#end
				
				
			default:
				// Nothing yet
				
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
			renderer.resize( width, height );
			viewport.resize( width, height );
			
			core.root.transform.setScale( viewport.scale );
			core.root.transform.setPosition( viewport.marginLeft * viewport.scale, viewport.marginTop * viewport.scale );
			
			core.sendMessage( RESIZE );
		}
		
	}
		
	override public function update( deltaTime : Int ) : Void 
	{
		if ( _hasInit ) {
			super.update( deltaTime );
			ui.update( deltaTime * 0.001 );
			ticker.tick( deltaTime * 0.001 );
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
	
	/**
	 * Input
	 */
	
	override public function onKeyDown(keyCode:Int, modifier:Int):Void 
	{
		super.onKeyDown(keyCode, modifier);
		input.onKeyDown( keyCode );
	}
	
	override public function onKeyUp(keyCode:Int, modifier:Int):Void 
	{
		super.onKeyUp(keyCode, modifier);
		input.onKeyUp( keyCode );
	}
	
	override public function onMouseDown(x:Float, y:Float, button:Int):Void 
	{
		super.onMouseDown(x, y, button);
		input.onPointerDown( x, y );
	}
	
	override public function onMouseUp(x:Float, y:Float, button:Int):Void 
	{
		super.onMouseUp(x, y, button);
		input.onPointerUp( x, y );
	}
	
	override public function onMouseMove(x:Float, y:Float, button:Int):Void 
	{
		super.onMouseMove(x, y, button);
		input.onPointerMove( x, y );
	}
	
	override public function onTouchStart(x:Float, y:Float, id:Int):Void 
	{
		super.onTouchStart(x, y, id);
		input.onPointerDown( x, y, id );
	}
	
	override public function onTouchEnd(x:Float, y:Float, id:Int):Void 
	{
		super.onTouchEnd(x, y, id);
		input.onPointerUp( x, y, id );
	}
	
	override public function onTouchMove(x:Float, y:Float, id:Int):Void 
	{
		super.onTouchMove(x, y, id);
		input.onPointerMove( x, y, id );
	}
	
}