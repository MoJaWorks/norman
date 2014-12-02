package uk.co.mojaworks.norman.systems.renderer.stage3d;
import flash.display3D.Context3D;
import flash.display3D.Context3DBlendFactor;
import flash.display3D.Context3DProgramType;
import flash.display3D.Context3DVertexBufferFormat;
import flash.display3D.IndexBuffer3D;
import flash.display3D.VertexBuffer3D;
import flash.geom.Matrix3D;
import flash.geom.Vector3D;
import lime.math.Matrix4;
import lime.math.Rectangle;
import lime.math.Vector4;
import lime.utils.Float32Array;
import uk.co.mojaworks.norman.systems.renderer.ITextureData;
import uk.co.mojaworks.norman.systems.renderer.shaders.IShaderProgram;
import uk.co.mojaworks.norman.systems.renderer.stage3d.Stage3DFrameBufferData;

/**
 * ...
 * @author ...
 */
class Stage3DCanvas implements ICanvas
{

	private static inline var VERTEX_SIZE : Int = 9;
	private static inline var VERTEX_POSITION : Int = 0;
	private static inline var VERTEX_COLOR : Int = 3;
	private static inline var VERTEX_UV : Int = 7;
	
	private var _context : Context3D;
	private var _stageWidth : Int;
	private var _stageHeight : Int;
		
	private var _projectionMatrix : Matrix3D;

	private var _batch : Stage3DRenderBatch;
	private var _frameBufferStack : Array<Stage3DFrameBufferData>;
	
	public function new( context : Context3D ) : Void 
	{
		
		_frameBufferStack = [];
		_context = context;
		
		_batch = new Stage3DRenderBatch();
		
		#if gl_debug
			_context.enableErrorChecking = true;
		#end
		
	}
	
	public function resize( width : Int, height : Int ) : Void 
	{
		// Create our render target
		_stageWidth = width;
		_stageHeight = height;
	}
		
	public function getContext() : Context3D {
		return _context;
	}
	
