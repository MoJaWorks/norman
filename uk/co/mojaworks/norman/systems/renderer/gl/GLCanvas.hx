package uk.co.mojaworks.norman.systems.renderer.gl ;
import haxe.ds.Vector;
import lime.graphics.opengl.GLFramebuffer;
import lime.math.Matrix3;
import lime.math.Rectangle;
import lime.graphics.GLRenderContext;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.RenderContext;
import lime.math.Matrix4;
import lime.math.Vector2;
import lime.math.Vector4;
import lime.utils.Float32Array;
import lime.utils.Int8Array;
import lime.utils.UInt16Array;
import lime.utils.UInt8Array;
import uk.co.mojaworks.norman.components.display.ImageSprite;
import uk.co.mojaworks.norman.engine.NormanApp;
import uk.co.mojaworks.norman.systems.renderer.Constants.BlendFactor;
import uk.co.mojaworks.norman.systems.renderer.shaders.IShaderProgram;
import uk.co.mojaworks.norman.systems.renderer.ITextureData;
import uk.co.mojaworks.norman.utils.Color;

/**
 * ...
 * @author Simon
 */
class GLCanvas implements ICanvas
{
	
	private static inline var VERTEX_SIZE : Int = 8;
	private static inline var VERTEX_POSITION : Int = 0;
	private static inline var VERTEX_COLOR : Int = 2;
	private static inline var VERTEX_UV : Int = 6;
	
	private var _context : GLRenderContext;
	private var _stageWidth : Int;
	private var _stageHeight : Int;
	
	private var _vertexBuffer : GLBuffer;
	private var _indexBuffer : GLBuffer;
	private var _projectionMatrix : Matrix4;

	private var _batch : GLRenderBatch;
	private var _frameBufferStack : Array<GLFrameBufferData>;
	
	public var sourceBlendFactor( default, null ) : BlendFactor;
	public var destinationBlendFactor( default, null ) : BlendFactor;
	
