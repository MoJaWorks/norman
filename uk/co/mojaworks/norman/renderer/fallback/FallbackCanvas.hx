package uk.co.mojaworks.norman.renderer.fallback;
import openfl.geom.Matrix;
import openfl.geom.Point;
import uk.co.mojaworks.norman.core.GameObject;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.geom.Rectangle;
import uk.co.mojaworks.norman.renderer.ICanvas;
import uk.co.mojaworks.norman.renderer.TextureData;

/**
 * ...
 * @author Simon
 */
class FallbackCanvas implements ICanvas
{

	var _bitmap : Bitmap;
	
	public function new() 
	{
		
	}
	
	/* INTERFACE uk.co.mojaworks.norman.renderer.ICanvas */
	
	public function getDisplayObject() : DisplayObject 
	{
		return _bitmap.bitmapData;
	}
	
	
	public function resize(rect:Rectangle):Void 
	{
		_bitmap.bitmapData = new BitmapData( rect.width, rect.height, false, 0 );
	}
	
	public function render(root:GameObject):Void 
	{
		
	}
	
	public function init(rect:Rectangle):Void 
	{
		_bitmap = new Bitmap( new BitmapData( rect.width, rect.height, false, 0 ) );
	}
	
	public function fillRect(red:Float, green:Float, blue:Float, alpha:Float, width : Float, height : Float, transform:Matrix):Void 
	{
		
		var arr : Array<Point> = [
			transform.transformPoint( new Point( 0, 0 ) ),
			transform.transformPoint( new Point( width, height ) ),
		];
		
	}
	
	public function drawImage(texture:TextureData, transform:Matrix, alpha:Float, red:Float, green:Float, blue:Float):Void 
	{
		
	}
	
	public function drawSubImage(texture:TextureData, sourceRect:Rectangle, transform:Matrix, alpha:Float, red:Float, green:Float, blue:Float):Void 
	{
		
	}
	
	
	
}