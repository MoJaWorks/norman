package uk.co.mojaworks.norman.renderer ;

import openfl.Assets;
import openfl.display.DisplayObject;
import openfl.display.OpenGLView;
import openfl.geom.Rectangle;
import openfl.gl.GL;
import openfl.gl.GLActiveInfo;
import openfl.gl.GLProgram;
import openfl.gl.GLShader;
import openfl.gl.GLUniformLocation;
import uk.co.mojaworks.norman.renderer.gl.GLTextureManager;
import uk.co.mojaworks.norman.core.Component;
import uk.co.mojaworks.norman.core.CoreObject;
import uk.co.mojaworks.norman.core.GameObject;
import uk.co.mojaworks.norman.renderer.fallback.BitmapCanvas;
import uk.co.mojaworks.norman.renderer.gl.GLCanvas;
import uk.co.mojaworks.norman.renderer.ICanvas;

/**
 * ...
 * @author Simon
 */
class Renderer extends Component {

	var _canvas : ICanvas;
	public var textureManager( default, null ) : TextureManager;
	
	public function new() 
	{
		super();	
	}
	
	public function init( screenRect : Rectangle ) : Void {
		if ( OpenGLView.isSupported ) {
			_canvas = new GLCanvas();
			textureManager = new GLTextureManager();
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