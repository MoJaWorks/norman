package uk.co.mojaworks.norman.components.text;

import uk.co.mojaworks.norman.components.delegates.BaseUIDelegate;
import uk.co.mojaworks.norman.systems.ui.MouseEvent;

/**
 * ...
 * @author Simon
 */
class TextInputUIDelegate extends BaseUIDelegate
{

	public function new() 
	{
		super();
	}
	
	override public function onClick(e:MouseEvent):Void 
	{
		super.onClick(e);
		
		TextInput.getFromObject(gameObject).hasTextFocus = true;
	}
	
}