package uk.co.mojaworks.norman.display.renderer.gl;
import lime.math.Rectangle;
import openfl.display.OpenGLView;

/**
 * ...
 * @author test
 */
class GLRenderContext
{

	public var view( default, null ) : OpenGLView;
	
	public function new() 
	{
		view = new OpenGLView();
		view.render = glRender;
	}
	
	private function glRender( rect : Rectangle ) : Void {
				
	}
	
}