package uk.co.mojaworks.frameworkv2.renderer;
import flash.display.BitmapData;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.geom.Rectangle;
import uk.co.mojaworks.frameworkv2.core.CoreObject;
import uk.co.mojaworks.frameworkv2.core.GameObject;

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
	
	/* INTERFACE uk.co.mojaworks.frameworkv2.renderer.IRenderer */
	
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
	
	/* INTERFACE uk.co.mojaworks.frameworkv2.renderer.IRenderer */
	
	public function getCanvas():DisplayObject 
	{
		return _canvas;
	}
	
}