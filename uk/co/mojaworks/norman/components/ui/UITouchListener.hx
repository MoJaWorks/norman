package uk.co.mojaworks.norman.components.ui;

import msignal.Signal.Signal0;
import uk.co.mojaworks.norman.components.display.Sprite;
import uk.co.mojaworks.norman.core.Component;
import uk.co.mojaworks.norman.core.Messenger.MessageData;
import uk.co.mojaworks.norman.core.view.GameObject;

/**
 * ...
 * @author ...
 */
class UITouchListener extends Component
{

	public var isPointerEnabled : Bool = true;
	public var isPointerOver : Bool = false;
	public var isPointerDown : Bool = false;
	public var hitSprite : Sprite = null;
	
	public var pointerDown( default, null ) : Signal0;
	public var pointerUp( default, null ) : Signal0;
	public var pointerOver( default, null ) : Signal0;
	public var pointerOut( default, null ) : Signal0;
	public var clicked( default, null ) : Signal0;
	
	public function new() 
	{
		super();
		
		pointerOut = new Signal0();
		pointerOver = new Signal0();
		pointerUp = new Signal0();
		pointerDown = new Signal0();
		clicked = new Signal0();
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
	
	public function getHitSprite() : Sprite {
		if ( hitSprite != null ) {
			return gameObject.sprite;
		}else {
			return hitSprite;
		}
	}
}