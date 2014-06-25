package uk.co.mojaworks.frameworkv2.core ;

import openfl.display.Sprite;
import openfl.geom.Rectangle;
import uk.co.mojaworks.frameworkv2.components.Display;
import uk.co.mojaworks.frameworkv2.core.Component;

/**
 * Game Viewport automatically resizes it's contents to fit inside a viewport
 * ...
 * @author Simon
 */
class Viewport extends CoreObject
{
	// StageRect is the scaled stage. It will be scaled and centered to match the current screen resolution
	public var stageRect( default, null ) : Rectangle;
	
	// DisplayRect is the total display area including margins
	public var displayRect( default, null ) : Rectangle;
	
	// The scale os the stage to make it fit in the viewport
	public var scale : Float = 1;
	
	public function new( ) 
	{
		super();
		
		stageRect = new Rectangle();
		displayRect = new Rectangle();
		
	}
	
	public function init( viewWidth : Float, viewHeight : Float ):Void 
	{
		
		stageRect.width = viewWidth;
		stageRect.height = viewHeight;
		
		resize();
	}
		
	public function resize() : Void {
		
		var targetWidth : Float = core.stage.stageWidth;
		var targetHeight : Float = core.stage.stageHeight;
		
		scale = Math.min( targetWidth / stageRect.width, targetHeight / stageRect.height );
		
		var x : Float = (targetWidth - (stageRect.width * scale)) * 0.5;
		var y : Float = (targetHeight - (stageRect.height * scale)) * 0.5;
		
		stageRect.x = x / scale;
		stageRect.y = y / scale;
		
		displayRect.width = stageRect.x + stageRect.x + stageRect.width;
		displayRect.height = stageRect.y + stageRect.y + stageRect.height;
		
	}
	
}