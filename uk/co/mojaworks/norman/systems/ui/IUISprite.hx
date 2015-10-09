package uk.co.mojaworks.norman.systems.ui;
import uk.co.mojaworks.norman.display.Sprite;

/**
 * @author Simon
 */

interface IUISprite 
{
	public function getUIComponent() : UIComponent;
	public function getUITargetSprite() : Sprite;
}