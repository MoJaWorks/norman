package uk.co.mojaworks.norman.components.ui;

import uk.co.mojaworks.norman.core.Component;
import uk.co.mojaworks.norman.core.Messenger.MessageData;
import uk.co.mojaworks.norman.core.view.GameObject;

/**
 * ...
 * @author ...
 */
class UIItem extends Component
{

	public var isPointerEnabled : Bool = true;
	public var isPointerDown : Bool = false;
	public var isPointerOver : Bool = false;
	
	public function new() 
	{
		super();
	}
	
	override public function onAdded():Void 
	{
		super.onAdded();
		core.app.ui.add( this );
	}
	
	override public function onRemoved():Void 
	{
		super.onRemoved();
		core.app.ui.remove( this );
	}
	
	//public function onMouseDown( event : PointerEvent ) : Void {
		//
	//}
	
	
	
}