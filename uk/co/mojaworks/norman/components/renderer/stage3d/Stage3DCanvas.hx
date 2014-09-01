package uk.co.mojaworks.norman.components.renderer.stage3d ;
import flash.display.Stage3D;
import flash.display3D.Context3D;
import flash.display3D.Context3DBlendFactor;
import flash.display3D.Context3DProgramType;
import flash.display3D.Context3DTextureFormat;
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
import uk.co.mojaworks.norman.core.GameObject;
import uk.co.mojaworks.norman.core.RootObject;
import uk.co.mojaworks.norman.utils.Color;
import uk.co.mojaworks.norman.utils.MathUtils;

using openfl.Vector;

/**
 * ...
 * @author Simon
 */
class Stage3DCanvas extends RootObject implements ICanvas
{
	
	private static inline var VERTEX_SIZE : Int = 8;
	private static inline var VERTEX_POS : Int = 0;
	private static inline var VERTEX_COLOR : Int = 2;
	private static inline var VERTEX_TEX : Int = 6;
	
	var _vertexBuffer : VertexBuffer3D;
	var _indexBuffer : IndexBuffer3D;
	var _maskVertexBuffer : VertexBuffer3D;
	var _maskIndexBuffer : IndexBuffer3D;
	var _batches : Array<Stage3DBatchData>;
	
	// A temporary array re-generated each frame with positions of all vertices
	var _vertices:Vector<Float>;
	var _indices:Vector<UInt>;
	var _maskVertices:Vector<Float>;
	var _maskIndices:Vector<UInt>;
	var _root : GameObject;
	
	// The opengl view object used to reserve our spot on the display list
	var _context : Context3D;
	var _rect : Rectangle;
	
	// Relevant shaders
	var _imageShader : Stage3DShaderWrapper;
	var _fillShader : Stage3DShaderWrapper;
	
	var _mvpMatrix : Matrix3D;
	
	// masks
	var _maskStack : Array<Int>;
	var _masks : Array<Stage3DFrameBufferData>;
		
	
	public function new() 
	{
		super();
	}
	
	public function init(rect:Rectangle) 
	{		
	
		_rect = rect;
		
		root.stage.stage3Ds[0].addEventListener( Event.CONTEXT3D_CREATE, onContextCreated );
		root.stage.stage3Ds[0].requestContext3D( );
				
		_mvpMatrix = createOrtho( 0, Std.int(_rect.width), Std.int(_rect.height), 0, 1000, -1000 );
		
		resize( rect );
	}
	