	public function new( context : GLRenderContext ) : Void 
	{
		
		_frameBufferStack = [];
		_context = cast context;
		
		_batch = new GLRenderBatch();
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
	
	public function fillRect( r : Float, g : Float, b : Float, a : Float, width : Float, height : Float, transform : Matrix3, shader : IShaderProgram ):Void 
	{
		// If the last batch is not compatible then render the last batch
		if ( _batch.started && (_batch.shader != shader || _batch.texture != null ) ) {
			renderBatch();
		}
		
		var startIndex : Int = Std.int(_batch.vertices.length / VERTEX_SIZE);
		
		var points : Array<Vector2> = [
			new Vector2( width, height ),
			new Vector2( 0, height ),
			new Vector2( width, 0 ),
			new Vector2( 0, 0 )		
		];
		
		for ( i in 0...points.length ) {
			points[i] = transform.transformVector2( points[i] );
		}
		
		for ( i in 0...4 ) {
			_batch.vertices.push( points[i].x );
			_batch.vertices.push( points[i].y );
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
			_batch.shader = cast shader;
			_batch.texture = null;
			_batch.started = true;
		}
		
	}
	
	public function drawImage(texture : ITextureData, transform : Matrix3, shader : IShaderProgram, r : Float = 255, g : Float = 255, b : Float = 255, a : Float = 1 ):Void 
	{
		drawSubImage( texture, new Rectangle(0, 0, 1, 1), transform, shader, r, g, b, a );
	}
	
	public function drawSubImage(texture : ITextureData, sourceRect : Rectangle, transform : Matrix3, shader : IShaderProgram, r : Float = 255, g : Float = 255, b : Float = 255, a : Float = 1 ):Void 
	{
		// If the last batch is not compatible then render the last batch
		if ( _batch.started && ( _batch.shader != shader || _batch.texture != texture ) ) {
			renderBatch();
		}
		
		var startIndex : Int = Std.int(_batch.vertices.length / VERTEX_SIZE);
		var width : Float = sourceRect.width * texture.sourceImage.width;
		var height : Float = sourceRect.height * texture.sourceImage.height;
		
		var points : Array<Vector2> = [
			new Vector2( width, height ),
			new Vector2( 0, height ),
			new Vector2( width, 0 ),
			new Vector2( 0, 0 )		
		];
		
		for ( i in 0...points.length ) {
			points[i] = transform.transformVector2( points[i] );
		}
		
		var uvs : Array<Float> = [
			sourceRect.right, sourceRect.bottom,
			sourceRect.left, sourceRect.bottom,
			sourceRect.right, sourceRect.top,
			sourceRect.left, sourceRect.top
		];
		
		for ( i in 0...4 ) {
			_batch.vertices.push( points[i].x );
			_batch.vertices.push( points[i].y );
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
			_batch.shader = cast shader;
			_batch.texture = cast texture;
			_batch.started = true;
		}
	}
	
	public function clear( r : Int = 0, g : Int = 0, b : Int = 0, a : Float = 1 ):Void 
	{
		_context.clearColor( r/255, g/255, b/255, a );
		_context.clear( GL.COLOR_BUFFER_BIT );
	}
	
	public function setBlendMode( sourceFactor : BlendFactor, destinationFactor : BlendFactor ) : Void {
		if ( sourceFactor != sourceBlendFactor || destinationFactor != destinationBlendFactor ) {
			
			// Setting blend mode modifies state
			if ( _batch.started ) renderBatch();
			
			sourceBlendFactor = sourceFactor;
			destinationBlendFactor = destinationFactor;
			_context.blendFunc( cast sourceFactor, cast destinationFactor );
		}
	}
	
	public function begin() : Void {
		_batch.reset();
		_projectionMatrix = Matrix4.createOrtho( 0, _stageWidth, _stageHeight, 0, -1000, 1000 );
		_context.viewport( 0, 0, _stageWidth, _stageHeight );
		
		// Set the blend mode
		//_context.blendFunc(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA);
		_context.enable( GL.BLEND );
		setBlendMode( BlendFactor.SOURCE_ALPHA, BlendFactor.ONE_MINUS_SOURCE_ALPHA );
	}
	
	public function complete() : Void {
		if ( _batch.started ) renderBatch();
	}
	
	public function pushRenderTarget( target : ITextureData ) : Void {
		
		if ( _batch.started ) renderBatch();
		
		var frameBuffer : GLFrameBufferData = new GLFrameBufferData();
		
		frameBuffer.buffer = _context.createFramebuffer();
		frameBuffer.texture = cast target;
		
		_context.bindFramebuffer( GL.FRAMEBUFFER, frameBuffer.buffer );
		_context.framebufferTexture2D( GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, frameBuffer.texture.texture, 0 );
		
		_projectionMatrix = Matrix4.createOrtho( 0, frameBuffer.texture.sourceImage.width, 0, frameBuffer.texture.sourceImage.height, -1000, 1000 );
		_context.viewport( 0, 0, frameBuffer.texture.sourceImage.width, frameBuffer.texture.sourceImage.height );
		
		_frameBufferStack.push( frameBuffer );
		
	}
	
	public function popRenderTarget( ) : Void {
		
		var frameBuffer : GLFrameBufferData = _frameBufferStack.pop();
		// Don't think we need to do anything with this framebuffer?
		
		// Render the last batch to the frameBuffer
		if ( _batch.started ) renderBatch();
		
		// Go back to the previous buffer
		if ( _frameBufferStack.length > 0 ) {
			frameBuffer = _frameBufferStack[ _frameBufferStack.length - 1 ];
			_context.bindFramebuffer( GL.FRAMEBUFFER, frameBuffer.buffer );
			_projectionMatrix = Matrix4.createOrtho( 0, frameBuffer.texture.sourceImage.width, 0, frameBuffer.texture.sourceImage.height, -1000, 1000 );
			_context.viewport( 0, 0, frameBuffer.texture.sourceImage.width, frameBuffer.texture.sourceImage.height );
		}else {
			// Back to stage
			_context.bindFramebuffer( GL.FRAMEBUFFER, null );
			_projectionMatrix = Matrix4.createOrtho( 0, _stageWidth, _stageHeight, 0, -1000, 1000 );
			_context.viewport( 0, 0, _stageWidth, _stageHeight );
		}
		
	}
	
	private function renderBatch( ) : Void {
				
		if ( _batch.vertices.length > 0 ) {
			// First buffer the data so GL can use it
			_context.bindBuffer( GL.ARRAY_BUFFER, _vertexBuffer );
			_context.bufferData( GL.ARRAY_BUFFER, new Float32Array( _batch.vertices ), GL.STREAM_DRAW );
			
			_context.bindBuffer( GL.ELEMENT_ARRAY_BUFFER, _indexBuffer );
			_context.bufferData( GL.ELEMENT_ARRAY_BUFFER, new UInt16Array( _batch.indices ), GL.STREAM_DRAW );
			
			
			
			// Set up the shaders
			_context.useProgram( _batch.shader.program );
			
			var uvAttrib : Int = 0;
			if ( _batch.texture != null ) {
				
				uvAttrib = _context.getAttribLocation( _batch.shader.program, "aVertexUV" );
				var uTexture0 = _context.getUniformLocation( _batch.shader.program, "uTexture0" );
				
				_context.enableVertexAttribArray( uvAttrib );
				_context.vertexAttribPointer( uvAttrib, 2, GL.FLOAT, false, VERTEX_SIZE * 4, VERTEX_UV * 4 );
				
				_context.activeTexture( GL.TEXTURE0 );
				_context.bindTexture( GL.TEXTURE_2D, cast( _batch.texture, GLTextureData ).texture );
				_context.uniform1i( uTexture0, 0 );
				
			}
			
			var vertexAttr = _context.getAttribLocation( _batch.shader.program, "aVertexPosition" );
			var colorAttr = _context.getAttribLocation( _batch.shader.program, "aVertexColor" );
			var projectionUniform = _context.getUniformLocation( _batch.shader.program, "uProjectionMatrix" );
			
			_context.enableVertexAttribArray( vertexAttr );
			_context.enableVertexAttribArray( colorAttr );
			
			// Assign values to the shader
			_context.vertexAttribPointer( vertexAttr, 2, GL.FLOAT, false, VERTEX_SIZE * 4, VERTEX_POSITION  * 4);
			_context.vertexAttribPointer( colorAttr, 4, GL.FLOAT, false, VERTEX_SIZE * 4, VERTEX_COLOR  * 4);
			_context.uniformMatrix4fv( projectionUniform, false, _projectionMatrix );
			
			// Draw the things
			_context.drawElements( GL.TRIANGLES, _batch.indices.length, GL.UNSIGNED_SHORT, 0 );
			
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
		}
		
		_batch.reset();
	}
	
}