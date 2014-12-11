package uk.co.mojaworks.norman.systems.input ;
import lime.math.Vector2;

/**
 * ...
 * @author Simon
 */
class TouchEventData
{

	public var type : String;
	public var touchId : Int;
	public var position : Vector2;
	public var localPosition : Vector2;
	public var isSuppressed : Bool = false;
	
	public function new( type : String, touchId : Int, position : Vector2, localPosition : Vector2 ) 
	{
		this.type = type;
		this.touchId = touchId;
		this.position = position;
		this.localPosition = localPosition;
	}
	
}