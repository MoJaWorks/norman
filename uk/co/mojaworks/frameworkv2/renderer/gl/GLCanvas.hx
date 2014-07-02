package uk.co.mojaworks.frameworkv2.renderer.gl ;
import openfl.geom.Matrix3D;
import openfl.Assets;
import openfl.display.DisplayObject;
import openfl.display.OpenGLView;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.geom.Rectangle;
import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.gl.GLProgram;
import openfl.gl.GLShader;
import openfl.gl.GLTexture;
import openfl.gl.GLUniformLocation;
import openfl.utils.Float32Array;
import openfl.utils.UInt8Array;
import uk.co.mojaworks.frameworkv2.components.display.Display;
import uk.co.mojaworks.frameworkv2.core.GameObject;

/**
 * ...
 * @author Simon
 */
class GLCanvas implements ICanvas
{
	
	private static inline var QUAD_SIZE : Int = 8;
	
	var _vertexBuffer : GLBuffer;
	var _indexBuffer : GLBuffer;
	var _batches : Array<GLBatchData>;
	
	// A temporary array re-generated each frame with positions of all vertices
	var _vertices:Array<Float>;
	var _root : GameObject;
	
	// The opengl view object used to reserve our spot on the display list
	var _canvas : OpenGLView;
	
	// Relevant shaders
	var _imageShaderProgram : GLShaderWrapper;
	var _fillShaderProgram : GLShaderWrapper;
	
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
		
		initShaders();
		initBuffer();
		
		resize( rect );
	}
	
	private function initShaders() : Void {
		
		_imageShaderProgram = new GLShaderWrapper( 
			Assets.getText("shaders/image.vs.glsl"),
			Assets.getText("shaders/image.fs.glsl"),
			["uProjectionMatrix", "uModelViewMatrix", "uImage0"],
			["aTexCoord", "aVertexPosition"]
		);
		
		_fillShaderProgram = new GLShaderWrapper( 
			Assets.getText("shaders/fill.vs.glsl"),
			Assets.getText("shaders/fill.fs.glsl"),
			["uProjectionMatrix", "uModelViewMatrix"],
			["aVertexColor", "aVertexPosition"] 
		);
		
	}
	
	private function initBuffer() : Void {
		_vertexBuffer = GL.createBuffer();
		_indexBuffer = GL.createBuffer();
	}
	
	public function resize(rect:Rectangle):Void 
	{
		
	}
	
	/***
	 * Software render pass
	 **/
	
	public function render( root : GameObject ) {
		_root = root;
		
		// Generate all buffers here
		_vertices = [];
		_batches = [];
		
		// Collect all of the vertex data
		renderLevel( root );
		
		// Pass it to the graphics card
		GL.bindBuffer( GL.ARRAY_BUFFER, _vertexBuffer );
		GL.bufferData( GL.ARRAY_BUFFER, new Float32Array( _vertices ), GL.DYNAMIC_DRAW );
		GL.bindBuffer( GL.ARRAY_BUFFER, null );
		
		// Build indexes based on the number of quads
		var indices : Array<Int> = [];
		for ( i in 0...(_vertices.length / QUAD_SIZE)) {
			indices.push(0);
			indices.push(1);
			indices.push(2);
			indices.push(1);
			indices.push(3);
			indices.push(2);
		}
		
		GL.bindBuffer( GL.ELEMENT_ARRAY_BUFFER, _indexBuffer );
		GL.bufferData( GL.ELEMENT_ARRAY_BUFFER, new UInt8Array( indices ), GL.UNSIGNED_SHORT );
		GL.bindBuffer( GL.ELEMENT_ARRAY_BUFFER, null );
		
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
	
	public function fillRect(red:Float, green:Float, blue:Float, alpha:Float, width:Float, height:Float, transform:Matrix):Void 
	{
		
		var batch : GLBatchData = _batches.[ _batches.length - 1 ];
		
		if ( batch.shader == _fillShaderProgram ) {
			batch.length += QUAD_SIZE;	
		}else {
			batch = new GLBatchData();
			batch.start = _vertices.length;
			batch.length = QUAD_SIZE;
			batch.shader = _fillShaderProgram;
			batch.texture = null;
			_batches.push( batch );
		}
		
		var arr : Array<Point> = [
			transform.transformPoint( new Point( 0, 0 ) ),
			transform.transformPoint( new Point( 0, height ),
			transform.transformPoint( new Point( width, 0 ),
			transform.transformPoint( new Point( width, height )
		];
		
		for ( point in arr ) {
			_vertices.push( point.x );
			_vertices.push( point.y );
			_vertices.push( red );
			_vertices.push( green );
			_vertices.push( blue );
			_vertices.push( alpha );
			_vertices.push( 0 );
			_vertices.push( 0 );
		}
		
	}
	
	public function drawImage(textureId:String, transform:Matrix, alpha:Float):Void 
	{
		GL.uniformMatrix3D( _imageShaderProgram.uniforms.get("uProjectionMatrix"), false, _projectionMatrix );
		
	}
	
	public function drawSubImage(textureId:String, subImageId:String, transform:Matrix, alpha:Float):Void 
	{
		
	}
	
	/**
	 * Hardware rendering
	 * @param	rect
	 */
	
	private function _onRender( rect : Rectangle ) : Void {
		
		GL.viewport( Std.int( rect.x ), Std.int( rect.y ), Std.int( rect.width ), Std.int( rect.height ) );
		GL.clear( GL.COLOR_BUFFER_BIT );
				
		_projectionMatrix = Matrix3D.createOrtho( 0, rect.width, 0, rect.height, 1, -1 );
		
	}
	
	
		
	/* INTERFACE uk.co.mojaworks.frameworkv2.renderer.ICanvas */
	
	public function getDisplayObject():DisplayObject 
	{
		return _canvas;
	}
	
	
	
	
	
	
	
}