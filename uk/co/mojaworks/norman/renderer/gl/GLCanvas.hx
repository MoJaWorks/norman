package uk.co.mojaworks.norman.renderer.gl ;
import openfl.events.Event;
import openfl.geom.Matrix3D;
import openfl.Assets;
import openfl.display.DisplayObject;
import openfl.display.OpenGLView;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.geom.Rectangle;
import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.gl.GLProgram;
import openfl.gl.GLShader;
import openfl.gl.GLTexture;
import openfl.gl.GLUniformLocation;
import openfl.utils.Float32Array;
import openfl.utils.Int16Array;
import openfl.utils.UInt8Array;
import uk.co.mojaworks.norman.components.display.Display;
import uk.co.mojaworks.norman.core.CoreObject;
import uk.co.mojaworks.norman.core.GameObject;

/**
 * ...
 * @author Simon
 */
class GLCanvas extends CoreObject implements ICanvas
{	
	
	private static inline var VERTEX_SIZE : Int = 8;
	private static inline var VERTEX_POS : Int = 0;
	private static inline var VERTEX_COLOR : Int = 2;
	private static inline var VERTEX_TEX : Int = 6;
	
	var _vertexBuffer : GLBuffer;
	var _indexBuffer : GLBuffer;
	var _framesBuffer : GLBuffer;
	var _batches : Array<GLBatchData>;
	
	// A temporary array re-generated each frame with positions of all vertices
	var _vertices:Array<Float>;
	var _indices:Array<Int>;
	var _masks:Array<Float>;
	var _root : GameObject;
	
	// The opengl view object used to reserve our spot on the display list
	var _canvas : OpenGLView;
	
	// Relevant shaders
	var _imageShader : GLShaderWrapper;
	var _fillShader : GLShaderWrapper;
	
	var _projectionMatrix : Matrix3D;
	var _modelViewMatrix : Matrix3D;
	
	// Store the mask start index in the array
	var _frameBuffers : Array<GLFrameBufferData>;
	var _maskStack : Array<Int>;
	var _frameBufferPoints : Array<Float>;
	
	
	public function new() 
	{
		super();
	}
	
	public function init(rect:Rectangle) 
	{		
		#if html5
			if ( GL.__context == null ) {
				trace("No context");
				return;
			}
		#end
		
		_vertices = [];
		_batches = [];
		_indices = [];
		_frameBufferPoints = [];
		_frameBuffers = [];
		_maskStack = [];
		
		initShaders();
		initBuffers();
		
		_canvas = new OpenGLView();
		core.stage.addEventListener( OpenGLView.CONTEXT_LOST, onContextLost );
		core.stage.addEventListener( OpenGLView.CONTEXT_RESTORED, onContextRestored );
		_canvas.render = _onRender;
		
		GL.clearColor( 0, 0, 0, 1 );
		
		_modelViewMatrix = new Matrix3D();
		_modelViewMatrix.identity();
		
		resize( rect );
	}
	
	private function onContextLost( e : Event ) : Void {
		trace("Context lost");
		e.stopPropagation();
	}
	
	private function onContextRestored( e : Event ) : Void {
		trace("Context restored");
		initShaders();
		initBuffers();
		core.root.messenger.sendMessage( OpenGLView.CONTEXT_RESTORED );
	}
	
	private function initShaders() : Void {
		
		_imageShader = new GLShaderWrapper( 
			Assets.getText("shaders/glsl/image.vs.glsl"),
			Assets.getText("shaders/glsl/image.fs.glsl")
		);
		
		_fillShader = new GLShaderWrapper( 
			Assets.getText("shaders/glsl/fill.vs.glsl"),
			Assets.getText("shaders/glsl/fill.fs.glsl")
		);
		
	}
	
	private function initBuffers() : Void {
		_vertexBuffer = GL.createBuffer();
		_indexBuffer = GL.createBuffer();
		_framesBuffer = GL.createBuffer();
	}
	
	public function resize(rect:Rectangle):Void 
	{
		
	}
	
	/***
	 * Software render pass
	 **/
	
