package uk.co.mojaworks.norman.systems.ui;
import lime.math.Vector2;
import uk.co.mojaworks.norman.systems.input.InputSystem.MouseButton;

/**
 * ...
 * @author Simon
 */

enum MouseEventType {
	Up;
	Down;
	Over;
	Out;
	Click;
}
 
class MouseEvent
{

	public var type : MouseEventType;
	public var button : MouseButton;
	public var target : UIComponent;
	public var stopped : Bool = false;
	
	public function new( ) 
	{
	}
	
}