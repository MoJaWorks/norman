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
import uk.co.mojaworks.norman.display.RenderSprite;
import uk.co.mojaworks.norman.systems.renderer.ShaderData;
import uk.co.mojaworks.norman.utils.Color;

/**
 * ...
 * @author test
 */
class Canvas
{

	public static var WHOLE_IMAGE : Rectangle = new Rectangle( 0, 0, 1, 1 );
	public static var QUAD_INDICES : Array<Int> = [ 0, 1, 2, 1, 3, 2 ];
	
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
	
	// These arrays are constantly reused to avoid recreating multiple times every frame
	private var _cachedQuadVertexData : Array<Float>;
	private var _cachedTexturedQuadVertexData : Array<Float>;
	
	public function new() 
	{
		
	}
	
	public function init() : Void {
		_batch = new RenderBatch();
		_frameBufferStack = [];
		_cachedQuadVertexData = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
		_cachedTexturedQuadVertexData = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] ;
		
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
		
	public function draw( textures : Array<TextureData>, shader : ShaderData, shaderVertexData : Array<Float>, indices : Array<Int> ) {
		
		if ( !_batch.isCompatible( shader, textures )  ) {
			
			if ( _batch.started ) {
				renderBatch();
			}
			
			_batch.started = true;
			_batch.shader = shader;
			_batch.textures = textures;
		}
		
		var startIndex : Int = Std.int(_batch.vertices.length / shader.vertexSize );
		
		for ( i in 0...shaderVertexData.length ) {
			_batch.vertices.push( shaderVertexData[i] );
		}
		
		for ( index in indices ) {
			_batch.indices.push( startIndex + index );
		}
				
	}
	
	public function buildQuadVertexData( width : Float, height : Float, transform : Matrix3, r : Float, g : Float, b : Float, a : Float ) : Array<Float> {
		
		//var vertexData : Array<Float> = [];
				
		var points : Array<Vector2> = [
			new Vector2( width, height),
			new Vector2(0, height),
			new Vector2(width, 0),
			new Vector2(0, 0)
		];
				
		// Make points global with transform
		for ( i in 0...4 ) {
			var transformed = transform.transformVector2( points[i] );
			_cachedQuadVertexData[(i * 6) + 0] = transformed.x;
			_cachedQuadVertexData[(i * 6) + 1] = transformed.y;
			_cachedQuadVertexData[(i * 6) + 2] = (r / 255.0) * a;
			_cachedQuadVertexData[(i * 6) + 3] = (g / 255.0) * a;
			_cachedQuadVertexData[(i * 6) + 4] = (b / 255.0) * a;
			_cachedQuadVertexData[(i * 6) + 5] = a;
		}	
		
		return _cachedQuadVertexData;
		
	}
	
	public function buildTexturedQuadVertexData( texture : TextureData, sourceRect : Rectangle, transform : Matrix3, r : Float, g : Float, b : Float, a : Float ) : Array<Float> {
		
		var vertexData : Array<Float> = [];
				
		var points : Array<Vector2> = [
			new Vector2( texture.width * sourceRect.width, texture.height * sourceRect.height),
			new Vector2(0, texture.height * sourceRect.height),
			new Vector2(texture.width * sourceRect.width, 0),
			new Vector2(0, 0)
		];
		
		var uv : Array<Vector2> = [
			new Vector2(sourceRect.right, sourceRect.bottom),
			new Vector2(sourceRect.left, sourceRect.bottom),
			new Vector2(sourceRect.right, sourceRect.top ),
			new Vector2(sourceRect.left, sourceRect.top )
		];
		
		// Make points global with transform
		for ( i in 0...4 ) {
			var transformed = transform.transformVector2( points[i] );
			_cachedTexturedQuadVertexData[(i * 8) + 0] = transformed.x;
			_cachedTexturedQuadVertexData[(i * 8) + 1] = transformed.y;
			_cachedTexturedQuadVertexData[(i * 8) + 2] = (r / 255.0) * a;
			_cachedTexturedQuadVertexData[(i * 8) + 3] = (g / 255.0) * a;
			_cachedTexturedQuadVertexData[(i * 8) + 4] = (b / 255.0) * a;
			_cachedTexturedQuadVertexData[(i * 8) + 5] = a;
			_cachedTexturedQuadVertexData[(i * 8) + 6] = uv[i].x;
			_cachedTexturedQuadVertexData[(i * 8) + 7] = uv[i].y;
		}	
		
		return _cachedTexturedQuadVertexData;
		
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
			
			var projectionUniform = _context.getUniformLocation( program, "uProjectionMatrix");

			if ( _batch.textures != null ) {
				for ( i in 0..._batch.textures.length ) {
					
					//trace("Drawing with texture", _batch.texture.id, _batch.texture.texture );
					var uTexture = _context.getUniformLocation( program, "uTexture" + i );
					_context.activeTexture( GL.TEXTURE0 + i );
					_context.bindTexture( GL.TEXTURE_2D, _batch.textures[i].texture );
					_context.uniform1i( uTexture, i );
					
				}
			}
			
			var customAttributes : Array<Int> = [];
			for ( attribute in _batch.shader.attributes ) {
				var att : Int = _context.getAttribLocation( program, attribute.name );
				_context.enableVertexAttribArray( att );
				_context.vertexAttribPointer( att, attribute.size, GL.FLOAT, false, _batch.shader.vertexSize * 4, (attribute.start) * 4 );
				customAttributes.push( att );
			}
			
			_context.uniformMatrix4fv( projectionUniform, false, _projectionMatrix );
			_context.drawElements( GL.TRIANGLES, _batch.indices.length, GL.UNSIGNED_SHORT, 0 );
			
			
			for ( att in customAttributes ) {
				_context.disableVertexAttribArray( att );
			}
			
			_context.useProgram( null );
			_context.bindBuffer( GL.ARRAY_BUFFER, null );
			_context.bindBuffer( GL.ELEMENT_ARRAY_BUFFER, null );
			
			if ( _batch.textures != null ) {
				for ( i in 0..._batch.textures.length ) {
					_context.activeTexture( GL.TEXTURE0 + i );
					_context.bindTexture( GL.TEXTURE_2D, null );
				}
			}
			
		}
		
		_batch.reset();
	}
	
	public function forceRender() : Void {
		if ( _batch.started ) {
			renderBatch();
		}
	}
	
	
		
}