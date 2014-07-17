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
	var _stencilBuffer : GLBuffer;
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
	var _maskStack : Array<Int>;
	var _renderTexturesStack : Array<GLFrameBufferData>;
	
	
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
		_masks = [];
		
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
		_stencilBuffer = GL.createBuffer();
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
		_maskStack = [];
		_masks = [];
		
		// Collect all of the vertex data
		renderLevel( root );
		
		#if html5
			if ( GL.__context == null ) {
				trace("No context");
				return;
			}
		#end
		
		// Pass it to the graphics card
		trace("Pushing to vertex buffer", _vertices );
		
		GL.bindBuffer( GL.ARRAY_BUFFER, _vertexBuffer );
		GL.bufferData( GL.ARRAY_BUFFER, new Float32Array( cast _vertices ), GL.STATIC_DRAW );
		GL.bindBuffer( GL.ARRAY_BUFFER, null );
		
		trace("Pushing to index buffer", _indices );
		
		GL.bindBuffer( GL.ELEMENT_ARRAY_BUFFER, _indexBuffer );
		GL.bufferData( GL.ELEMENT_ARRAY_BUFFER, new Int16Array( cast _indices ), GL.STATIC_DRAW );
		GL.bindBuffer( GL.ELEMENT_ARRAY_BUFFER, null );
		
		trace("Pushing to stencil buffer", _masks );
		
		GL.bindBuffer( GL.ARRAY_BUFFER, _stencilBuffer );
		GL.bufferData( GL.ARRAY_BUFFER, new Float32Array( cast _masks ), GL.STATIC_DRAW );
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
	
	public function pushMask( rect : Rectangle, transform : Matrix ) : Void {
		
		_maskStack.push( _masks.length );
		
		var arr : Array<Point> = [
			transform.transformPoint( new Point( rect.x + rect.width, rect.y + rect.height ) ),
			transform.transformPoint( new Point( rect.x, rect.y + rect.height ) ),
			transform.transformPoint( new Point( rect.x + rect.width, rect.y ) ),
			transform.transformPoint( new Point( rect.x, rect.y ) )
		];
		
		if ( getCurrentMask() > -1 ) {
			for ( point in arr ) {
				_masks.push( point.x );
				_masks.push( point.y );
				_masks.push( 1 );
				_masks.push( 1 );
				_masks.push( 1 );
				_masks.push( 1 );
			}
		}
		
	}
	
	public function popMask() : Void {
		_maskStack.pop();
	}
	
	public inline function getCurrentMask() : Int {
		if ( _maskStack.length > 0 ) {
			return _maskStack[ _maskStack.length - 1 ];
		}else{
			return -1;
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
		
		trace("Begin draw", _batches );
			
		for ( batch in _batches ) {
			
			if ( batch.mask > -1 ) {
				if ( batch.mask != getCurrentMask() ) {
					
					GL.useProgram( _fillShader.program );
					
					vertexAttrib = _fillShader.getAttrib( "aVertexPosition" );
					colorAttrib = _fillShader.getAttrib( "aVertexColor" );
					uMVMatrix = _fillShader.getUniform( "uModelViewMatrix" );
					uProjectionMatrix = _fillShader.getUniform( "uProjectionMatrix" );
					
					GL.enableVertexAttribArray( vertexAttrib );
					GL.enableVertexAttribArray( colorAttrib );
					
					GL.uniformMatrix3D( uProjectionMatrix, false, _projectionMatrix );
					GL.uniformMatrix3D( uMVMatrix, false, _modelViewMatrix );
					
					GL.bindBuffer( GL.ARRAY_BUFFER, _stencilBuffer );
					GL.vertexAttribPointer( vertexAttrib, 2, GL.FLOAT, false, 6 * 4, VERTEX_POS * 4 );
					GL.vertexAttribPointer( colorAttrib, 4, GL.FLOAT, false, 6 * 4, VERTEX_COLOR * 4 );
					
					trace("Using stencil", batch.mask );
					
					GL.enable( GL.STENCIL_TEST );
					GL.stencilFunc( GL.ALWAYS, 1, 0xFF );
					GL.stencilOp( GL.KEEP, GL.KEEP, GL.REPLACE );
					GL.stencilMask( 0xFF );
					GL.colorMask( false, false, false, false );
					GL.clear( GL.STENCIL_BUFFER_BIT );
					
					GL.drawArrays( GL.TRIANGLE_STRIP, Std.int(batch.mask / 6), 4 );
					
					GL.stencilFunc( GL.EQUAL, 1, 0xFF );
					GL.stencilMask( 0x00 );
					GL.colorMask( true, true, true, true );
					
					GL.useProgram( null );
					GL.bindBuffer( GL.ARRAY_BUFFER, null );
					GL.disableVertexAttribArray( vertexAttrib );
					GL.disableVertexAttribArray( colorAttrib );
				}
			}else {
				GL.disable( GL.STENCIL_TEST );
			}
			
			trace("Drawing batch", batch.start, batch.length );
			
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