package uk.co.mojaworks.norman.systems.ui;
import lime.math.Vector2;
import uk.co.mojaworks.norman.systems.input.InputSystem.MouseButton;

/**
 * ...
 * @author Simon
 */

@:enum abstract MouseEventType(String) to String from String {
	var Up = "MouseUp";
	var Down = "MouseDown";
	var Over = "MouseOver";
	var Out = "MouseOut";
	var Click = "MouseClick";
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