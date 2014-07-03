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
	
	private static inline var VERTEX_SIZE : Int = 8;
	private static inline var VERTEX_POS : Int = 0;
	private static inline var VERTEX_COLOR : Int = 2;
	private static inline var VERTEX_TEX : Int = 6;
	
	var _vertexBuffer : GLBuffer;
	var _indexBuffer : GLBuffer;
	var _batches : Array<GLBatchData>;
	
	// A temporary array re-generated each frame with positions of all vertices
	var _vertices:Array<Float>;
	var _indices:Array<Int>;
	var _root : GameObject;
	
	// The opengl view object used to reserve our spot on the display list
	var _canvas : OpenGLView;
	
	// Relevant shaders
	var _imageShader : GLShaderWrapper;
	var _fillShader : GLShaderWrapper;
	
	var _projectionMatrix : Matrix3D;
	var _modelViewMatrix : Matrix3D;
	
	
	public function new() 
	{
		
	}
	
	public function init(rect:Rectangle) 
	{		
		_vertices = [];
		_batches = [];
		_indices = [];
		
		initShaders();
		initBuffer();
		
		_canvas = new OpenGLView();
		_canvas.render = _onRender;
		
		GL.clearColor( 0, 0, 0, 1 );
		
		_modelViewMatrix = new Matrix3D();
		_modelViewMatrix.identity();
		
		resize( rect );
	}
	
	private function initShaders() : Void {
		
		_imageShader = new GLShaderWrapper( 
			Assets.getText("shaders/image.vs.glsl"),
			Assets.getText("shaders/image.fs.glsl"),
			["uProjectionMatrix", "uModelViewMatrix", "uImage0"],
			["aTexCoord", "aVertexPosition"]
		);
		
		_fillShader = new GLShaderWrapper( 
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
		_indices = [];
		
		// Collect all of the vertex data
		renderLevel( root );
		
		// Pass it to the graphics card
		trace("Pushing to vertex buffer", _vertices );
		
		GL.bindBuffer( GL.ARRAY_BUFFER, _vertexBuffer );
		GL.bufferData( GL.ARRAY_BUFFER, new Float32Array( cast _vertices ), GL.STATIC_DRAW );
		GL.bindBuffer( GL.ARRAY_BUFFER, null );
		
		trace("Pushing to index buffer", _indices );
		
		GL.bindBuffer( GL.ELEMENT_ARRAY_BUFFER, _indexBuffer );
		GL.bufferData( GL.ELEMENT_ARRAY_BUFFER, new UInt8Array( cast _indices ), GL.STATIC_DRAW );
		GL.bindBuffer( GL.ELEMENT_ARRAY_BUFFER, null );
		
	}
	
	private function renderLevel( root : GameObject ) : Void {
		var display : Display = root.get(Display);
		if ( display != null && display.visible && display.getFinalAlpha() > 0 ) {
			
			display.render( this );
			
			for ( child in root.children ) {
				renderLevel( child );
			}			
		}
	}
	
	public function fillRect(red:Float, green:Float, blue:Float, alpha:Float, width:Float, height:Float, transform:Matrix):Void 
	{
		
		var batch : GLBatchData = (_batches.length > 0) ? _batches[ _batches.length - 1 ] : null;
		var offset : Int = Math.floor(_vertices.length / VERTEX_SIZE);
		
		if ( batch != null && batch.shader == _fillShader ) {
			batch.length += 6;	
		}else {
			batch = new GLBatchData();
			batch.start = _indices.length;
			batch.length = 6;
			batch.shader = _fillShader;
			batch.texture = null;
			_batches.push( batch );
		}
		
		var arr : Array<Point> = [
			transform.transformPoint( new Point( 0, 0 ) ),
			transform.transformPoint( new Point( 0, height ) ),
			transform.transformPoint( new Point( width, 0 ) ),
			transform.transformPoint( new Point( width, height ) )
		];
		
		for ( point in arr ) {
			_vertices.push( point.x );
			_vertices.push( point.y );
			//_vertices.push( red );
			//_vertices.push( green );
			//_vertices.push( blue );
			//_vertices.push( alpha );
			_vertices.push( 0 );
			//_vertices.push( 0 );
		}
		
		// Build indexes
		_indices.push(0 + offset);
		_indices.push(1 + offset);
		_indices.push(2 + offset);
		_indices.push(1 + offset);
		_indices.push(3 + offset);
		_indices.push(2 + offset);
		
	}
	
	public function drawImage(textureId:String, transform:Matrix, alpha:Float):Void 
	{
		GL.uniformMatrix3D( _imageShader.uniforms.get("uProjectionMatrix"), false, _projectionMatrix );
		
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
		
		GL.clearColor( 0, 0, 0, 1 );
		GL.clear( GL.COLOR_BUFFER_BIT );
		
		_projectionMatrix = Matrix3D.createOrtho( 0, rect.width, rect.height, 0, 1000, -1000 );
		_modelViewMatrix = Matrix3D.create2D( 200, 200, 1, 0 );
		
		//GL.bindBuffer( GL.ELEMENT_ARRAY_BUFFER, _indexBuffer );
		
		for ( batch in _batches ) {
			
			trace("Drawing batch", batch.shader, batch.start, batch.length, batch.texture );
			
			GL.useProgram( batch.shader.program );
			
			GL.enableVertexAttribArray( batch.shader.attributes["aVertexPosition"] );
			
			GL.bindBuffer( GL.ARRAY_BUFFER, _vertexBuffer );
			GL.vertexAttribPointer( batch.shader.attributes["aVertexPosition"], 3, GL.FLOAT, false, 0, 0 );
			
			//if ( batch.texture == null ) {
				//GL.enableVertexAttribArray( batch.shader.attributes["aVertexColor"] );
				//GL.vertexAttribPointer( batch.shader.attributes["aVertexColor"], 4, GL.FLOAT, false, VERTEX_SIZE * 4, VERTEX_COLOR * 4 );
			//}else {
				//GL.enableVertexAttribArray( batch.shader.attributes["aTexCoord"] );
				//GL.vertexAttribPointer( batch.shader.attributes["aTexCoord"], 2, GL.FLOAT, false, VERTEX_SIZE * 4, VERTEX_TEX * 4 );
				//
				//GL.activeTexture(GL.TEXTURE0);
				//GL.bindTexture( GL.TEXTURE_2D, batch.texture );
				//GL.uniform1i( batch.shader.uniforms["uImage0"], 0 );
			//}
			
			//trace("Bind to uniform", batch.shader.uniforms["uProjectionMatrix"], _projectionMatrix.rawData.toArray() );
			//trace("Bind to uniform", batch.shader.uniforms["uModelViewMatrix"], _modelViewMatrix );
			GL.uniformMatrix3D( batch.shader.uniforms["uProjectionMatrix"], false, _projectionMatrix );
			GL.uniformMatrix3D( batch.shader.uniforms["uModelViewMatrix"], false, _modelViewMatrix );
			
			GL.drawArrays( GL.TRIANGLE_STRIP, 0, 4 );
			//GL.drawElements( GL.TRIANGLES, 6, GL.UNSIGNED_SHORT, 0 );
			
			//if ( batch.texture == null ) {
			
				GL.disableVertexAttribArray( batch.shader.attributes["aVertexColor"] );
			//}else {
				//GL.disableVertexAttribArray( batch.shader.attributes["aTexCoord"] );
				//GL.bindTexture( GL.TEXTURE_2D, null );
			//}
		}
		
		GL.bindBuffer( GL.ARRAY_BUFFER, null );
		GL.bindBuffer( GL.ELEMENT_ARRAY_BUFFER, null );
		GL.useProgram( null );
		
		
		trace( "Error code end", GL.getError() );
	}
	
	
		
	/* INTERFACE uk.co.mojaworks.frameworkv2.renderer.ICanvas */
	
	public function getDisplayObject():DisplayObject 
	{
		return _canvas;
	}
	
	
	
	
	
	
	
}