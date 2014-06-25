package uk.co.mojaworks.frameworkv2.renderer;

import openfl.display.DisplayObject;
import openfl.display.OpenGLView;
import openfl.geom.Rectangle;
import openfl.gl.GL;
import openfl.gl.GLActiveInfo;
import uk.co.mojaworks.frameworkv2.core.CoreObject;

/**
 * ...
 * @author Simon
 */
class GLRenderer extends CoreObject implements IRenderer
{

	var _canvas : OpenGLView;
	
	public function new() 
	{
		super();	
	}
	
	/* INTERFACE uk.co.mojaworks.frameworkv2.renderer.IRenderer */
	
	public function render() 
	{
		// Do nothing - this is rendered using the opengl canvas' render loop
	}
	
	public function init(rect:Rectangle) 
	{
		_canvas = new OpenGLView();
		_canvas.width = rect.width;
		_canvas.height = rect.height;
		_canvas.render = _onRender;
	}
	
	private function _onRender( rect : Rectangle ) : Void {
		
	}
	
	public function getCanvas() : DisplayObject {
		return _canvas;
	}
	
}