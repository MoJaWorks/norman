package uk.co.mojaworks.norman.core.renderer;
import geoff.math.Matrix3;
import geoff.math.Rect;
import geoff.math.Vector2;
import geoff.renderer.IRenderContext;
import geoff.renderer.RenderBatch;
import geoff.renderer.Shader;
import geoff.renderer.Texture;
import geoff.utils.Color;

/**
 * ...
 * @author test
 */
class Canvas
{

	public static var WHOLE_IMAGE : Rect = new Rect( 0, 0, 1, 1 );
	public static var QUAD_INDICES : Array<Int> = [ 0, 1, 2, 1, 3, 2 ];
	
	private var _context : IRenderContext;
	var _batch : RenderBatch;
	
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
		_cachedQuadVertexData = [for (i in 0...24) 0 ];
		_cachedTexturedQuadVertexData = [for (i in 0...32) 0];
		
	}
	
	public function onContextCreated( context : IRenderContext ) : Void {
		_context = context;
	}
	
	public function resize() : Void {
		// Does nothing - just here in case we need resize event
		// Get dimensions from the viewport
	}
	
	public function clear( color : Color ) : Void {
		_context.clear( color );
	}
	
	public function setBlendMode( sourceFactor : Int, destinationFactor : Int ) : Void {
		/*if ( sourceFactor != sourceBlendFactor || sourceFactor != sourceAlphaBlendFactor || destinationFactor != destinationBlendFactor || destinationFactor != destinationAlphaBlendFactor ) {
			
			// Setting blend mode modifies state
			if ( _batch.started ) renderBatch();
			
			sourceBlendFactor = sourceFactor;
			sourceAlphaBlendFactor = sourceFactor;
			destinationBlendFactor = destinationFactor;
			destinationAlphaBlendFactor = destinationFactor;
			_context.blendFunc( sourceFactor, destinationFactor );
			
		}*/
	}
	
	public function setBlendModeSeparate( sourceFactor : Int, destinationFactor : Int, sourceAlphaFactor : Int, destAlphaFactor : Int ) : Void {
		/*if ( sourceFactor != sourceBlendFactor || sourceAlphaFactor != sourceAlphaBlendFactor || destinationFactor != destinationBlendFactor || destAlphaFactor != destinationAlphaBlendFactor ) {
			
			// Setting blend mode modifies state
			if ( _batch.started ) renderBatch();
			
			sourceBlendFactor = sourceFactor;
			sourceAlphaBlendFactor = sourceAlphaFactor;
			destinationBlendFactor = destinationFactor;
			destinationAlphaBlendFactor = destAlphaFactor;
			_context.blendFuncSeparate( sourceFactor, destinationFactor, sourceAlphaFactor, destAlphaFactor );
			
		}*/
	}
	
	public function begin() : Void {
		
		_batch.reset();
		_context.beginRender( Std.int(Core.instance.view.screenWidth), Std.int(Core.instance.view.screenHeight) );
		
	}
	
	public function end() : Void {
		if ( _batch.started ) {
			renderBatch();
		}
		_context.endRender();
	}
		
	public function draw( textures : Array<Texture>, shader : Shader, shaderVertexData : Array<Float>, indices : Array<Int> ) {
		
		if ( !_batch.isCompatible( shader, cast textures )  ) {
			
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
			_batch.indexes.push( startIndex + index );
		}
				
	}
	
	public function buildQuadVertexData( width : Float, height : Float, transform : Matrix3, r : Float, g : Float, b : Float, a : Float ) : Array<Float> {
		
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
	
	public function buildShapeVertexData( points : Array<Vector2>, transform : Matrix3, r : Float, g : Float, b : Float, a : Float, useArray : Array<Float> = null ) : Array<Float> {
				
		var vertexData : Array<Float>;
		if ( useArray != null ) vertexData = useArray;
		else {
			vertexData = [for ( i in 0...(points.length * 6) ) 0];
		}
		
		// Make points global with transform
		for ( i in 0...points.length ) {
			var transformed = transform.transformVector2( points[i] );
			vertexData[(i * 6) + 0] = transformed.x;
			vertexData[(i * 6) + 1] = transformed.y;
			vertexData[(i * 6) + 2] = (r / 255.0) * a;
			vertexData[(i * 6) + 3] = (g / 255.0) * a;
			vertexData[(i * 6) + 4] = (b / 255.0) * a;
			vertexData[(i * 6) + 5] = a;
		}	
		
		return vertexData;
		
	}
	
	
	
	public function buildTexturedQuadVertexData( texture : Texture, sourceRect : Rect, transform : Matrix3, r : Float, g : Float, b : Float, a : Float ) : Array<Float> {
		
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
	
	
	public function pushRenderTarget( target : Texture ) : Void {
		
		if ( _batch.started ) {
			renderBatch();
		}
		
		/*var frameBuffer : FrameBuffer = new FrameBuffer();
		
		frameBuffer.buffer = _context.createFramebuffer();
		frameBuffer.texture = target;
		
		_context.bindFramebuffer( GL.FRAMEBUFFER, frameBuffer.buffer );
		_context.framebufferTexture2D( GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, frameBuffer.texture.texture, 0 );
		
		_projectionMatrix = Matrix4.createOrtho( 0, frameBuffer.texture.width, 0, frameBuffer.texture.height, -1000, 1000 );
		_context.viewport( 0, 0, Std.int(frameBuffer.texture.width), Std.int(frameBuffer.texture.height) );
		
		_frameBufferStack.push( frameBuffer );*/
		
	}
	
	public function popRenderTarget( ) : Void {
		
		//var frameBuffer : FrameBuffer = _frameBufferStack.pop();
		
		// Render the last batch to the frameBuffer
		if ( _batch.started ) {
			renderBatch();
		}
		
		// destroy this framebuffer - it was nice while it lasted
		/*_context.deleteFramebuffer( frameBuffer.buffer );
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
			_projectionMatrix = Matrix4.createOrtho( 0, Core.instance.view.screenWidth, Core.instance.view.screenHeight, 0, -1000, 1000 );
			_context.viewport( 0, 0, Std.int(Core.instance.view.screenWidth), Std.int(Core.instance.view.screenHeight) );
		}*/
		
	}
	
	
	
	private function renderBatch() : Void {
		
		if ( _batch.vertices.length > 0 ) 
		{
			_context.renderBatch( _batch );
		}
		
		_batch.reset();
	}
	
	public function forceRender() : Void {
		if ( _batch.started ) {
			renderBatch();
		}
	}
	
	
		
}