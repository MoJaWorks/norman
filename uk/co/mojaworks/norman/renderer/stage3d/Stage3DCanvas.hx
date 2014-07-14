package uk.co.mojaworks.norman.renderer.stage3d ;
import flash.display.Stage3D;
import flash.display3D.Context3D;
import flash.display3D.Context3DBlendFactor;
import flash.display3D.Context3DProfile;
import flash.display3D.Context3DProgramType;
import flash.display3D.Context3DRenderMode;
import flash.display3D.Context3DVertexBufferFormat;
import flash.display3D.IndexBuffer3D;
import flash.display3D.VertexBuffer3D;
import openfl.Assets;
import openfl.display.DisplayObject;
import openfl.events.Event;
import openfl.geom.Matrix;
import openfl.geom.Matrix3D;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Vector;
import uk.co.mojaworks.norman.components.display.Display;
import uk.co.mojaworks.norman.core.CoreObject;
import uk.co.mojaworks.norman.core.GameObject;

/**
 * ...
 * @author Simon
 */
class Stage3DCanvas extends CoreObject implements ICanvas
{
	
	private static inline var VERTEX_SIZE : Int = 8;
	private static inline var VERTEX_POS : Int = 0;
	private static inline var VERTEX_COLOR : Int = 2;
	private static inline var VERTEX_TEX : Int = 6;
	
	var _vertexBuffer : VertexBuffer3D;
	var _indexBuffer : IndexBuffer3D;
	var _batches : Array<Stage3DBatchData>;
	
	// A temporary array re-generated each frame with positions of all vertices
	var _vertices:Vector<Float>;
	var _indices:Vector<UInt>;
	var _root : GameObject;
	
	// The opengl view object used to reserve our spot on the display list
	var _context : Context3D;
	var _rect : Rectangle;
	
	// Relevant shaders
	var _imageShader : Stage3DShaderWrapper;
	var _fillShader : Stage3DShaderWrapper;
	
	var _projectionMatrix : Matrix3D;
	var _modelViewMatrix : Matrix3D;
		
	
	public function new() 
	{
		super();
	}
	
	public function init(rect:Rectangle) 
	{		
		_vertices = [];
		_batches = [];
		_indices = [];
		
		_rect = rect;
		
		core.stage.stage3Ds[0].addEventListener( Event.CONTEXT3D_CREATE, onContextCreated );
		core.stage.stage3Ds[0].requestContext3D( );
				
		//_modelViewMatrix = new Matrix3D();
		//_modelViewMatrix.identity();
		_modelViewMatrix = createOrtho( 0, Std.int(_rect.width), Std.int(_rect.height), 0, 1000, -1000 );
		
		resize( rect );
	}
	
