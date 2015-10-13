package uk.co.mojaworks.norman.systems.ui;
import lime.math.Vector2;
import uk.co.mojaworks.norman.systems.input.InputSystem.MouseButton;

/**
 * ...
 * @author Simon
 */
class MouseEvent
{

	public var button : MouseButton;
	public var stopped : Bool = false;
	
	public function new( button : MouseButton ) 
	{
		this.button = button;
	}
	
}