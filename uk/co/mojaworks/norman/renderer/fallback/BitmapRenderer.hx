package uk.co.mojaworks.norman.renderer.fallback ;
import flash.display.BitmapData;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.geom.Rectangle;
import uk.co.mojaworks.norman.core.CoreObject;
import uk.co.mojaworks.norman.core.GameObject;

/**
 * ...
 * @author Simon
 */
class BitmapRenderer extends CoreObject implements IRenderer
{
	
	var _canvas : Bitmap;

	public function new() 
	{
		super();
	}
	
	/* INTERFACE uk.co.mojaworks.norman.renderer.IRenderer */
	
	public function render( root : GameObject ) 
	{
		
	}
	
	public function resize( rect:Rectangle ) : Void {
		_canvas.bitmapData = new BitmapData( Std.int( rect.width ), Std.int( rect.height ), true, 0 );		
	}
	
	public function init(rect:Rectangle) 
	{
		_canvas = new Bitmap( );
		resize( rect );
	}
	
	/* INTERFACE uk.co.mojaworks.norman.renderer.IRenderer */
	
	public function getDisplayObject():DisplayObject 
	{
		return _canvas;
	}
	
}