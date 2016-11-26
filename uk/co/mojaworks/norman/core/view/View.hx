package uk.co.mojaworks.norman.core.view;
import msignal.Signal.Signal0;
import uk.co.mojaworks.norman.factory.GameObject;
import uk.co.mojaworks.norman.factory.ObjectFactory;

/**
 * ...
 * @author Simon
 */
class View
{
	public var root( default, null ) : GameObject;
	
	public var resized : Signal0;
	
	// This is the rectangle of the "safe" area of the screen. This will always be scaled to fit
	public var stageWidth( default, null ) : Float = 1024;	
	public var stageHeight( default, null ) : Float = 672;	
	
	// This is the additional space around the scaled safe area in respect to the stage scale.
	public var marginLeft( default, null ) : Float = 0;	
	public var marginTop( default, null ) : Float = 0;	
	
	public var scale( default, null ) : Float = 1;
	public var left( get, null ) : Float;
	public var right( get, null ) : Float;
	public var top( get, null ) : Float;
	public var bottom( get, null ) : Float;
	public var totalWidth( get, null ) : Float;
	public var totalHeight( get, null ) : Float;
	
	// This is the rectangle representing the device's screen in actual pixels used for pointer events
	public var screenWidth( default, null ) : Float = 1024;
	public var screenHeight( default, null ) : Float = 672;
	
	public function new() 
	{
		root = ObjectFactory.createGameObject("root");
		resized = new Signal0();
	}	
	
	public function setTargetSize( width : Float, height : Float ) : Void {
		stageWidth = width;
		stageHeight = height;
		trace("Initializing view ", stageWidth, stageHeight );
		updateDimensions();
	}
	
	public function resize( width : Float, height : Float ) : Void {
		screenWidth = width;
		screenHeight = height;
		updateDimensions();
		
		root.transform.scaleX = scale;
		root.transform.scaleY = scale;
		root.transform.x = marginLeft * scale;
		root.transform.y = marginTop * scale;
		
		resized.dispatch();
	}
	
	private function updateDimensions() : Void {
		scale = Math.min( screenWidth / stageWidth, screenHeight / stageHeight );
		marginLeft = ((screenWidth / scale) - stageWidth) * 0.5;
		marginTop = ((screenHeight / scale) - stageHeight) * 0.5;
	}
	
	private function get_left( ) : Float { return -marginLeft; }
	private function get_right( ) : Float { return stageWidth + marginLeft; }
	private function get_top( ) : Float { return -marginTop; }
	private function get_bottom( ) : Float { return stageHeight + marginTop; }
	private function get_totalWidth( ) : Float { return stageWidth + marginLeft + marginLeft; }
	private function get_totalHeight( ) : Float { return stageHeight + marginTop + marginTop; }
	
	
	public function displayListChanged() : Void
	{
		root.transform.updateDisplayOrder(0);
	}
	
}