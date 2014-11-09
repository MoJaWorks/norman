package uk.co.mojaworks.norman.systems.renderer.gl ;
import lime.graphics.GLRenderContext;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.RenderContext;
import lime.math.Matrix4;
import lime.math.Matrix3;
import lime.math.Vector4;
import lime.utils.Float32Array;
import uk.co.mojaworks.norman.components.display.Sprite;
import uk.co.mojaworks.norman.core.GameObject;
import lime.math.Rectangle;
import uk.co.mojaworks.norman.engine.NormanApp;
import uk.co.mojaworks.norman.systems.renderer.batching.RenderBatch;
import uk.co.mojaworks.norman.systems.renderer.batching.TargetBatch;
import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * ...
 * @author Simon
 */
class GLCanvas implements ICanvas
{
	
	private static inline var VERTEX_SIZE : Int = 9;
	private static inline var VERTEX_POSITION : Int = 0;
	private static inline var VERTEX_COLOR : Int = 3;
	private static inline var VERTEX_UV : Int = 7;
	
	private var _context : GLRenderContext;
	private var _stageWidth : Int;
	private var _stageHeight : Int;
	
	private var _vertexBuffer : GLBuffer;
	private var _indexBuffer : GLBuffer;
	private var _batches : Array<GLBatchData>;
	private var _target : GLTextureData;
	
	private var currentBatch( get, null ) : GLBatchData;
	
	
	public function new() 
	{
	}
	
	/* INTERFACE uk.co.mojaworks.norman.renderer.ICanvas */
	
	public function init( context : RenderContext ) : Void 
	{
		_context = cast context;
		_batches = [];
	}
	
	public function resize( width : Int, height : Int ) : Void 
	{
		// Create our render target
		_target = cast NormanApp.textureManager.createTexture( "norman_render", width, height );
	}
	
	public function render( vertices : Array<Float>, indices : Array<Int>, batches : TargetBatch ) : Void 
	{		
		_context.clearColor( 0, 0, 0, 1 );
		
		for ( textureBatch in batches.items ) {
			if ( textureBatch.textureData != null ) {
				_context.bindTexture( GL.TEXTURE_2D, cast( textureBatch.textureData, GLTextureData).texture );
			}else {
				_context.bindTexture( GL.TEXTURE_2D, null );
			}
			
			for ( shaderBatch in textureBatch.items ) {
				
				_context.useProgram( cast( shaderBatch.shader, GLShaderProgram ).program );
				
				
			}
		}
	}
	
	public function getContext() : RenderContext {
		return cast _context;
	}
	
	public function getRenderTarget() : TextureData {
		return _target;
	}
	
	private function get_currentBatch() : GLBatchData {
		if ( _batches.length > 0 ) {
			return _batches[_batches.length - 1];
		}else {
			return null;
		}
	}
	
}