	public function render( root : GameObject ) {
		_root = root;
		
		// Generate all buffers here
		_vertices = [];
		_batches = [];
		_indices = [];
		
		// Collect all of the vertex data
		renderLevel( root );
		
		#if html5
			if ( GL.__context == null ) {
				trace("No context");
				return;
			}
		#end
		
		// Pass it to the graphics card
		//trace("Pushing to vertex buffer", _vertices );
		
		GL.bindBuffer( GL.ARRAY_BUFFER, _vertexBuffer );
		GL.bufferData( GL.ARRAY_BUFFER, new Float32Array( cast _vertices ), GL.DYNAMIC_DRAW );
		GL.bindBuffer( GL.ARRAY_BUFFER, null );
		
		//trace("Pushing to index buffer", _indices );
		
		GL.bindBuffer( GL.ELEMENT_ARRAY_BUFFER, _indexBuffer );
		GL.bufferData( GL.ELEMENT_ARRAY_BUFFER, new Int16Array( cast _indices ), GL.DYNAMIC_DRAW );
		GL.bindBuffer( GL.ELEMENT_ARRAY_BUFFER, null );
		
		GL.bindBuffer( GL.ARRAY_BUFFER, _framesBuffer );
		GL.bufferData( GL.ARRAY_BUFFER, new Float32Array( cast _frameBufferPoints ), GL.DYNAMIC_DRAW );
		GL.bindBuffer( GL.ARRAY_BUFFER, null );
			
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
		var batch : GLBatchData = (_batches.length > 0) ? _batches[ _batches.length - 1 ] : null;
		var offset : Int = Math.floor(_vertices.length / VERTEX_SIZE);
		var mask : Int = getCurrentMask();
		
		if ( batch != null && batch.shader == _fillShader && batch.mask == mask ) {
			batch.length += 6;	
		}else {
			batch = new GLBatchData();
			batch.start = _indices.length;
			batch.length = 6;
			batch.shader = _fillShader;
			batch.mask = mask;
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
		drawSubImage( texture, new Rectangle(0, 0, 1, 1), transform, alpha, red, green, blue );
	}
	
	public function drawSubImage( texture : TextureData, sourceRect : Rectangle, transform:Matrix, alpha:Float, red : Float, green : Float, blue : Float ):Void 
	{
		var batch : GLBatchData = (_batches.length > 0) ? _batches[ _batches.length - 1 ] : null;
		var offset : Int = Math.floor(_vertices.length / VERTEX_SIZE);
		var width : Float = sourceRect.width * texture.sourceBitmap.width;
		var height : Float = sourceRect.height * texture.sourceBitmap.height;
		
		if ( batch != null && batch.shader == _imageShader && batch.texture == texture.texture && batch.mask == getCurrentMask() ) {
			batch.length += 6;	
		}else {
			batch = new GLBatchData();
			batch.start = _indices.length;
			batch.length = 6;
			batch.shader = _imageShader;
			batch.texture = texture.texture;
			batch.mask = getCurrentMask();
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
	
	
		
	public function pushMask(rect:Rectangle, transform:Matrix):Void 
	{
		var fbData : GLFrameBufferData = new GLFrameBufferData();
		fbData.bounds = rect;
		_frameBuffers.push( fbData );
		_maskStack.push( _frameBuffers.length );
		
		fbData.index = _frameBufferPoints.length;
		fbData.frameBuffer = GL.createFramebuffer();
		fbData.texture = GL.createTexture();
		
		GL.bindTexture( GL.TEXTURE_2D, fbData.texture );
		GL.texImage2D( GL.TEXTURE_2D, 0, GL.RGBA, Std.int(rect.width), Std.int(rect.height), 0, GL.RGBA, GL.UNSIGNED_BYTE, null );
		GL.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST );
		GL.texParameteri( GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST );
		GL.bindTexture( GL.TEXTURE_2D, null );
		
		var pts : Array<Point> = [
			transform.transformPoint( new Point(rect.right, rect.bottom) ),
			transform.transformPoint( new Point(rect.left, rect.bottom) ),
			transform.transformPoint( new Point(rect.right, rect.top) ),
			transform.transformPoint( new Point(rect.left, rect.top) )
		];
		
		var uvs : Array<Float> = [
			1, 1,
			0, 1,
			1, 0,
			0, 0
		];
		
		var i : Int = 0;
		
		for ( pt in pts ) {
			_frameBufferPoints.push( pt.x );
			_frameBufferPoints.push( pt.y );
			_frameBufferPoints.push( 1 );
			_frameBufferPoints.push( 1 );
			_frameBufferPoints.push( 1 );
			_frameBufferPoints.push( 1 );
			_frameBufferPoints.push( uvs[i*2] );
			_frameBufferPoints.push( uvs[i * 2] + 1 );
			i++;
		}		
		
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
	
	private function _onRender( rect : Rectangle ) : Void {
		
		#if html5
			if ( GL.__context == null ) {
				trace("No context");
				return;
			}
		#end
		
		GL.viewport( Std.int( rect.x ), Std.int( rect.y ), Std.int( rect.width ), Std.int( rect.height ) );
		
		GL.clearColor( 0, 0, 0, 1 );
		GL.clear( GL.COLOR_BUFFER_BIT );
		
		_projectionMatrix = Matrix3D.createOrtho( 0, rect.width, rect.height, 0, 1000, -1000 );
		
		var vertexAttrib : Int = -1;
		var colorAttrib : Int = -1;
		var texAttrib : Int = -1;
		var uMVMatrix : GLUniformLocation;
		var uProjectionMatrix : GLUniformLocation;
		var uImage : GLUniformLocation;
		
		var prev_blended : Bool = GL.getParameter( GL.BLEND );
		var prev_blend_src : Int = GL.getParameter( GL.BLEND_SRC_ALPHA );
		var prev_blend_dst : Int = GL.getParameter( GL.BLEND_DST_ALPHA );
		
		GL.enable( GL.BLEND );
		GL.blendFunc(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA);
		//trace( GL.isEnabled( GL.CULL_FACE ) );
		
		//trace("Begin draw", _batches );
		
		_maskStack = [];
			
		for ( batch in _batches ) {
				
			//trace("Drawing batch", batch.start, batch.length );
			
			if ( batch.mask != getCurrentMask() ) {
				
				// Moving up the stack, render the current texture
				if ( batch.mask < getCurrentMask() ) {
					
				}
			}
			
			GL.useProgram( batch.shader.program );
			
			vertexAttrib = batch.shader.getAttrib( "aVertexPosition" );
			colorAttrib = batch.shader.getAttrib( "aVertexColor" );
			uMVMatrix = batch.shader.getUniform( "uModelViewMatrix" );
			uProjectionMatrix = batch.shader.getUniform( "uProjectionMatrix" );
					
			GL.enableVertexAttribArray( vertexAttrib );
			GL.enableVertexAttribArray( colorAttrib );
			
			GL.bindBuffer( GL.ARRAY_BUFFER, _vertexBuffer );
			GL.vertexAttribPointer( vertexAttrib, 2, GL.FLOAT, false, VERTEX_SIZE * 4, VERTEX_POS * 4 );
			GL.vertexAttribPointer( colorAttrib, 4, GL.FLOAT, false, VERTEX_SIZE * 4, VERTEX_COLOR * 4 );
			
			
			if ( batch.texture != null ) {
				texAttrib = batch.shader.getAttrib("aTexCoord");
				uImage = batch.shader.getUniform( "uImage0" );
				
				GL.enableVertexAttribArray( texAttrib );
				GL.vertexAttribPointer( texAttrib, 2, GL.FLOAT, false, VERTEX_SIZE * 4, VERTEX_TEX * 4 );
				
				GL.activeTexture(GL.TEXTURE0);
				GL.enable( GL.TEXTURE_2D );
				GL.bindTexture( GL.TEXTURE_2D, batch.texture );
				GL.uniform1i( uImage, 0 );
			}
			
			GL.uniformMatrix3D( uProjectionMatrix, false, _projectionMatrix );
			GL.uniformMatrix3D( uMVMatrix, false, _modelViewMatrix );
			
			GL.bindBuffer( GL.ELEMENT_ARRAY_BUFFER, _indexBuffer );
			GL.drawElements( GL.TRIANGLES, batch.length, GL.UNSIGNED_SHORT, batch.start * 2 );
			
			GL.disableVertexAttribArray( colorAttrib );
			GL.disableVertexAttribArray( vertexAttrib );
		
			if ( batch.texture != null ) {
				GL.disableVertexAttribArray( texAttrib );
				GL.bindTexture( GL.TEXTURE_2D, null );
				GL.disable( GL.TEXTURE_2D );
			}
			
			GL.bindBuffer( GL.ARRAY_BUFFER, null );
			GL.bindBuffer( GL.ELEMENT_ARRAY_BUFFER, null );
			
		}
		
		GL.useProgram( null );
		GL.disable(GL.STENCIL_TEST);
		
		if ( !prev_blended ) {
			GL.disable( GL.BLEND );
		}else {
			GL.blendFunc( prev_blend_src, prev_blend_dst );
		}
		//GL.disable( GL.BLEND );
		//trace( "Error code end", GL.getError() );
	}
	
	
		
	/* INTERFACE uk.co.mojaworks.norman.renderer.ICanvas */
	
	public function getDisplayObject():DisplayObject 
	{
		return _canvas;
	}
	
	
	
	
	
	
	
	
	
}