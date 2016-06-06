package uk.co.mojaworks.norman.components.ui;
import uk.co.mojaworks.norman.components.IComponent;
import uk.co.mojaworks.norman.factory.GameObject;
import uk.co.mojaworks.norman.systems.ui.PointerEvent;

/**
 * @author Simon
 */
interface IUIDelegate  extends IComponent
{
	
	public var isMouseButtonDown : Array<Bool>;
	public var wasMouseButtonDownLastFrame : Array<Bool>;
	public var wasMouseButtonDownElsewhere : Array<Bool>;
	public var isMouseOver : Bool;
	public var wasMouseOverLastFrame : Bool;
	public var isCurrentTarget : Bool;
	public var hitTarget : GameObject;
	//public var cursor : MouseCursor;
	public function processEvent( event : PointerEvent ) : Void;
}