package uk.co.mojaworks.norman.display.ui;

import uk.co.mojaworks.norman.display.Sprite;
import uk.co.mojaworks.norman.systems.Systems;
import uk.co.mojaworks.norman.systems.ui.IUISprite;
import uk.co.mojaworks.norman.systems.ui.UIComponent;

/**
 * ...
 * @author Simon
 */
class UISprite extends Sprite implements IUISprite
{

	public var uiComponent( default, null ) : UIComponent;
	
	public function new() 
	{
		super();
		uiComponent = new UIComponent();
		Systems.ui.addUISprite( this );
	}
	
	override public function destroy() : Void 
	{
		super.destroy();
		Systems.ui.removeSprite( this );
	}
	
	/* INTERFACE uk.co.mojaworks.norman.systems.ui.IUISprite */
	
	public function getUIComponent():UIComponent 
	{
		return uiComponent;
	}
	
	public function getUITargetSprite():Sprite 
	{
		// Override
		return this;
	}
	
	public function update( seconds : Float ) : Void {
		// Override
	}
	
}