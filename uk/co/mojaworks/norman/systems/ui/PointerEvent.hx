package uk.co.mojaworks.norman.systems.ui;
import geoff.event.PointerButton;
import uk.co.mojaworks.norman.components.ui.IUIDelegate;
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
	var Scroll = "PointerScroll";
}
 
class PointerEvent
{

	public var type : PointerEventType;
	public var button : PointerButton;
	public var target : IUIDelegate;
	public var pointerId : Int;
	
	public function new( type : PointerEventType, target : IUIDelegate, pointerId : Int, button : PointerButton )  
	{
		this.type = type;
		this.target = target;
		this.button = button;
		this.pointerId = pointerId;
	}
	
}