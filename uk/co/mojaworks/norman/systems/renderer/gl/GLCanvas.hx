package uk.co.mojaworks.norman.systems.renderer.gl ;
import lime.graphics.GLRenderContext;
import lime.graphics.RenderContext;
import lime.math.Matrix4;
import lime.math.Matrix3;
import uk.co.mojaworks.norman.core.GameObject;
import lime.math.Rectangle;
import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * ...
 * @author Simon
 */
class GLCanvas implements ICanvas
{

	private var _collection : LinkedList<GameObject>;
	private var _context : GLRenderContext;
	private var _stageWidth : Int;
	private var _stageHeight : Int;
	
	public function new() 
	{
		
	}
	
	/* INTERFACE uk.co.mojaworks.norman.renderer.ICanvas */
	
	public function init( context : RenderContext ):Void 
	{
		_context = cast context;
	}
	
	public function resize( width : Int, height : Int ):Void 
	{
		
	}
	
	public function render(root:GameObject, camera : GameObject):Void 
	{
		
	}
	
	public function fillRect(red:Float, green:Float, blue:Float, alpha:Float, width:Float, height:Float, transform:Matrix3):Void 
	{
		
	}
	
	public function drawImage(texture:TextureData, transform:Matrix3, alpha:Float = 1, red:Float = 255, green:Float = 255, blue:Float = 255):Void 
	{
		
	}
	
	public function drawSubImage(texture:TextureData, sourceRect:Rectangle, transform:Matrix3, alpha:Float = 1, red:Float = 255, green:Float = 255, blue:Float = 255):Void 
	{
		
	}
	
}