package uk.co.mojaworks.norman.systems.ui;
import uk.co.mojaworks.norman.components.delegates.BaseUIDelegate;
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
	public var target : BaseUIDelegate;
	
	public function new( type : MouseEventType, target : BaseUIDelegate, button : MouseButton )  
	{
		this.type = type;
		this.target = target;
		this.button = button;
	}
	
}