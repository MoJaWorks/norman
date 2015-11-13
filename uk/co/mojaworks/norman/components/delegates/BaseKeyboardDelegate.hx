package uk.co.mojaworks.norman.components.delegates;

import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import uk.co.mojaworks.norman.components.Component;
import uk.co.mojaworks.norman.systems.Systems;

/**
 * ...
 * @author Simon
 */
class BaseKeyboardDelegate extends Component
{

	public function new() 
	{
		super();
		
	}
	
	override public function onAdded():Void 
	{
		super.onAdded();
		Systems.input.addKeyboardDelegate( this );
	}
	
	override public function onRemove():Void 
	{
		super.onRemove();
		Systems.input.removeKeyboardDelegate( this );
	}
	
	public function onTextEntry( text : String ) : Void {}
	public function onKeyDown( keyCode : KeyCode, modifier : KeyModifier ) : Void {}
	public function onKeyUp( keyCode : KeyCode, modifier : KeyModifier ) : Void {}
}