	private function onContextCreated( e : Event ) : Void {
		var target : Stage3D = cast e.target;
		_context = target.context3D;
		_context.enableErrorChecking = true;
		
		_context.configureBackBuffer( Std.int(_rect.width), Std.int(_rect.height), 0, false );
		_context.setBlendFactors( Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
		
		root.messenger.sendMessage( Event.CONTEXT3D_CREATE );
		
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
		_rect = rect;
		if ( _context != null ) _context.configureBackBuffer( Std.int(_rect.width), Std.int(_rect.height), 0, false );
		_mvpMatrix = createOrtho( 0, Std.int(_rect.width), Std.int(_rect.height), 0, 1000, -1000 );
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
		_masks = [];
		_maskStack = [];
		_maskVertices = [];
		_maskIndices = [];
		
		// Collect all of the vertex data
		renderLevel( root );
		
		// Pass it to the graphics card
		if ( _vertexBuffer != null ) _vertexBuffer.dispose();
		_vertexBuffer = _context.createVertexBuffer( Std.int(_vertices.length / VERTEX_SIZE), VERTEX_SIZE );
		_vertexBuffer.uploadFromVector( _vertices, 0, Std.int(_vertices.length / VERTEX_SIZE) );

		if ( _indexBuffer != null ) _indexBuffer.dispose();
		_indexBuffer = _context.createIndexBuffer( _indices.length );
		_indexBuffer.uploadFromVector( _indices, 0, _indices.length );
		
		if ( _maskVertexBuffer != null ) _maskVertexBuffer.dispose();
		if ( _maskIndexBuffer != null ) _maskIndexBuffer.dispose();
		if ( _maskVertices.length > 0 ) {
			_maskVertexBuffer = _context.createVertexBuffer( Std.int(_maskVertices.length / VERTEX_SIZE), VERTEX_SIZE );
			_maskVertexBuffer.uploadFromVector( _maskVertices, 0, Std.int(_maskVertices.length / VERTEX_SIZE) );
			_maskIndexBuffer = _context.createIndexBuffer( _maskIndices.length );
			_maskIndexBuffer.uploadFromVector( _maskIndices, 0, _maskIndices.length );
		}
		
		/**
		 * render
		 */
			
		_context.clear( 0, 0, 0, 1 );
		
		var currentMask : Stage3DFrameBufferData = null;
		var maskTextureUsed : Int = -1;
		
		for ( batch in _batches ) {
			
			
			if ( batch.mask != getCurrentMask() ) {

				// Moving up the stack, render the current texture
				while ( batch.mask < getCurrentMask() ) {
					var current : Int = getCurrentMask();
					_maskStack.pop();
					renderFrameBuffer( _masks[current] );
				}
				
				if ( batch.mask > -1 ) {
					currentMask = _masks[batch.mask];
					_maskStack.push( batch.mask );
					maskTextureUsed = setRenderBuffer( currentMask );
				}else {
					currentMask = null;
					maskTextureUsed = -1;
				}
				
			}
			
			_context.setProgram( batch.shader.program );
			_context.setVertexBufferAt( 0, _vertexBuffer, VERTEX_POS, Context3DVertexBufferFormat.FLOAT_2 );
			_context.setVertexBufferAt( 1, _vertexBuffer, VERTEX_COLOR, Context3DVertexBufferFormat.FLOAT_4 );
			_context.setProgramConstantsFromMatrix( Context3DProgramType.VERTEX, 0, _mvpMatrix, true );
			
			if ( batch.texture != null ) {
				_context.setTextureAt( 0, batch.texture );
				_context.setVertexBufferAt( 2, _vertexBuffer, VERTEX_TEX, Context3DVertexBufferFormat.FLOAT_2 );
			}
			
			_context.drawTriangles( _indexBuffer, batch.start, batch.length );
			
			if ( batch.texture != null ) {
				_context.setTextureAt( 0, null );
				_context.setVertexBufferAt( 2, null );
			}
			
			if ( batch.mask > -1 ) {
				currentMask.lastTextureUsed = maskTextureUsed;
			}
			
			_context.setVertexBufferAt( 0, null );
			_context.setVertexBufferAt( 1, null );
		}
		
		while ( _maskStack.length > 0 ) {
			renderFrameBuffer( _masks[_maskStack.pop()] );
		}
		
		_context.present();
		
		
		for ( mask in _masks ) {
			mask.bounds = null;
			mask.scissor = null;
			for ( texture in mask.textures ) {
				texture.dispose();
			}
			mask.textures = null;
		}
	}
	
	
	private function setRenderBuffer( mask : Stage3DFrameBufferData ) : Int {
		
		var textureUsed : Int = -1;
		
		if ( mask.lastTextureUsed == 0 ) {
			_context.setRenderToTexture( mask.textures[1] );
			textureUsed = 1;
		}else {
			_context.setRenderToTexture( mask.textures[0] );
			textureUsed = 0;
		}
		_context.clear( 0, 0, 0, 0 );
		_context.setScissorRectangle( mask.scissor );
		_mvpMatrix = createOrtho( 0, mask.bounds.width, mask.bounds.height, 0, 1000, -1000 );
		
		return textureUsed;
		
	}
	
	
	private function renderFrameBuffer( currentMask : Stage3DFrameBufferData ) : Void {
		
		var nextMask : Stage3DFrameBufferData = null;
		var textureUsed : Int = -1;
		
		if ( _maskStack.length > 0 ) {
			nextMask = _masks[getCurrentMask()];
			textureUsed = setRenderBuffer( nextMask );
		}else {
			_mvpMatrix = createOrtho( 0, _rect.width, _rect.height, 0, 1000, -1000 );
			_context.setScissorRectangle( null );
			_context.setRenderToBackBuffer();
		}		
		
		_context.setProgram( _imageShader.program );
		_context.setProgramConstantsFromMatrix( Context3DProgramType.VERTEX, 0, _mvpMatrix, true );
		
		if ( nextMask != null && nextMask.lastTextureUsed > -1 ) {
			
			// Render the last used texture to the current one
			// This is purely because Stage3D has a strange requirement to clear the texture before use.
			_context.setTextureAt( 0, nextMask.textures[ nextMask.lastTextureUsed ] );
			
			var verts : Vector<Float> = [
				nextMask.bounds.width, nextMask.bounds.height, 1, 1, 1, 1, 1, 1,
				0, nextMask.bounds.height, 1, 1, 1, 1, 0, 1,
				nextMask.bounds.width, 0, 1, 1, 1, 1, 1, 0,
				0, 0, 1, 1, 1, 1, 0, 0,
			];
			var tempVertBuffer : VertexBuffer3D = _context.createVertexBuffer( 4, VERTEX_SIZE );
			tempVertBuffer.uploadFromVector( verts, 0, 4 );
			
			_context.setVertexBufferAt( 0, tempVertBuffer, VERTEX_POS, Context3DVertexBufferFormat.FLOAT_2 );
			_context.setVertexBufferAt( 1, tempVertBuffer, VERTEX_COLOR, Context3DVertexBufferFormat.FLOAT_4 );
			_context.setVertexBufferAt( 2, tempVertBuffer, VERTEX_TEX, Context3DVertexBufferFormat.FLOAT_2 );
			
			var indices : Vector<UInt> = Vector.ofArray( [0, 1, 2, 1, 3, 2] );
			var tempIndexBuffer : IndexBuffer3D = _context.createIndexBuffer( 6 );
			tempIndexBuffer.uploadFromVector( indices, 0, 6 );
			
			_context.drawTriangles( tempIndexBuffer );
			
			tempIndexBuffer.dispose();
			tempVertBuffer.dispose();
			
			nextMask.lastTextureUsed = textureUsed;
		}
		
		_context.setVertexBufferAt( 0, _maskVertexBuffer, VERTEX_POS, Context3DVertexBufferFormat.FLOAT_2 );
		_context.setVertexBufferAt( 1, _maskVertexBuffer, VERTEX_COLOR, Context3DVertexBufferFormat.FLOAT_4 );
		_context.setVertexBufferAt( 2, _maskVertexBuffer, VERTEX_TEX, Context3DVertexBufferFormat.FLOAT_2 );
		_context.setTextureAt( 0, currentMask.textures[ currentMask.lastTextureUsed ] );
		
		_context.drawTriangles( _maskIndexBuffer, currentMask.index, 2 );
		
		_context.setTextureAt( 0, null );
		_context.setVertexBufferAt( 2, null );
		
	}
	
	
	
	private function renderLevel( root : GameObject ) : Void {
		var display : Display = root.get(Display);
		if ( display != null && display.visible && display.getFinalAlpha() > 0 ) {
			
			display.preRender( this );
			display.render( this );
			
			for ( child in root.children ) {
				renderLevel( child );
			}
			
			display.postRender( this );
		}
	}
	
	public function fillRect(red:Float, green:Float, blue:Float, alpha:Float, width:Float, height:Float, transform:Matrix):Void 
	{
		var batch : Stage3DBatchData = (_batches.length > 0) ? _batches[ _batches.length - 1 ] : null;
		var offset : Int = Math.floor(_vertices.length / VERTEX_SIZE);
		var mask : Int = getCurrentMask();
		
		if ( batch != null && batch.shader == _fillShader && batch.mask == mask ) {
			batch.length += 2;	
		}else {
			batch = new Stage3DBatchData();
			batch.start = _indices.length;
			batch.length = 2;
			batch.shader = _fillShader;
			batch.texture = null;
			batch.mask = mask;
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
			_vertices.push( red * Color.RATIO_255 );
			_vertices.push( green * Color.RATIO_255 );
			_vertices.push( blue * Color.RATIO_255 );
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
	
	public function drawImage( texture : TextureData, transform:Matrix, alpha:Float = 1, red : Float = 255, green : Float = 255, blue : Float = 255 ):Void 
	{
		// Just call drawSubimage with whole image as bounds
		drawSubImage( texture, new Rectangle(0, 0, texture.paddingMultiplierX, texture.paddingMultiplierY), transform, alpha, red, green, blue );
	}
	
	public function drawSubImage( texture : TextureData, sourceRect : Rectangle, transform:Matrix, alpha:Float = 1, red : Float = 255, green : Float = 255, blue : Float = 255 ):Void 
	{
		var batch : Stage3DBatchData = (_batches.length > 0) ? _batches[ _batches.length - 1 ] : null;
		var offset : Int = Math.floor(_vertices.length / VERTEX_SIZE);
		var width : Float = (sourceRect.width * texture.sourceBitmap.width) / texture.paddingMultiplierX;
		var height : Float = (sourceRect.height * texture.sourceBitmap.height) / texture.paddingMultiplierY;
		var mask : Int = getCurrentMask();
		
		if ( batch != null && batch.shader == _imageShader && batch.texture == texture.texture && batch.mask == mask ) {
			batch.length += 2;	
		}else {
			batch = new Stage3DBatchData();
			batch.start = _indices.length;
			batch.length = 2;
			batch.shader = _imageShader;
			batch.mask = mask;
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
			_vertices.push( red * Color.RATIO_255 );
			_vertices.push( green * Color.RATIO_255 );
			_vertices.push( blue * Color.RATIO_255 );
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
	
	public function pushMask(rect:Rectangle, transform:Matrix):Void 
	{
		_maskStack.push( _masks.length );
		
		var fbData : Stage3DFrameBufferData = new Stage3DFrameBufferData();
		fbData.scissor = new Rectangle( 0, 0, rect.width, rect.height );
		fbData.bounds = rect.clone();
		
		fbData.bounds.width = MathUtils.roundToNextPow2(rect.width);
		fbData.bounds.height = MathUtils.roundToNextPow2(rect.height);
		
		_masks.push( fbData );
		
		fbData.index = _maskIndices.length;
		
		// Create two textures and flip one to the other when drawing
		fbData.textures = [];
		fbData.textures.push( _context.createTexture( Std.int(fbData.bounds.width), Std.int(fbData.bounds.height), Context3DTextureFormat.BGRA, true ) );
		fbData.textures.push( _context.createTexture( Std.int(fbData.bounds.width), Std.int(fbData.bounds.height), Context3DTextureFormat.BGRA, true ) );
		
		var pts : Array<Point> = [
			transform.transformPoint( new Point(fbData.bounds.right, fbData.bounds.bottom) ),
			transform.transformPoint( new Point(fbData.bounds.left, fbData.bounds.bottom) ),
			transform.transformPoint( new Point(fbData.bounds.right, fbData.bounds.top) ),
			transform.transformPoint( new Point(fbData.bounds.left, fbData.bounds.top) )
		];
		
		var uvs : Array<Float> = [
			1, 1,
			0, 1,
			1, 0,
			0, 0
		];
		
		var i : Int = 0;
		
		var offset : Int = Std.int(_maskVertices.length / VERTEX_SIZE);
		
		for ( pt in pts ) {
			_maskVertices.push( pt.x );
			_maskVertices.push( pt.y );
			_maskVertices.push( 1 );
			_maskVertices.push( 1 );
			_maskVertices.push( 1 );
			_maskVertices.push( 1 );
			_maskVertices.push( uvs[i * 2] );
			_maskVertices.push( uvs[(i * 2) + 1] );
			i++;
		}	
		
		_maskIndices.push( offset + 0 );
		_maskIndices.push( offset + 1 );
		_maskIndices.push( offset + 2 );
		_maskIndices.push( offset + 1 );
		_maskIndices.push( offset + 3 );
		_maskIndices.push( offset + 2 );
		
	}
	
	public function popMask():Void 
	{
		if ( _maskStack.length > 0 ) _maskStack.pop();
	}
	
	public inline function getCurrentMask() : Int {
		if ( _maskStack.length == 0 ) {
			return -1;
		}else {
			return _maskStack[ _maskStack.length - 1 ];
		}
	}
	
	/**
	 * Hardware rendering
	 * @param	rect
	 */
	
	 
	// Stolen from OpenFL Matrix3D native class so flash can use it too
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