package uk.co.mojaworks.norman.systems.renderer;
import lime.graphics.RenderContext;
import uk.co.mojaworks.norman.systems.renderer.gl.GLCanvas;

/**
 * ...
 * @author test
 */
class Renderer
{

	private var _canvas : ICanvas;
	
	public function new() {
		
	}
	
	public function init( context : RenderContext ) 
	{
		
		switch (context) 
		{
			case OPENGL(gl):
				// TODO: Set up GL render system (main focus)
				var glCanvas : GLCanvas = new GLCanvas();
				glCanvas.init( gl );
				_canvas = glCanvas;
				
			case FLASH(sprite):
				// TODO: Set up Stage3D  render system (eventually)
			case CANVAS(context):
				// TODO: Set up canvas render system (eventually)
			case DOM(context):
				// TODO: Set up DOM render system (eventually)
			default:
		}
		
	}
	
}