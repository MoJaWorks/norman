package uk.co.mojaworks.norman.systems.renderer;
import lime.graphics.RenderContext;
import uk.co.mojaworks.norman.components.display.Camera;
import uk.co.mojaworks.norman.core.GameObject;
import uk.co.mojaworks.norman.engine.NormanApp;
import uk.co.mojaworks.norman.systems.renderer.gl.GLCanvas;

/**
 * ...
 * @author Simon
 */
class Renderer
{

	public var canvas : ICanvas;
	
	public function new( context : RenderContext ) 
	{
		switch( context ) {
			case RenderContext.OPENGL(gl):
				canvas = new GLCanvas();
				canvas.init( cast gl );
			
			default:
				// Nothing yet
		}
		
	}
	
	public function render( context : RenderContext, root : GameObject, camera : GameObject ) {
		
		canvas.render( root, camera );
		
	}
	
}