package uk.co.mojaworks.frameworkv2.components ;

import openfl.display.Sprite;
import openfl.geom.Rectangle;
import uk.co.mojaworks.frameworkv2.components.display.Display;
import uk.co.mojaworks.frameworkv2.core.Component;

/**
 * Game Viewport automatically resizes it's contents to fit inside a viewport
 * ...
 * @author Simon
 */
class Viewport extends Component
{
	// StageRect is the scaled stage. It will be scaled and centered to match the current screen resolution
	public var stageRect( default, null ) : Rectangle;
	
	// DisplayRect is the total display area including margins
	public var displayRect( default, null ) : Rectangle;
	
	// DisplayRect is the total display area including margins
	public var screenRect( default, null ) : Rectangle;
	
	// The scale os the stage to make it fit in the viewport
	public var scale : Float = 1;
	
	public function new( ) 
	{
		super();
		
		stageRect = new Rectangle();
		displayRect = new Rectangle();
		screenRect = new Rectangle();
		
	}
	
	public function init( viewWidth : Float, viewHeight : Float ):Void 
	{
		
		stageRect.width = viewWidth;
		stageRect.height = viewHeight;
		
		resize();
	}
		
	public function resize() : Void {
		
		screenRect.width = core.stage.stageWidth;
		screenRect.height = core.stage.stageHeight;
		
		scale = Math.min( screenRect.width / stageRect.width, screenRect.height / stageRect.height );
		
		var x : Float = (screenRect.width - (stageRect.width * scale)) * 0.5;
		var y : Float = (screenRect.height - (stageRect.height * scale)) * 0.5;
		
		stageRect.x = x / scale;
		stageRect.y = y / scale;
		
		displayRect.width = stageRect.x + stageRect.x + stageRect.width;
		displayRect.height = stageRect.y + stageRect.y + stageRect.height;
		
	}
	
}