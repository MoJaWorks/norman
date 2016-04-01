package uk.co.mojaworks.norman.components.io;

import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import uk.co.mojaworks.norman.components.Component;
import uk.co.mojaworks.norman.systems.Systems;

/**
 * ...
 * @author Simon
 */
class KeyboardDelegate extends Component implements IKeyboardDelegate
{

	public function new() 
	{
		super();
		
	}
	
	override public function onAdded():Void 
	{
		super.onAdded();
		core.io.keyboard.addKeyboardDelegate( this );
	}
	
	override public function onRemove():Void 
	{
		super.onRemove();
		core.io.keyboard.removeKeyboardDelegate( this );
	}
	
	public function onTextEntry( text : String ) : Void {}
	public function onTextEdit( text : String ) : Void {}
	public function onKeyDown( keyCode : KeyCode, modifier : KeyModifier ) : Void {}
	public function onKeyUp( keyCode : KeyCode, modifier : KeyModifier ) : Void {}
}