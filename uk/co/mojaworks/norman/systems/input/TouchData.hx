package uk.co.mojaworks.norman.systems.input ;
import lime.math.Vector2;

/**
 * ...
 * @author Simon
 */
class TouchData
{
	public var isDown : Bool = false;
	public var touchId : Int = -1;
	public var position : Vector2;
	public var lastTouchStart : Vector2;
	public var lastTouchEnd : Vector2;

	public function new( id : Int ) 
	{
		touchId = id;
		position = new Vector2( -1, -1 );
		lastTouchStart = new Vector2( -1, -1 );
		lastTouchEnd = new Vector2( -1, -1 );
	}
	
}