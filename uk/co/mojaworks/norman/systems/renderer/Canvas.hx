package uk.co.mojaworks.norman.systems.renderer;

import lime.graphics.GLRenderContext;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
import lime.math.Matrix3;
import lime.math.Matrix4;
import lime.math.Rectangle;
import lime.math.Vector2;
import lime.utils.ArrayBufferView;
import lime.utils.Float32Array;
import lime.utils.Int16Array;
import uk.co.mojaworks.norman.systems.renderer.ICanvas;
import uk.co.mojaworks.norman.utils.Color;

/**
 * ...
 * @author test
 */
class Canvas implements ICanvas
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
	
	public function init( gl : GLRenderContext ) {
		_context = gl;
		
		_batch = new RenderBatch();
		_vertexBuffer = _context.createBuffer();
		_indexBuffer = _context.createBuffer();
	}
	
	public function resize() : Void {
		// Does nothing - just here in case we need resize event
		// Get dimensions from the viewport
	}
	
	public function begin() : Void {
		_batch.reset();
		
		_context.viewport( 0, 0, Std.int(Systems.viewport.stageWidth), Std.int(Systems.viewport.stageHeight) );
		_projectionMatrix = Matrix4.createOrtho( 0, Systems.viewport.stageWidth, Systems.viewport.stageHeight, 0, -1000, 1000 );
		
	}
	
	public function end() : Void {
		if ( _batch.started ) renderBatch();
	}
	
	public function fillRect( color : Color, transform : Matrix3, shaderId : String = "defaultFill" ) : Void 
	{
		if ( _batch.started && _batch.shaderId != shaderId ) {
			renderBatch();
			_batch.reset();
		}
		
		_batch.started = true;
		_batch.shaderId = shaderId;
		
		var points : Array<Vector2> = [
			new Vector2(0, 0),
			new Vector2(1, 0),
			new Vector2(0, 1),
			new Vector2(1, 1)
		];
		
		// Make points global with transform
		for ( i in 0...points.length ) {
			var transformed = transform.transformVector2( points[i] );
			_batch.vertices.push( transformed.x );
			_batch.vertices.push( transformed.y );
			_batch.vertices.push( color.r / 255.0 );
			_batch.vertices.push( color.g / 255.0 );
			_batch.vertices.push( color.b / 255.0 );
			_batch.vertices.push( color.a );
			_batch.vertices.push( points[i].x );
			_batch.vertices.push( points[i].y );
		}
		
		// Add the vertices
		var startIndex = _batch.vertices.length;
		_batch.indices.push( startIndex + 0 );
		_batch.indices.push( startIndex + 1 );
		_batch.indices.push( startIndex + 2 );
		_batch.indices.push( startIndex + 1 );
		_batch.indices.push( startIndex + 2 );
		_batch.indices.push( startIndex + 3 );		
		
	}
	
	private function renderBatch() : Void {
		
		if ( _batch.vertices.length > 0 ) {
			
			_context.bindBuffer( GL.ARRAY_BUFFER, _vertexBuffer );
			_context.bufferData( GL.ARRAY_BUFFER, new Float32Array( _batch.vertices ), GL.STREAM_DRAW );
			
			_context.bindBuffer( GL.ELEMENT_ARRAY_BUFFER, _indexBuffer );
			_context.bufferData( GL.ELEMENT_ARRAY_BUFFER, new Int16Array( _batch.indices ), GL.STREAM_DRAW );
			
			
			
		}
	}
	
	
		
}