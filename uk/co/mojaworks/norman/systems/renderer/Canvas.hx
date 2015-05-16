package uk.co.mojaworks.norman.systems.renderer;

import lime.graphics.GLRenderContext;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLProgram;
import lime.math.Matrix3;
import lime.math.Matrix4;
import lime.math.Vector2;
import lime.utils.Float32Array;
import lime.utils.Int16Array;
import lime.utils.UInt16Array;
import uk.co.mojaworks.norman.utils.Color;

/**
 * ...
 * @author test
 */
class Canvas
{
	
	public static inline var VERTEX_SIZE : Int = 8;
	public static inline var VERTEX_POSITION : Int = 0;
	public static inline var VERTEX_COLOR : Int = 2;
	public static inline var VERTEX_UV : Int = 6;

	var _context : GLRenderContext;
	var _batch : RenderBatch;
	
	var _vertexBuffer : GLBuffer;
	var _indexBuffer : GLBuffer;
	var _projectionMatrix : Matrix4;
	
	public function new() 
	{
		
	}
	
	public function init() : Void {
		_batch = new RenderBatch();
	}
	
	public function onContextCreated( gl : GLRenderContext ) : Void {
		trace("Setting up gl context");
		_context = gl;
		_vertexBuffer = _context.createBuffer();
		_indexBuffer = _context.createBuffer();
	}
	
	public function resize() : Void {
		// Does nothing - just here in case we need resize event
		// Get dimensions from the viewport
	}
	
	public function begin() : Void {
		
		_batch.reset();
		_context.clearColor( 0, 0, 0, 1 );
		_context.clear( GL.COLOR_BUFFER_BIT );
		_context.viewport( 0, 0, Std.int(Systems.viewport.screenWidth), Std.int(Systems.viewport.screenHeight) );
		_projectionMatrix = Matrix4.createOrtho( 0, Systems.viewport.screenWidth, Systems.viewport.screenHeight, 0, -1000, 1000 );
		
		_context.enable( GL.BLEND );
		_context.blendFunc( GL.DST_ALPHA, GL.ONE_MINUS_SRC_ALPHA );
		
	}
	
	public function end() : Void {
		if ( _batch.started ) renderBatch();
	}
	
	public function fillRect( width : Float, height : Float, transform : Matrix3, r : Float, g : Float, b : Float, a : Float, shaderId : String = "defaultFill" ) : Void 
	{
		if ( _batch.started && _batch.shaderId != shaderId ) {
			renderBatch();
			_batch.reset();
		}
		
		_batch.started = true;
		_batch.shaderId = shaderId;
		
		var startIndex = _batch.vertices.length;
		
		var points : Array<Vector2> = [
			new Vector2(width, height),
			new Vector2(0, height),
			new Vector2(width, 0),
			new Vector2(0, 0)
		];
		
		var uv : Array<Vector2> = [
			new Vector2(1, 1),
			new Vector2(0, 1),
			new Vector2(1, 0),
			new Vector2(0, 0)
		];
		
		// Make points global with transform
		for ( i in 0...points.length ) {
			var transformed = transform.transformVector2( points[i] );
			_batch.vertices.push( transformed.x );
			_batch.vertices.push( transformed.y );
			_batch.vertices.push( r / 255.0 );
			_batch.vertices.push( g / 255.0 );
			_batch.vertices.push( b / 255.0 );
			_batch.vertices.push( a );
			_batch.vertices.push( uv[i].x );
			_batch.vertices.push( uv[i].y );
		}
		
		// Add the vertices
		_batch.indices.push( startIndex + 0 );
		_batch.indices.push( startIndex + 1 );
		_batch.indices.push( startIndex + 2 );
		_batch.indices.push( startIndex + 1 );
		_batch.indices.push( startIndex + 3 );
		_batch.indices.push( startIndex + 2 );		
		
	}
	
	private function renderBatch() : Void {
		
		
		if ( _batch.vertices.length > 0 ) {
			
			trace("Rendering batch", _batch.vertices );
			
			_context.bindBuffer( GL.ARRAY_BUFFER, _vertexBuffer );
			_context.bufferData( GL.ARRAY_BUFFER, new Float32Array( _batch.vertices ), GL.STREAM_DRAW );
			
			_context.bindBuffer( GL.ELEMENT_ARRAY_BUFFER, _indexBuffer );
			_context.bufferData( GL.ELEMENT_ARRAY_BUFFER, new UInt16Array( _batch.indices ), GL.STREAM_DRAW );
			
			var program : GLProgram = Systems.renderer.shaderManager.getProgram( _batch.shaderId );
			_context.useProgram( program );
			
			var vertexAttrib = _context.getAttribLocation( program, "aVertexPosition" );
			var colorAttrib = _context.getAttribLocation( program, "aVertexColor" );
			var projectionUniform = _context.getUniformLocation( program, "uProjectionMatrix");
			
			_context.enableVertexAttribArray( vertexAttrib );
			_context.enableVertexAttribArray( colorAttrib );
			
			_context.vertexAttribPointer( vertexAttrib, 2, GL.FLOAT, false, VERTEX_SIZE * 4, VERTEX_POSITION * 4);
			_context.vertexAttribPointer( colorAttrib, 4, GL.FLOAT, false, VERTEX_SIZE * 4, VERTEX_COLOR * 4);
			_context.uniformMatrix4fv( projectionUniform, false, _projectionMatrix );
			
			_context.drawElements( GL.TRIANGLES, _batch.indices.length, GL.UNSIGNED_SHORT, 0 );
			
			_context.useProgram( null );
			_context.disableVertexAttribArray( vertexAttrib );
			_context.disableVertexAttribArray( colorAttrib );
			
			_context.bindBuffer( GL.ARRAY_BUFFER, null );
			_context.bindBuffer( GL.ELEMENT_ARRAY_BUFFER, null );
						
			if ( _context.getError() > 0 ) trace( "GL Error:", _context.getError() );
			
			_batch.reset();
			
		}
	}
	
	
		
}