	private function onContextCreated( e : Event ) : Void {
		var target : Stage3D = cast e.target;
		_context = target.context3D;
		
		_context.configureBackBuffer( Std.int(_rect.width), Std.int(_rect.height), 0, false );
		_context.setBlendFactors( Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
		
		core.root.messenger.sendMessage( Event.CONTEXT3D_CREATE );
		
		initShaders();
	}
	
	private function initShaders() : Void {
		
		_imageShader = new Stage3DShaderWrapper(
			_context,
			Assets.getText("shaders/agal/image.vs.agal"),
			Assets.getText("shaders/agal/image.fs.agal")
		);
		
		_fillShader = new Stage3DShaderWrapper( 
			_context,
			Assets.getText("shaders/agal/fill.vs.agal"),
			Assets.getText("shaders/agal/fill.fs.agal")
		);
		
	}
		
	public function resize(rect:Rectangle):Void 
	{
		trace("Resize, ", rect );
		_rect = rect;
		if ( _context != null ) _context.configureBackBuffer( Std.int(_rect.width), Std.int(_rect.height), 0, false );
		_modelViewMatrix = createOrtho( 0, Std.int(_rect.width), Std.int(_rect.height), 0, 1000, -1000 );
	}
	
	/***
	 * Software render pass
	 **/
	
	public function render( root : GameObject ) {
		_root = root;
		
		// Not ready yet - come back later
		if ( _context == null ) return;
		
		// Generate all buffers here
		_vertices = [];
		_batches = [];
		_indices = [];
		
		// Collect all of the vertex data
		renderLevel( root );
		
		// Pass it to the graphics card
		trace("Pushing to vertex buffer", _vertices );

		if ( _vertexBuffer != null ) _vertexBuffer.dispose();
		_vertexBuffer = _context.createVertexBuffer( Std.int(_vertices.length / VERTEX_SIZE), VERTEX_SIZE );
		_vertexBuffer.uploadFromVector( _vertices, 0, Std.int(_vertices.length / VERTEX_SIZE) );
		
		//trace("Pushing to index buffer", _indices );

		if ( _indexBuffer != null ) _indexBuffer.dispose();
		_indexBuffer = _context.createIndexBuffer( _indices.length );
		_indexBuffer.uploadFromVector( _indices, 0, _indices.length );
		
		_context.setVertexBufferAt( 0, _vertexBuffer, VERTEX_POS, Context3DVertexBufferFormat.FLOAT_2 );
		_context.setVertexBufferAt( 1, _vertexBuffer, VERTEX_COLOR, Context3DVertexBufferFormat.FLOAT_4 );
		_context.setProgramConstantsFromMatrix( Context3DProgramType.VERTEX, 0, _modelViewMatrix, true );
		
		_context.clear( 0, 0, 0, 1 );
		
		
		for ( batch in _batches ) {
			
			trace("Drawing batch", batch.start, batch.length );
			
			if ( batch.texture != null ) {
				_context.setTextureAt( 0, batch.texture );
				_context.setVertexBufferAt( 2, _vertexBuffer, VERTEX_TEX, Context3DVertexBufferFormat.FLOAT_2 );
			}
			
			_context.setProgram( batch.shader.program );
			_context.drawTriangles( _indexBuffer, batch.start, batch.length );
			
			if ( batch.texture != null ) {
				_context.setTextureAt( 0, null );
				_context.setVertexBufferAt( 2, null );
			}
		}
		
		_context.present();
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
		var batch : Stage3DBatchData = (_batches.length > 0) ? _batches[ _batches.length - 1 ] : null;
		var offset : Int = Math.floor(_vertices.length / VERTEX_SIZE);
		
		if ( batch != null && batch.shader == _fillShader ) {
			batch.length += 2;	
		}else {
			batch = new Stage3DBatchData();
			batch.start = _indices.length;
			batch.length = 2;
			batch.shader = _fillShader;
			batch.texture = null;
			_batches.push( batch );
		}
		
		var arr : Array<Point> = [
			transform.transformPoint( new Point( width, height ) ),
			transform.transformPoint( new Point( 0, height ) ),
			transform.transformPoint( new Point( width, 0 ) ),
			transform.transformPoint( new Point( 0, 0 ) )
		];
		
		for ( point in arr ) {
			_vertices.push( point.x );
			_vertices.push( point.y );
			_vertices.push( red / 255 );
			_vertices.push( green / 255 );
			_vertices.push( blue / 255 );
			_vertices.push( alpha );
			_vertices.push( 0 );
			_vertices.push( 0 );
		}
		
		// Build indexes
		_indices.push(0 + offset);
		_indices.push(1 + offset);
		_indices.push(2 + offset);
		_indices.push(1 + offset);
		_indices.push(3 + offset);
		_indices.push(2 + offset);
		
	}
	
	public function drawImage( texture : TextureData, transform:Matrix, alpha:Float, red : Float, green : Float, blue : Float ):Void 
	{
		// Just call drawSubimage with whole image as bounds
		drawSubImage( texture, new Rectangle(0, 0, texture.paddingMultiplierX, texture.paddingMultiplierY), transform, alpha, red, green, blue );
	}
	
	public function drawSubImage( texture : TextureData, sourceRect : Rectangle, transform:Matrix, alpha:Float, red : Float, green : Float, blue : Float ):Void 
	{
		var batch : Stage3DBatchData = (_batches.length > 0) ? _batches[ _batches.length - 1 ] : null;
		var offset : Int = Math.floor(_vertices.length / VERTEX_SIZE);
		var width : Float = (sourceRect.width * texture.sourceBitmap.width) / texture.paddingMultiplierX;
		var height : Float = (sourceRect.height * texture.sourceBitmap.height) / texture.paddingMultiplierY;
		
		if ( batch != null && batch.shader == _imageShader && batch.texture == texture.texture ) {
			batch.length += 2;	
		}else {
			batch = new Stage3DBatchData();
			batch.start = _indices.length;
			batch.length = 2;
			batch.shader = _imageShader;
			batch.texture = texture.texture;
			_batches.push( batch );
		}
		
		var pts_arr : Array<Point> = [
			transform.transformPoint( new Point( width, height ) ),
			transform.transformPoint( new Point( 0, height ) ),
			transform.transformPoint( new Point( width, 0 ) ),
			transform.transformPoint( new Point( 0, 0 ) )
		];
		
		var uv_arr : Array<Float> = [
			sourceRect.right, sourceRect.bottom,
			sourceRect.left, sourceRect.bottom,
			sourceRect.right, sourceRect.top,
			sourceRect.left, sourceRect.top
		];
		
		var i : Int = 0;
		for ( point in pts_arr ) {
			_vertices.push( point.x );
			_vertices.push( point.y );
			_vertices.push( red );
			_vertices.push( green );
			_vertices.push( blue );
			_vertices.push( alpha );
			_vertices.push( uv_arr[(i*2)] );
			_vertices.push( uv_arr[(i*2)+1] );
			i++;
		}
		
		// Build indexes
		_indices.push(0 + offset);
		_indices.push(1 + offset);
		_indices.push(2 + offset);
		_indices.push(1 + offset);
		_indices.push(3 + offset);
		_indices.push(2 + offset);
	}
	
	/**
	 * Hardware rendering
	 * @param	rect
	 */
	
	 
	// Stolen from OpenFL Matrix3D native class
	public static function createOrtho (x0:Float, x1:Float,  y0:Float, y1:Float, zNear:Float, zFar:Float):Matrix3D {
		
		var sx = 1.0 / (x1 - x0);
		var sy = 1.0 / (y1 - y0);
		var sz = 1.0 / (zFar - zNear);
		
		return new Matrix3D ([
			2.0 * sx, 0, 0, 0,
			0, 2.0 * sy, 0, 0,
			0, 0, -2.0 * sz, 0,
			-(x0 + x1) * sx, -(y0 + y1) * sy, -(zNear + zFar) * sz, 1
		]);
		
	}
	 
	
	
		
	/* INTERFACE uk.co.mojaworks.norman.renderer.ICanvas */
	
	public function getDisplayObject():DisplayObject 
	{
		return null;
	}
	
	public function getContext():Context3D 
	{
		return _context;
	}
	
}