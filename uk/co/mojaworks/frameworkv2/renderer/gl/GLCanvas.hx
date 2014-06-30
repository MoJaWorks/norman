package uk.co.mojaworks.frameworkv2.renderer.gl ;
import flash.geom.Matrix3D;
import openfl.Assets;
import openfl.display.DisplayObject;
import openfl.display.OpenGLView;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.geom.Rectangle;
import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.gl.GLProgram;
import openfl.gl.GLShader;
import openfl.gl.GLTexture;
import openfl.gl.GLUniformLocation;
import uk.co.mojaworks.frameworkv2.components.display.Display;
import uk.co.mojaworks.frameworkv2.core.GameObject;

/**
 * ...
 * @author Simon
 */
class GLCanvas implements ICanvas
{
	
	var _canvas : OpenGLView;
	var _root : GameObject;
	
	var _imageShaderProgram : GLProgram;
	var _fillShaderProgram : GLProgram;
	
	var _aVertexPosition : Int;
	var _aTexCoord : Int;
	var _uProjectionMatrix : GLUniformLocation;
	var _uModelViewMatrix : GLUniformLocation;
	var _uImage0 : GLUniformLocation;

	public function new() 
	{
		
	}
	
	public function init(rect:Rectangle) 
	{
		_canvas = new OpenGLView();
		_canvas.render = _onRender;
		
		GL.clearColor( 0, 0, 0, 1 );
		
		initShaders();
	}
	
	private function initShaders() : Void {
		
		var imageVertexShader : GLShader = GL.createShader(GL.VERTEX_SHADER);
		GL.shaderSource(imageVertexShader, Assets.getText("shaders/main.vs.glsl"));
		GL.compileShader(imageVertexShader);
		
		if ( GL.getShaderParameter( imageVertexShader, GL.COMPILE_STATUS ) == 0 ) {
			trace("Could not compile vertex shader!");
		}
		
		var imageFragmentShader : GLShader = GL.createShader(GL.FRAGMENT_SHADER);
		GL.shaderSource(imageFragmentShader, Assets.getText("shaders/main.fs.glsl"));
		GL.compileShader(imageFragmentShader);
		
		if ( GL.getShaderParameter( imageFragmentShader, GL.COMPILE_STATUS ) == 0 ) {
			trace("Could not compile fragment shader!");
		}
		
		_imageShaderProgram = GL.createProgram();
		GL.attachShader( _imageShaderProgram, imageVertexShader );
		GL.attachShader( _imageShaderProgram, imageFragmentShader );
		GL.linkProgram(_imageShaderProgram);
		
		if ( GL.getProgramParameter( _shaderProgram, GL.LINK_STATUS ) == 0 ) {
			trace("Shader link failed");
		}
		
		_aVertexPosition = GL.getAttribLocation( _imageShaderProgram, "aVertexPosition" );
		_aTexCoord = GL.getAttribLocation( _imageShaderProgram, "aTexCoord" );
		_uProjectionMatrix = GL.getUniformLocation( _imageShaderProgram, "uProjectionMatrix" );
		_uModelViewMatrix = GL.getUniformLocation( _imageShaderProgram, "uModelViewMatrix" );
		_uImage0 = GL.getUniformLocation( _imageShaderProgram, "uImage0" );
		
	}
	
	public function render( root : GameObject ) {
		_root = root;
	}
	
	private function _onRender( rect : Rectangle ) : Void {
		
		GL.viewport( Std.int( rect.x ), Std.int( rect.y ), Std.int( rect.width ), Std.int( rect.height ) );
		GL.clear( GL.COLOR_BUFFER_BIT );
		
		renderLevel( _root );
		
	}
	
	private function renderLevel( root : GameObject ) : Void {
		var display : Display = root.get(Display);
		if ( display.visible && display.getGlobalAlpha() > 0 ) {
			
			display.render( this );
			
			for ( child in root.children ) {
				renderLevel( child );
			}
			
		}
	}
		
	/* INTERFACE uk.co.mojaworks.frameworkv2.renderer.ICanvas */
	
	public function getDisplayObject():DisplayObject 
	{
		return _canvas;
	}
	
	public function resize(rect:Rectangle):Void 
	{
		
	}
	
	public function fillRect(red:Float, green:Float, blue:Float, alpha:Float, transform:Matrix):Void 
	{
		
	}
	
	public function drawImage(textureId:String, transform:Matrix, alpha:Float):Void 
	{
		
	}
	
	public function drawSubImage(textureId:String, subImageId:String, transform:Matrix, alpha:Float):Void 
	{
		
	}
	
	
	
}