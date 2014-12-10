package uk.co.mojaworks.norman.core.view;
import lime.math.Rectangle;
import uk.co.mojaworks.norman.core.CoreObject;

/**
 * ...
 * @author Simon
 */
class Viewport extends CoreObject
{

	// This is the rectangle of the "safe" area of the screen. This will always be scaled to fit
	public var stageWidth( default, null ) : Float;	
	public var stageHeight( default, null ) : Float;	
	
	// This is the additional space around the scaled safe area in respect to the stage scale.
	public var marginLeft( default, null ) : Float;	
	public var marginTop( default, null ) : Float;	
	
	public var left( get, null ) : Float;
	public var right( get, null ) : Float;
	public var top( get, null ) : Float;
	public var bottom( get, null ) : Float;
	public var totalWidth( get, null ) : Float;
	public var totalHeight( get, null ) : Float;
	
	// This is the rectangle representing the device's screen in actual pixels used for pointer events
	public var screenWidth( default, null ) : Float;
	public var screenHeight( default, null ) : Float;
	
	
	public function new() 
	{
		
	}
	
	public function setTargetSize( width : Float, height : Float ) : Void {
		stageWidth = width;
		stageHeight = height;
	}
	
	public function resize( width : Float, height : Float ) : Void {
		screenWidth = width;
		screenHeight = height;
	}
	
	private function get_left( ) : Float { return -marginLeft; }
	private function get_right( ) : Float { return stageWidth + marginLeft; }
	private function get_top( ) : Float { return -marginTop; }
	private function get_bottom( ) : Float { return stageHeight + marginTop; }
	private function get_totalWidth( ) : Float { return stageWidth + marginLeft + marginLeft; }
	private function get_totalHeight( ) : Float { return stageHeight + marginTop + marginTop; }
	
}