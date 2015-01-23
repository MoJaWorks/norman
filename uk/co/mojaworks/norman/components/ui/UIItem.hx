package uk.co.mojaworks.norman.components.ui;

import uk.co.mojaworks.norman.components.display.Sprite;
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
	public var isInteractive : Bool = true;
	
	var _wasPointerOver : Bool = false;
	var _wasPointerDown : Bool = false;
	
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
	
	public function update( seconds : Float ) : Void {
		updateState();
		_wasPointerDown = isPointerDown;
		_wasPointerOver = isPointerOver;
	}	
	
	private function updateState() : Void {
		
	}
	
	public function getHitSprite() : Sprite {
		return gameObject.sprite;
	}
}