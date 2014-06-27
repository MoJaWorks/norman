package uk.co.mojaworks.frameworkv2.renderer;

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

/**
 * ...
 * @author Simon
 */
class GLRenderer extends CoreObject implements IRenderer
{

	var _canvas : OpenGLView;
	
	var _fragmentShader : GLShader;
	var _vertexShader : GLShader;
	var _shaderProgram : GLProgram;
	
	var _aVertexPosition : Int;
	var _aTexCoord : Int;
	var _uProjectionMatrix : GLUniformLocation;
	var _uModelViewMatrix : GLUniformLocation;
	var _uImage0 : GLUniformLocation;
	
	var _rootObject : GameObject;
	
	public function new() 
	{
		super();	
	}
	
	/* INTERFACE uk.co.mojaworks.frameworkv2.renderer.IRenderer */
	
	public function render( root : GameObject ) 
	{
		_rootObject = root;
		// Do nothing - this is all done in the opengl canvas' render loop
	}
	
	public function resize( rect : Rectangle ) {
		// Already handled by OpenGLView
	}
	
	public function init(rect:Rectangle) 
	{
		_canvas = new OpenGLView();
		_canvas.render = _onRender;
		
		initShaders();
	}
	
	private function initShaders() : Void {
		
		_vertexShader = GL.createShader(GL.VERTEX_SHADER);
		GL.shaderSource(_vertexShader, Assets.getText("shaders/main.vs.glsl"));
		GL.compileShader(_vertexShader);
		
		if ( GL.getShaderParameter( _vertexShader, GL.COMPILE_STATUS ) == 0 ) {
			trace("Could not compile vertex shader!");
		}
		
		_fragmentShader = GL.createShader(GL.FRAGMENT_SHADER);
		GL.shaderSource(_fragmentShader, Assets.getText("shaders/main.fs.glsl"));
		GL.compileShader(_fragmentShader);
		
		if ( GL.getShaderParameter( _fragmentShader, GL.COMPILE_STATUS ) == 0 ) {
			trace("Could not compile fragment shader!");
		}
		
		_shaderProgram = GL.createProgram();
		GL.attachShader( _shaderProgram, _vertexShader );
		GL.attachShader( _shaderProgram, _fragmentShader );
		GL.linkProgram(_shaderProgram);
		
		if ( GL.getProgramParameter( _shaderProgram, GL.LINK_STATUS ) == 0 ) {
			trace("Shader link failed");
		}
		
		_aVertexPosition = GL.getAttribLocation( _shaderProgram, "aVertexPosition" );
		_aTexCoord = GL.getAttribLocation( _shaderProgram, "aTexCoord" );
		_uProjectionMatrix = GL.getUniformLocation( _shaderProgram, "uProjectionMatrix" );
		_uModelViewMatrix = GL.getUniformLocation( _shaderProgram, "uModelViewMatrix" );
		_uImage0 = GL.getUniformLocation( _shaderProgram, "uImage0" );
		
	}
	
	private function _onRender( rect : Rectangle ) : Void {
		
		//rect is screenRect
		GL.viewport( Std.int(rect.x), Std.int(rect.y), Std.int(rect.width), Std.int(rect.height) );
		
		
		
	}
	
	public function getCanvas() : DisplayObject {
		return _canvas;
	}
	
}