package uk.co.mojaworks.norman.components.io;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;

/**
 * @author Simon
 */
interface IKeyboardDelegate extends IComponent
{
	public function onTextEntry( text : String ) : Void;
	public function onTextEdit( text : String ) : Void;
	public function onKeyDown( keyCode : KeyCode, modifier : KeyModifier ) : Void;
	public function onKeyUp( keyCode : KeyCode, modifier : KeyModifier ) : Void;
}