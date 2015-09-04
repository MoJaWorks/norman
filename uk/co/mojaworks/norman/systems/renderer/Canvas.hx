package uk.co.mojaworks.norman.systems.renderer;

import lime.graphics.GLRenderContext;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLProgram;
import lime.math.Matrix3;
import lime.math.Matrix4;
import lime.math.Rectangle;
import lime.math.Vector2;
import lime.utils.Float32Array;
import lime.utils.UInt16Array;
import uk.co.mojaworks.norman.systems.renderer.ShaderData;
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

	public static var WHOLE_IMAGE : Rectangle = new Rectangle( 0, 0, 1, 1 );
	
	var _context : GLRenderContext;
	var _batch : RenderBatch;
	
	var _vertexBuffer : GLBuffer;
	var _indexBuffer : GLBuffer;
	var _projectionMatrix : Matrix4;
	
	var _frameBufferStack : Array<FrameBuffer>;
	
	public var sourceBlendFactor( default, null ) : Int;
	public var sourceAlphaBlendFactor( default, null ) : Int;
	public var destinationBlendFactor( default, null ) : Int;
	public var destinationAlphaBlendFactor( default, null ) : Int;
	
	public function new() 
	{
		
	}
	
	public function init() : Void {
		_batch = new RenderBatch();
		_frameBufferStack = [];
	}
	
	public function onContextCreated( gl : GLRenderContext ) : Void {
		//trace("Setting up gl context");
		_context = gl;
		_vertexBuffer = _context.createBuffer();
		_indexBuffer = _context.createBuffer();
	}
	
	public function resize() : Void {
		// Does nothing - just here in case we need resize event
		// Get dimensions from the viewport
	}
	
	public function clear( color : Color ) : Void {
		_context.clearColor( color.r / 255, color.g / 255, color.b / 255, color.a );
		_context.clear( GL.COLOR_BUFFER_BIT );
	}
	
	public function setBlendMode( sourceFactor : Int, destinationFactor : Int ) : Void {
		if ( sourceFactor != sourceBlendFactor || sourceFactor != sourceAlphaBlendFactor || destinationFactor != destinationBlendFactor || destinationFactor != destinationAlphaBlendFactor ) {
			
			// Setting blend mode modifies state
			if ( _batch.started ) renderBatch();
			
			sourceBlendFactor = sourceFactor;
			sourceAlphaBlendFactor = sourceFactor;
			destinationBlendFactor = destinationFactor;
			destinationAlphaBlendFactor = destinationFactor;
			_context.blendFunc( sourceFactor, destinationFactor );
			
		}
	}
	
	public function setBlendModeSeparate( sourceFactor : Int, destinationFactor : Int, sourceAlphaFactor : Int, destAlphaFactor : Int ) : Void {
		if ( sourceFactor != sourceBlendFactor || sourceAlphaFactor != sourceAlphaBlendFactor || destinationFactor != destinationBlendFactor || destAlphaFactor != destinationAlphaBlendFactor ) {
			
			// Setting blend mode modifies state
			if ( _batch.started ) renderBatch();
			
			sourceBlendFactor = sourceFactor;
			sourceAlphaBlendFactor = sourceAlphaFactor;
			destinationBlendFactor = destinationFactor;
			destinationAlphaBlendFactor = destAlphaFactor;
			_context.blendFuncSeparate( sourceFactor, destinationFactor, sourceAlphaFactor, destAlphaFactor );
			
		}
	}
	
	public function begin() : Void {
		
		_batch.reset();
		
		_context.viewport( 0, 0, Std.int(Systems.viewport.screenWidth), Std.int(Systems.viewport.screenHeight) );
		_projectionMatrix = Matrix4.createOrtho( 0, Systems.viewport.screenWidth, Systems.viewport.screenHeight, 0, -1000, 1000 );
		
		_context.enable( GL.BLEND );
		setBlendMode( GL.ONE, GL.ONE_MINUS_SRC_ALPHA );
		
	}
	
	public function end() : Void {
		if ( _batch.started ) {
			renderBatch();
		}
	}
	
	public function fillRect( width : Float, height : Float, transform : Matrix3, r : Float, g : Float, b : Float, a : Float, shader : ShaderData, shaderVertexData : Array<Float> = null ) : Void 
	{
		
		if ( !_batch.isCompatible( shader, null  ) ) {
			
			if ( _batch.started ) {
				renderBatch();
			}
			
			_batch.started = true;
			_batch.shader = shader;
		}
		
		var startIndex : Int = Std.int(_batch.vertices.length / shader.vertexSize );
		
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
			_batch.vertices.push( (r / 255.0) * a );
			_batch.vertices.push( (g / 255.0) * a );
			_batch.vertices.push( (b / 255.0) * a );
			_batch.vertices.push( a );
			_batch.vertices.push( uv[i].x );
			_batch.vertices.push( uv[i].y );
			if ( shaderVertexData != null ) _batch.vertices = _batch.vertices.concat( shaderVertexData.slice( i * shader.dataSize, (i + 1) * shader.dataSize ) );
		}
		
		// Add the vertices
		_batch.indices.push( startIndex + 0 );
		_batch.indices.push( startIndex + 1 );
		_batch.indices.push( startIndex + 2 );
		_batch.indices.push( startIndex + 1 );
		_batch.indices.push( startIndex + 3 );
		_batch.indices.push( startIndex + 2 );		
		
	}
	
	
	public function drawTexture( texture : TextureData, transform : Matrix3, r : Float, g : Float, b : Float, a : Float, shader : ShaderData, shaderVertexData : Array<Float> = null ) : Void 
	{
		drawSubtextures( [texture], [WHOLE_IMAGE], transform, r, g, b, a, shader, shaderVertexData );
	}
	
	public function drawTextures( textures : Array<TextureData>, transform : Matrix3, r : Float, g : Float, b : Float, a : Float, shader : ShaderData, shaderVertexData : Array<Float> = null ) : Void 
	{
		var rects : Array<Rectangle> = [];
		for ( i in 0...textures.length ) {
			rects.push( WHOLE_IMAGE );
		}
		drawSubtextures( textures, rects, transform, r, g, b, a, shader, shaderVertexData );
	}
	
	public function drawSubtexture( texture : TextureData, sourceRect : Rectangle, transform : Matrix3, r : Float, g : Float, b : Float, a : Float, shader : ShaderData, shaderVertexData : Array<Float> = null ) : Void 
	{
		drawSubtextures( [texture], [sourceRect], transform, r, g, b, a, shader, shaderVertexData );
	}
	
	public function drawSubtextures( textures : Array<TextureData>, sourceRects : Array<Rectangle>, transform : Matrix3, r : Float, g : Float, b : Float, a : Float, shader : ShaderData, shaderVertexData : Array<Float> = null ) : Void 
	{
		
		if ( !_batch.isCompatible( shader, textures )  ) {
			
			if ( _batch.started ) {
				renderBatch();
			}
			
			_batch.started = true;
			_batch.shader = shader;
			_batch.textures = textures;
		}
			
		var startIndex : Int = Std.int(_batch.vertices.length / shader.vertexSize );
		
		var points : Array<Vector2> = [
			new Vector2( textures[0].width * sourceRects[0].width, textures[0].height * sourceRects[0].height),
			new Vector2(0, textures[0].height * sourceRects[0].height),
			new Vector2(textures[0].width * sourceRects[0].width, 0),
			new Vector2(0, 0)
		];
		
		var uv : Array<Vector2> = [
			new Vector2(sourceRects[0].right, sourceRects[0].bottom),
			new Vector2(sourceRects[0].left, sourceRects[0].bottom),
			new Vector2(sourceRects[0].right, sourceRects[0].top ),
			new Vector2(sourceRects[0].left, sourceRects[0].top )
		];
		
		// Make points global with transform
		for ( i in 0...points.length ) {
			var transformed = transform.transformVector2( points[i] );
			_batch.vertices.push( transformed.x );
			_batch.vertices.push( transformed.y );
			_batch.vertices.push( (r / 255.0) * a );
			_batch.vertices.push( (g / 255.0) * a );
			_batch.vertices.push( (b / 255.0) * a );
			_batch.vertices.push( a );
			_batch.vertices.push( uv[i].x );
			_batch.vertices.push( uv[i].y );
			if ( shaderVertexData != null ) _batch.vertices = _batch.vertices.concat( shaderVertexData.slice( i * shader.dataSize, (i + 1) * shader.dataSize ) );
		}
		
		// Add the vertices
		_batch.indices.push( startIndex + 0 );
		_batch.indices.push( startIndex + 1 );
		_batch.indices.push( startIndex + 2 );
		_batch.indices.push( startIndex + 1 );
		_batch.indices.push( startIndex + 3 );
		_batch.indices.push( startIndex + 2 );		
		
	}
	
	
	public function pushRenderTarget( target : TextureData ) : Void {
		
		if ( _batch.started ) {
			renderBatch();
		}
		
		var frameBuffer : FrameBuffer = new FrameBuffer();
		
		frameBuffer.buffer = _context.createFramebuffer();
		frameBuffer.texture = target;
		
		_context.bindFramebuffer( GL.FRAMEBUFFER, frameBuffer.buffer );
		_context.framebufferTexture2D( GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, frameBuffer.texture.texture, 0 );
		
		_projectionMatrix = Matrix4.createOrtho( 0, frameBuffer.texture.width, 0, frameBuffer.texture.height, -1000, 1000 );
		_context.viewport( 0, 0, Std.int(frameBuffer.texture.width), Std.int(frameBuffer.texture.height) );
		
		_frameBufferStack.push( frameBuffer );
		
	}
	
	public function popRenderTarget( ) : Void {
		
		var frameBuffer : FrameBuffer = _frameBufferStack.pop();
		
		// Render the last batch to the frameBuffer
		if ( _batch.started ) {
			renderBatch();
		}
		
		// destroy this framebuffer - it was nice while it lasted
		_context.deleteFramebuffer( frameBuffer.buffer );
		frameBuffer.texture = null;
		
		// Go back to the previous buffer
		if ( _frameBufferStack.length > 0 ) {
			frameBuffer = _frameBufferStack[ _frameBufferStack.length - 1 ];
			_context.bindFramebuffer( GL.FRAMEBUFFER, frameBuffer.buffer );
			_projectionMatrix = Matrix4.createOrtho( 0, frameBuffer.texture.width, 0, frameBuffer.texture.height, -1000, 1000 );
			_context.viewport( 0, 0, Std.int(frameBuffer.texture.width), Std.int(frameBuffer.texture.height) );
		}else {
			// Back to stage
			_context.bindFramebuffer( GL.FRAMEBUFFER, null );
			_projectionMatrix = Matrix4.createOrtho( 0, Systems.viewport.screenWidth, Systems.viewport.screenHeight, 0, -1000, 1000 );
			_context.viewport( 0, 0, Std.int(Systems.viewport.screenWidth), Std.int(Systems.viewport.screenHeight) );
		}
		
	}
	
	
	
	private function renderBatch() : Void {
		
		
		if ( _batch.vertices.length > 0 ) {
			
			//trace("Rendering verts", _batch.vertices );
			//trace("Rendering indices", _batch.indices );
			
			_context.bindBuffer( GL.ARRAY_BUFFER, _vertexBuffer );
			_context.bufferData( GL.ARRAY_BUFFER, new Float32Array( _batch.vertices ), GL.STREAM_DRAW );
			
			_context.bindBuffer( GL.ELEMENT_ARRAY_BUFFER, _indexBuffer );
			_context.bufferData( GL.ELEMENT_ARRAY_BUFFER, new UInt16Array( _batch.indices ), GL.STREAM_DRAW );
			
			var program : GLProgram = _batch.shader.glProgram;
			_context.useProgram( program );
			
			var vertexAttrib = _context.getAttribLocation( program, "aVertexPosition" );
			var colorAttrib = _context.getAttribLocation( program, "aVertexColor" );
			var projectionUniform = _context.getUniformLocation( program, "uProjectionMatrix");
			
			var uvAttrib : Int = 0;
			if ( _batch.textures != null ) {
				
				//trace("Drawing with texture", _batch.texture.id, _batch.texture.texture );
				
				uvAttrib = _context.getAttribLocation( program, "aVertexUV" );
				var uTexture0 = _context.getUniformLocation( program, "uTexture0" );
				
				_context.enableVertexAttribArray( uvAttrib );
				_context.vertexAttribPointer( uvAttrib, 2, GL.FLOAT, false, _batch.shader.vertexSize * 4, VERTEX_UV * 4 );
				
				_context.activeTexture( GL.TEXTURE0 );
				_context.bindTexture( GL.TEXTURE_2D, _batch.textures[0].texture );
				_context.uniform1i( uTexture0, 0 );
				
			}
			
			var customAttributes : Array<Int> = [];
			for ( attribute in _batch.shader.attributes ) {
				var att : Int = _context.getAttribLocation( program, attribute.name );
				_context.enableVertexAttribArray( att );
				_context.vertexAttribPointer( att, attribute.size, GL.FLOAT, false, _batch.shader.vertexSize * 4, (VERTEX_SIZE + attribute.start) * 4 );
				customAttributes.push( att );
			}
			
			_context.enableVertexAttribArray( vertexAttrib );
			_context.enableVertexAttribArray( colorAttrib );
			
			_context.vertexAttribPointer( vertexAttrib, 2, GL.FLOAT, false, _batch.shader.vertexSize * 4, VERTEX_POSITION * 4);
			_context.vertexAttribPointer( colorAttrib, 4, GL.FLOAT, false, _batch.shader.vertexSize * 4, VERTEX_COLOR * 4);
			_context.uniformMatrix4fv( projectionUniform, false, _projectionMatrix );
			
			_context.drawElements( GL.TRIANGLES, _batch.indices.length, GL.UNSIGNED_SHORT, 0 );
			
			_context.useProgram( null );
			_context.disableVertexAttribArray( vertexAttrib );
			_context.disableVertexAttribArray( colorAttrib );
			
			for ( att in customAttributes ) {
				_context.disableVertexAttribArray( att );
			}
			
			_context.bindBuffer( GL.ARRAY_BUFFER, null );
			_context.bindBuffer( GL.ELEMENT_ARRAY_BUFFER, null );
			
			if ( _batch.textures != null ) {
				_context.disableVertexAttribArray( uvAttrib );
				_context.bindTexture( GL.TEXTURE_2D, null );
			}
						
			var error : Int = _context.getError();
			if ( error > 0 ) trace( "GL Error:", error );
			
		}
		
		_batch.reset();
	}
	
	public function forceRender() : Void {
		if ( _batch.started ) {
			renderBatch();
		}
	}
	
	
		
}