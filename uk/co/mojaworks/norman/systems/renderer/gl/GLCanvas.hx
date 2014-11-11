package uk.co.mojaworks.norman.systems.renderer.gl ;
import lime.graphics.GLRenderContext;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.RenderContext;
import uk.co.mojaworks.norman.engine.NormanApp;
import uk.co.mojaworks.norman.systems.renderer.batching.RenderBatch;

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
	private var _target : GLTextureData;

	private var _batch : RenderBatch;
	
	public function new() 
	{
	}
	
	/* INTERFACE uk.co.mojaworks.norman.renderer.ICanvas */
	
	public function init( context : RenderContext ) : Void 
	{
		_context = cast context;
		_batch = new RenderBatch();
	}
	
	public function resize( width : Int, height : Int ) : Void 
	{
		// Create our render target
		_target = cast NormanApp.textureManager.createTexture( "norman_render", width, height );
	}
		
	public function getContext() : RenderContext {
		return cast _context;
	}
	
}