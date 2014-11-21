package uk.co.mojaworks.norman.systems.renderer.gl ;
import haxe.ds.Vector;
import lime.math.Rectangle;
import lime.graphics.GLRenderContext;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.RenderContext;
import lime.math.Matrix4;
import lime.math.Vector4;
import lime.utils.Float32Array;
import lime.utils.Int8Array;
import lime.utils.UInt8Array;
import uk.co.mojaworks.norman.engine.NormanApp;
import uk.co.mojaworks.norman.systems.renderer.batching.RenderBatch;
import uk.co.mojaworks.norman.systems.renderer.shaders.IShaderProgram;
import uk.co.mojaworks.norman.systems.renderer.TextureData;
import uk.co.mojaworks.norman.utils.Color;

/**
 * ...
 * @author Simon
 */
class GLCanvas implements ICanvas
{
	
	private static inline var VERTEX_SIZE : Int = 9;
	private static inline var VERTEX_POSITION : Int = 0;
	private static inline var VERTEX_COLOR : Int = 3;
	private static inline var VERTEX_UV : Int = 7;
	
	private var _context : GLRenderContext;
	private var _stageWidth : Int;
	private var _stageHeight : Int;
	
	private var _vertexBuffer : GLBuffer;
	private var _indexBuffer : GLBuffer;
	private var _projectionMatrix : Matrix4;

	private var _batch : RenderBatch;
	
	public function new( context : GLRenderContext ) : Void 
	{
		
		_context = cast context;
		
		_batch = new RenderBatch();
		_vertexBuffer = _context.createBuffer();
		_indexBuffer = _context.createBuffer();
		
	}
	
	public function resize( width : Int, height : Int ) : Void 
	{
		// Create our render target
		_stageWidth = width;
		_stageHeight = height;
	}
		
	public function getContext() : GLRenderContext {
		return _context;
	}
	
	public function fillRect( r : Float, g : Float, b : Float, a : Float, width : Float, height : Float, transform : Matrix4, shader : IShaderProgram ):Void 
	{
		// If the last batch is not compatible then render the last batch
		if ( _batch.started && (_batch.shader != shader || _batch.texture != null ) ) {
			renderBatch();
		}
		
		var startIndex : Int = Std.int(_batch.vertices.length / VERTEX_SIZE);
		
		var points : Array<Float> = [
			width, height, 0,
			0, height, 0,
			width, 0, 0,
			0, 0, 0		
		];
		
		var points_trans : Float32Array = new Float32Array( points );
		transform.transformVectors( points_trans, points_trans );
		
		for ( i in 0...4 ) {
			_batch.vertices.push( points_trans[(i * 3) + 0] );
			_batch.vertices.push( points_trans[(i * 3) + 1] );
			_batch.vertices.push( points_trans[(i * 3) + 2] );
			_batch.vertices.push( r / 255 );
			_batch.vertices.push( g / 255 );
			_batch.vertices.push( b / 255 );
			_batch.vertices.push( a );
			// Fake the UV coords just for consistency
			_batch.vertices.push( 0 );
			_batch.vertices.push( 0 );
		}
		
		_batch.indices.push( startIndex + 0 );
		_batch.indices.push( startIndex + 1 );
		_batch.indices.push( startIndex + 2 );
		_batch.indices.push( startIndex + 1 );
		_batch.indices.push( startIndex + 3 );
		_batch.indices.push( startIndex + 2 );
		
		if ( !_batch.started ) {
			_batch.shader = shader;
			_batch.texture = null;
			_batch.started = true;
		}
		
	}
	
	public function drawImage(texture : TextureData, transform : Matrix4, shader : IShaderProgram, r : Float = 255, g : Float = 255, b : Float = 255, a : Float = 1 ):Void 
	{
		drawSubImage( texture, new Rectangle(0, 0, 1, 1), transform, shader, r, g, b, a );
	}
	
