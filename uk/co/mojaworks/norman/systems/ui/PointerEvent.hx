package uk.co.mojaworks.norman.systems.ui;
import uk.co.mojaworks.norman.components.delegates.BaseUIDelegate;
import uk.co.mojaworks.norman.core.io.pointer.PointerInput.MouseButton;
import uk.co.mojaworks.norman.systems.ui.PointerEvent.PointerEventType;

/**
 * ...
 * @author Simon
 */

@:enum abstract PointerEventType(String) to String from String {
	var Up = "PointerUp";
	var Down = "PointerDown";
	var Over = "PointerOver";
	var Out = "PointerOut";
	var Click = "PointerClick";
}
 
class PointerEvent
{

	public var type : PointerEventType;
	public var button : MouseButton;
	public var target : BaseUIDelegate;
	public var pointerId : Int;
	
	public function new( type : PointerEventType, target : BaseUIDelegate, pointerId : Int, button : MouseButton )  
	{
		this.type = type;
		this.target = target;
		this.button = button;
		this.pointerId = pointerId;
	}
	
}