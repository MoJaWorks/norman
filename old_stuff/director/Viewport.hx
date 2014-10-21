package uk.co.mojaworks.norman.components.director ;

import openfl.geom.Rectangle;
import uk.co.mojaworks.norman.core.RootObject;

/**
 * Game Viewport automatically resizes it's contents to fit inside a viewport
 * ...
 * @author Simon
 */
class Viewport extends RootObject
{
	// StageRect is the scaled stage. It will be scaled and centered to match the current screen resolution
	public var stageRect( default, null ) : Rectangle;
	
	// DisplayRect is the total display area including margins
	public var fullStageRect( default, null ) : Rectangle;
	
	// Screenrect is the total unscaled screen area
	public var screenRect( default, null ) : Rectangle;
	
	// The scale of the stage to make it fit in the viewport
	public var scale : Float = 1;
	
	public function new( ) 
	{
		super();
		
		stageRect = new Rectangle();
		fullStageRect = new Rectangle();
		screenRect = new Rectangle();
		
	}
	
	public function setTargetSize( viewWidth : Int, viewHeight : Int ):Void 
	{
		
		stageRect.width = viewWidth;
		stageRect.height = viewHeight;
		
		resize();
	}
		
	public function resize() : Void {
		
		screenRect.width = root.stage.stageWidth;
		screenRect.height = root.stage.stageHeight;
		
		scale = Math.min( screenRect.width / stageRect.width, screenRect.height / stageRect.height );
		
		screenRect.x = (screenRect.width - (stageRect.width * scale)) * 0.5;
		screenRect.y = (screenRect.height - (stageRect.height * scale)) * 0.5;
		
		stageRect.x = screenRect.x / scale;
		stageRect.y = screenRect.y / scale;
		
		fullStageRect.x = -stageRect.x;
		fullStageRect.y = -stageRect.y;
		fullStageRect.width = stageRect.x + stageRect.x + stageRect.width;
		fullStageRect.height = stageRect.y + stageRect.y + stageRect.height;
		
	}
	
}