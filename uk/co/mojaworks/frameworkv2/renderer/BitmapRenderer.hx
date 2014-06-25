package uk.co.mojaworks.frameworkv2.renderer;
import flash.display.BitmapData;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.geom.Rectangle;
import uk.co.mojaworks.frameworkv2.core.CoreObject;

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
	
	public function render() 
	{
		
	}
	
	public function init(rect:Rectangle) 
	{
		_canvas = new Bitmap( new BitmapData( Std.int(rect.width), Std.int(rect.height), true, 0 ) );
	}
	
	/* INTERFACE uk.co.mojaworks.frameworkv2.renderer.IRenderer */
	
	public function getCanvas():DisplayObject 
	{
		return _canvas;
	}
	
}