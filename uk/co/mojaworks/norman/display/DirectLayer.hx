package uk.co.mojaworks.norman.display;
import openfl.display.OpenGLView;
import openfl.display.Sprite;
import uk.co.mojaworks.norman.display.renderer.BaseRenderContext;
import uk.co.mojaworks.norman.display.renderer.gl.GLRenderContext;

/**
 * ...
 * @author test
 */
class DirectLayer extends Sprite
{

	var _context : BaseRenderContext;
	public var root( default, null ) : DirectSprite;
	
	public function new() 
	{
		super();
		
		if ( OpenGLView.isSupported ) {
			var context : GLRenderContext = new GLRenderContext();
			addChild( context.view );
		}
	}
	
}