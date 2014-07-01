package uk.co.mojaworks.frameworkv2.renderer.gl ;
import openfl.geom.Matrix3D;
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
import openfl.utils.Float32Array;
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
	
	var _imageShaderProgram : GLShaderWrapper;
	var _fillShaderProgram : GLShaderWrapper;
	var _currentShaderProgram : GLShaderWrapper;
	
	var _vertexBuffer : GLBuffer;
	
	var _projectionMatrix : Matrix3D;
	var _modelViewMatrix : Matrix3D;
	
	public function new() 
	{
		
	}
	
	public function init(rect:Rectangle) 
	{		
		_canvas = new OpenGLView();
		_canvas.render = _onRender;
		
		GL.clearColor( 0, 0, 0, 1 );
		
		_vertexBuffer = GL.createBuffer():
		
		initShaders();
		
		resize( rect );
	}
	
	private function initShaders() : Void {
		
		_imageShaderProgram = new GLShaderWrapper( 
			Assets.getText("shaders/image.vs.glsl"),
			Assets.getText("shaders/image.fs.glsl"),
			["uProjectionMatrix", "uModelViewMatrix", "uImage0"],
			["aTexCoord", "aVertexPosition"]
		);
		
		_imageShaderProgram = new GLShaderWrapper( 
			Assets.getText("shaders/fill.vs.glsl"),
			Assets.getText("shaders/fill.fs.glsl"),
			["uProjectionMatrix", "uModelViewMatrix"],
			["aVertexColor", "aVertexPosition"] 
		);
		
	}
	
	public function render( root : GameObject ) {
		_root = root;
	}
	
	private function _onRender( rect : Rectangle ) : Void {
		
		GL.viewport( Std.int( rect.x ), Std.int( rect.y ), Std.int( rect.width ), Std.int( rect.height ) );
		GL.clear( GL.COLOR_BUFFER_BIT );
				
		_projectionMatrix = Matrix3D.createOrtho( 0, rect.width, 0, rect.height, 1, -1 );
		
		renderLevel( _root );
		
		_currentShaderProgram = null;
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
	
	public function fillRect(red:Float, green:Float, blue:Float, alpha:Float, width:Float, height:Float, transform:Matrix):Void 
	{
		if ( _currentShaderProgram != _fillShaderProgram ) {
			GL.useProgram( _fillShaderProgram );
			GL.uniformMatrix3D( _fillShaderProgram.uniforms.get("uProjectionMatrix"), false, _projectionMatrix );
			_currentShaderProgram = _fillShaderProgram;
		}
		
		var vertices : Array<Float> = [
			0, 0, red, green, blue, alpha,
			0, height, red, green, blue, alpha,
			width, 0, red, green, blue, alpha,
			width, height, red, green, blue, alpha
		]
			
		
		_modelViewMatrix = Matrix3D.createABCD( transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty );
		GL.uniformMatrix3D( _fillShaderProgram.uniforms.get("uModelViewMatrix"), false, _modelViewMatrix );
		
		GL.bindBuffer( GL.ARRAY_BUFFER, _vertexBuffer );
		GL.bufferData( GL.ARRAY_BUFFER, new Float32Array( cast vertices ), GL.STATIC_DRAW );
		//GL.enableVertexAttribArray( 
		
	}
	
	public function drawImage(textureId:String, transform:Matrix, alpha:Float):Void 
	{
		GL.uniformMatrix3D( _imageShaderProgram.uniforms.get("uProjectionMatrix"), false, _projectionMatrix );
		
	}
	
	public function drawSubImage(textureId:String, subImageId:String, transform:Matrix, alpha:Float):Void 
	{
		
	}
	
	
	
}