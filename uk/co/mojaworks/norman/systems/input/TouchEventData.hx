package uk.co.mojaworks.norman.systems.input ;
import openfl.geom.Point;

/**
 * ...
 * @author Simon
 */
class TouchEventData
{

	public var type : String;
	public var touchId : Int;
	public var position : Point;
	public var localPosition : Point;
	public var isSuppressed : Bool = false;
	
	public function new( type : String, touchId : Int, position : Point, localPosition : Point ) 
	{
		this.touchId = touchId;
		this.position = position;
		this.localPosition = localPosition;
	}
	
}