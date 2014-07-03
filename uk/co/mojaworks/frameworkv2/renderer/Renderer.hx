package uk.co.mojaworks.frameworkv2.renderer ;

import openfl.Assets;
import openfl.display.DisplayObject;
import openfl.display.OpenGLView;
import openfl.geom.Rectangle;
import openfl.gl.GL;
import openfl.gl.GLActiveInfo;
import openfl.gl.GLProgram;
import openfl.gl.GLShader;
import openfl.gl.GLUniformLocation;
import uk.co.mojaworks.frameworkv2.core.CoreObject;
import uk.co.mojaworks.frameworkv2.core.GameObject;
import uk.co.mojaworks.frameworkv2.renderer.fallback.BitmapCanvas;
import uk.co.mojaworks.frameworkv2.renderer.gl.GLCanvas;
import uk.co.mojaworks.frameworkv2.renderer.ICanvas;

/**
 * ...
 * @author Simon
 */
class Renderer extends CoreObject {

	var _canvas : ICanvas;
	
	public function new() 
	{
		super();	
	}
	
	public function init( screenRect : Rectangle ) : Void {
		if ( OpenGLView.isSupported ) {
			_canvas = new GLCanvas();
			trace("Using GL renderer");
		}else {
			_canvas = new BitmapCanvas();
			trace("Falling back to bitmap renderer");
		}
		
		_canvas.init( screenRect );
		resize( screenRect );
	}
	
	public function render( root : GameObject ) 
	{
		_canvas.render( root );
	}
	
	public function resize( rect : Rectangle ) {
		_canvas.resize(rect);
	}
	
	public function getDisplayObject() : DisplayObject {
		return _canvas.getDisplayObject();
	}
	
}