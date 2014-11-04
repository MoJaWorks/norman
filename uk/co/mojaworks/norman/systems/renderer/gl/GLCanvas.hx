package uk.co.mojaworks.norman.systems.renderer.gl ;
import lime.graphics.GLRenderContext;
import lime.graphics.RenderContext;
import lime.math.Matrix4;
import lime.math.Matrix3;
import uk.co.mojaworks.norman.components.display.Sprite;
import uk.co.mojaworks.norman.core.GameObject;
import lime.math.Rectangle;
import uk.co.mojaworks.norman.systems.renderer.batching.RenderBatch;
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
	
	public function new() 
	{
		
	}
	
	/* INTERFACE uk.co.mojaworks.norman.renderer.ICanvas */
	
	public function init( context : RenderContext ) : Void 
	{
		_context = cast context;
	}
	
	public function resize( width : Int, height : Int ) : Void 
	{
		// Don't usually need to do anything here - resizing is handled by the camera
	}
	
	public function render(objects:RenderBatch, camera : GameObject) : Void 
	{
		
		
		
	}
	
	public function fillRect(red:Float, green:Float, blue:Float, alpha:Float, width:Float, height:Float, transform:Matrix3):Void 
	{
		
	}
	
	public function drawImage(texture:TextureData, transform:Matrix4, alpha:Float = 1, red:Float = 255, green:Float = 255, blue:Float = 255):Void 
	{
		
	}
	
	public function drawSubImage(texture:TextureData, sourceRect:Rectangle, transform:Matrix4, alpha:Float = 1, red:Float = 255, green:Float = 255, blue:Float = 255):Void 
	{
		
	}
	
	public function getContext() : RenderContext {
		return cast _context;
	}
	
}