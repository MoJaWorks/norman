package uk.co.mojaworks.norman.components ;

import openfl.display.Sprite;
import openfl.geom.Rectangle;
import uk.co.mojaworks.norman.components.display.Display;
import uk.co.mojaworks.norman.core.Component;

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
	
	// Screenrect is the total unscaled screen area
	public var screenRect( default, null ) : Rectangle;
	
	// The scale of the stage to make it fit in the viewport
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
		
		screenRect.x = (screenRect.width - (stageRect.width * scale)) * 0.5;
		screenRect.y = (screenRect.height - (stageRect.height * scale)) * 0.5;
		
		stageRect.x = screenRect.x / scale;
		stageRect.y = screenRect.y / scale;
		
		displayRect.x = -stageRect.x;
		displayRect.y = -stageRect.y;
		displayRect.width = stageRect.x + stageRect.x + stageRect.width;
		displayRect.height = stageRect.y + stageRect.y + stageRect.height;
		
	}
	
}