	public function fillRect( r : Float, g : Float, b : Float, a : Float, width : Float, height : Float, transform : Matrix4, shader : IShaderProgram ):Void 
	{
		// If the last batch is not compatible then render the last batch
		if ( _batch.started && (_batch.shader != shader || _batch.texture != null ) ) {
			renderBatch();
		}
		
		var startIndex : Int = Std.int(_batch.vertices.length / VERTEX_SIZE);
		
		var points : Array<Vector4> = [
			new Vector4( width, height, 0 ),
			new Vector4( 0, height, 0 ),
			new Vector4( width, 0, 0 ),
			new Vector4( 0, 0, 0 )
		];
		
		//trace("Before", points[0], transform[0] );
		//
		//for ( i in 0...points.length ) {
			//points[i] = transform.transformVector( points[i] );
		//}
		//trace("After", points[0]);
		
		
		for ( i in 0...4 ) {
			_batch.vertices.push( points[i].x );
			_batch.vertices.push( points[i].y );
			_batch.vertices.push( points[i].z );
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
	
	public function drawImage(texture : ITextureData, transform : Matrix4, shader : IShaderProgram, r : Float = 255, g : Float = 255, b : Float = 255, a : Float = 1 ):Void 
	{
		var stage3DTexture : Stage3DTextureData = cast texture;
		drawSubImage( texture, new Rectangle(0, 0, stage3DTexture.xPerc, stage3DTexture.yPerc), transform, shader, r, g, b, a );
	}
	
	public function drawSubImage(texture : ITextureData, sourceRect : Rectangle, transform : Matrix4, shader : IShaderProgram, r : Float = 255, g : Float = 255, b : Float = 255, a : Float = 1 ):Void 
	{
		// If the last batch is not compatible then render the last batch
		if ( _batch.started && ( _batch.shader != shader || _batch.texture != texture ) ) {
			renderBatch();
		}
		
		var stage3DTexture : Stage3DTextureData = cast texture;
		var startIndex : Int = Std.int(_batch.vertices.length / VERTEX_SIZE);
		var width : Float = (sourceRect.width / stage3DTexture.xPerc) * stage3DTexture.sourceImage.width;
		var height : Float = (sourceRect.height / stage3DTexture.yPerc) * stage3DTexture.sourceImage.height;
		
		var points : Array<Vector4> = [
			new Vector4( width, height, 0 ),
			new Vector4( 0, height, 0 ),
			new Vector4( width, 0, 0 ),
			new Vector4( 0, 0, 0 )
		];
		
		//for ( i in 0...points.length ) {
			//points[i] = transform.transformVector( points[i] );
		//}
		
		var uvs : Array<Float> = [
			sourceRect.right, sourceRect.bottom,
			sourceRect.left, sourceRect.bottom,
			sourceRect.right, sourceRect.top,
			sourceRect.left, sourceRect.top
		];
		
		for ( i in 0...4 ) {
			_batch.vertices.push( points[i].x );
			_batch.vertices.push( points[i].y );
			_batch.vertices.push( points[i].z );
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
			_batch.texture = stage3DTexture;
			_batch.started = true;
		}
	}
	
	public function clear( r : Int = 0, g : Int = 0, b : Int = 0, a : Float = 1 ):Void 
	{
		_context.clear( r/255, g/255, b/255, a );
	}
	
	public function begin() : Void {
		_batch.reset();
		_projectionMatrix = createOrtho( 0, _stageWidth, _stageHeight, 0, -1000, 1000 );
		_context.configureBackBuffer( _stageWidth, _stageHeight, 0, false );
		
		// Set the blend mode
		_context.setBlendFactors( Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
	}
	
	public function complete() : Void {
		if ( _batch.started ) renderBatch();
		_context.present();
	}
	
	public function pushRenderTarget( target : ITextureData ) : Void {
		
		if ( _batch.started ) renderBatch();
		
		var frameBuffer : Stage3DFrameBufferData = new Stage3DFrameBufferData();
		frameBuffer.texture = cast target;
		
		_context.setRenderToTexture( frameBuffer.texture.texture, true );
		_projectionMatrix = createOrtho( 0, frameBuffer.texture.sourceImage.width, 0, frameBuffer.texture.sourceImage.height, -1000, 1000 );
		_frameBufferStack.push( frameBuffer );
		
	}
	
	public function popRenderTarget( ) : Void {
		
		var frameBuffer : Stage3DFrameBufferData = _frameBufferStack.pop();
		// Don't think we need to do anything with this framebuffer?
		
		// Render the last batch to the frameBuffer
		if ( _batch.started ) renderBatch();
		
		// Go back to the previous buffer
		if ( _frameBufferStack.length > 0 ) {
			frameBuffer = _frameBufferStack[ _frameBufferStack.length - 1 ];
			_context.setRenderToTexture( frameBuffer.texture.texture );
			_projectionMatrix = createOrtho( 0, frameBuffer.texture.sourceImage.width, 0, frameBuffer.texture.sourceImage.height, -1000, 1000 );
		}else {
			// Back to stage
			_context.setRenderToBackBuffer();
			_projectionMatrix = createOrtho( 0, _stageWidth, _stageHeight, 0, -1000, 1000 );
		}
		
	}
	
	private function renderBatch( ) : Void {
				
		if ( _batch.vertices.length > 0 ) {
			
			//trace("Rendering ", _batch.vertices);
			
			// First buffer the data so GL can use it
			var _vertexBuffer : VertexBuffer3D = _context.createVertexBuffer( Std.int(_batch.vertices.length / VERTEX_SIZE), VERTEX_SIZE );
			_vertexBuffer.uploadFromVector( _batch.vertices, 0, Std.int(_batch.vertices.length / VERTEX_SIZE) );
			
			var _indexBuffer : IndexBuffer3D = _context.createIndexBuffer( _batch.indices.length );
			_indexBuffer.uploadFromVector( _batch.indices, 0, _batch.indices.length );
			
			
			
			// Set up the shaders
			_context.setProgram( _batch.shader.program );
			
			if ( _batch.texture != null ) {
				
				_context.setVertexBufferAt( 2, _vertexBuffer, VERTEX_UV, Context3DVertexBufferFormat.FLOAT_2 );
				_context.setTextureAt( 0, _batch.texture.texture );
				
			}
			
			// Assign values to the shader
			_context.setVertexBufferAt( 0, _vertexBuffer, VERTEX_POSITION, Context3DVertexBufferFormat.FLOAT_3 );
			_context.setVertexBufferAt( 1, _vertexBuffer, VERTEX_COLOR, Context3DVertexBufferFormat.FLOAT_4 );
			_context.setProgramConstantsFromMatrix( Context3DProgramType.VERTEX, 0, _projectionMatrix, true );
			
			// Draw the things
			_context.drawTriangles( _indexBuffer );
			
			// Clean up
			_context.setVertexBufferAt( 0, null );
			_context.setVertexBufferAt( 1, null );
			
			if ( _batch.texture != null ) {
				_context.setVertexBufferAt( 2, null );
				_context.setTextureAt( 0, null );
			}
			
			_context.setProgram( null );
			_vertexBuffer.dispose();
			_indexBuffer.dispose();
			
		}
		
		_batch.reset();
	}
	
	// Stolen from Lime Matrix4 native class so flash can use it too
	public static function createOrtho (x0:Float, x1:Float,  y0:Float, y1:Float, zNear:Float, zFar:Float):Matrix3D {
		
		var sx = 1.0 / (x1 - x0);
		var sy = 1.0 / (y1 - y0);
		var sz = 1.0 / (zFar - zNear);
				
		return new Matrix3D ( flash.Vector.ofArray([
			2.0 * sx, 0, 0, 0,
			0, 2.0 * sy, 0, 0,
			0, 0, -2.0 * sz, 0,
			-(x0 + x1) * sx, -(y0 + y1) * sy, -(zNear + zFar) * sz, 1
		]));
		
	}

	
}