	public function drawSubImage(texture : TextureData, sourceRect : Rectangle, transform : Matrix4, shader : IShaderProgram, r : Float = 255, g : Float = 255, b : Float = 255, a : Float = 1 ):Void 
	{
		// If the last batch is not compatible then render the last batch
		if ( _batch.started && ( _batch.shader != shader || _batch.texture != texture ) ) {
			renderBatch();
		}
		
		var startIndex : Int = Std.int(_batch.vertices.length / VERTEX_SIZE);
		var width : Float = sourceRect.width * texture.sourceImage.width;
		var height : Float = sourceRect.height * texture.sourceImage.height;
		
		var points : Array<Float> = [
			width, height, 0,
			0, height, 0,
			width, 0, 0,
			0, 0, 0		
		];
		
		var points_trans : Float32Array = new Float32Array( points );
		transform.transformVectors( points_trans, points_trans );
		
		var uvs : Array<Float> = [
			sourceRect.right, sourceRect.bottom,
			sourceRect.left, sourceRect.bottom,
			sourceRect.right, sourceRect.top,
			sourceRect.left, sourceRect.top
		];
		
		for ( i in 0...4 ) {
			_batch.vertices.push( points_trans[(i * 3) + 0] );
			_batch.vertices.push( points_trans[(i * 3) + 1] );
			_batch.vertices.push( points_trans[(i * 3) + 2] );
			_batch.vertices.push( r / 255 );
			_batch.vertices.push( g / 255 );
			_batch.vertices.push( b / 255 );
			_batch.vertices.push( a );
			_batch.vertices.push( uvs[ (i*2) + 0 ] );
			_batch.vertices.push( uvs[ (i*2) + 1 ] );
		}
		
		_batch.indices.push( startIndex + 0 );
		_batch.indices.push( startIndex + 1 );
		_batch.indices.push( startIndex + 2 );
		_batch.indices.push( startIndex + 1 );
		_batch.indices.push( startIndex + 3 );
		_batch.indices.push( startIndex + 2 );
		
		if ( !_batch.started ) {
			_batch.shader = shader;
			_batch.texture = texture;
			_batch.started = true;
		}
	}
	
	public function clear():Void 
	{
		_context.clearColor( 0, 0, 0, 1 );
		_context.clear( GL.COLOR_BUFFER_BIT );
	}
	
	public function begin() : Void {
		_batch.reset();
		_projectionMatrix = Matrix4.createOrtho( 0, _stageWidth, _stageHeight, 0, -1000, 1000 );
		_context.viewport( 0, 0, _stageWidth, _stageHeight );
	}
	
	public function complete() : Void {
		renderBatch();
	}
	
	public function pushRenderTarget( target : TextureData ) : Void {
		//_context.createFramebuffer
	}
	
	private function renderBatch( ) : Void {
				
		// First buffer the data so GL can use it
		_context.bindBuffer( GL.ARRAY_BUFFER, _vertexBuffer );
		_context.bufferData( GL.ARRAY_BUFFER, new Float32Array( _batch.vertices ), GL.DYNAMIC_DRAW );
		
		_context.bindBuffer( GL.ELEMENT_ARRAY_BUFFER, _indexBuffer );
		_context.bufferData( GL.ELEMENT_ARRAY_BUFFER, new UInt8Array( _batch.indices ), GL.DYNAMIC_DRAW );
				
		// Set the blend mode
		_context.blendFunc(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA);
		_context.enable( GL.BLEND );
		
		// Set up the shaders
		var shader : GLShaderProgram = cast _batch.shader;
		_context.useProgram( shader.program );
		
		var uvAttrib : Int = 0;
		if ( _batch.texture != null ) {
			
			uvAttrib = _context.getAttribLocation( shader.program, "aVertexUV" );
			var uTexture0 = _context.getUniformLocation( shader.program, "uTexture0" );
			
			_context.enableVertexAttribArray( uvAttrib );
			_context.vertexAttribPointer( uvAttrib, 2, GL.FLOAT, false, VERTEX_SIZE * 4, VERTEX_UV * 4 );
			
			_context.activeTexture( GL.TEXTURE0 );
			_context.bindTexture( GL.TEXTURE_2D, cast( _batch.texture, GLTextureData ).texture );
			_context.uniform1i( uTexture0, 0 );
			
		}
		
		var vertexAttr = _context.getAttribLocation( shader.program, "aVertexPosition" );
		var colorAttr = _context.getAttribLocation( shader.program, "aVertexColor" );
		var projectionUniform = _context.getUniformLocation( shader.program, "uProjectionMatrix" );
		
		_context.enableVertexAttribArray( vertexAttr );
		_context.enableVertexAttribArray( colorAttr );
		
		// Assign values to the shader
		_context.vertexAttribPointer( vertexAttr, 3, GL.FLOAT, false, VERTEX_SIZE * 4, VERTEX_POSITION  * 4);
		_context.vertexAttribPointer( colorAttr, 4, GL.FLOAT, false, VERTEX_SIZE * 4, VERTEX_COLOR  * 4);
		_context.uniformMatrix4fv( projectionUniform, false, _projectionMatrix );
		
		// Draw the things
		_context.drawElements( GL.TRIANGLES, _batch.indices.length, GL.UNSIGNED_BYTE, 0 );
		
		// Clean up
		_context.useProgram( null );
		_context.disableVertexAttribArray( vertexAttr );
		_context.disableVertexAttribArray( colorAttr );
		_context.bindBuffer( GL.ARRAY_BUFFER, null );
		_context.bindBuffer( GL.ELEMENT_ARRAY_BUFFER, null );
		
		if ( _batch.texture != null ) {
			_context.disableVertexAttribArray( uvAttrib );
			_context.bindTexture( GL.TEXTURE_2D, null );
		}
		
		#if gl_debug
			if ( _context.getError() > 0 ) trace( "GL Error:", _context.getError() );
		#end
		
		_batch.reset();
	}
	
}