package uk.co.mojaworks.norman.components.input ;
import openfl.geom.Point;

/**
 * ...
 * @author Simon
 */
class TouchData
{
	public var isDown : Bool = false;
	public var touchId : Int = -1;
	public var position : Point;
	public var lastTouchStart : Point;
	public var lastTouchEnd : Point;

	public function new( id : Int ) 
	{
		touchId = id;
		position = new Point();
		lastTouchStart = new Point();
		lastTouchEnd = new Point();
	}
	
}