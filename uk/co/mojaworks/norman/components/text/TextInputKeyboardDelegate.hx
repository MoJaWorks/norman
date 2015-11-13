package uk.co.mojaworks.norman.components.text;
import lime.ui.KeyModifier;

import lime.ui.KeyCode;
import uk.co.mojaworks.norman.components.Component;
import uk.co.mojaworks.norman.components.delegates.BaseKeyboardDelegate;
import uk.co.mojaworks.norman.systems.Systems;

/**
 * ...
 * @author Simon
 */
class TextInputKeyboardDelegate extends BaseKeyboardDelegate
{

	public function new() 
	{
		super();
	}
	
	override public function onTextEntry(text:String):Void 
	{
		super.onTextEntry(text);
		
		var input : TextInput = TextInput.getFromObject( gameObject );
		
		trace("Add text to input", input.hasTextFocus );
		
		if ( input.hasTextFocus ) {
			input.addTextAtCursor( text );
		}
	}
	
	override public function onKeyDown(keyCode:KeyCode, modifier:KeyModifier):Void 
	{
		super.onKeyDown(keyCode, modifier);
		var input : TextInput = TextInput.getFromObject( gameObject );
		
		if ( input.hasTextFocus ) {
			switch( keyCode ) {
				case KeyCode.DELETE:
					input.removeCharacterAfterCursor();
				case KeyCode.BACKSPACE:
					input.removeCharacterBeforeCursor();
				case KeyCode.LEFT:
					input.moveCursor( -1);
				case KeyCode.RIGHT:
					input.moveCursor(1);
				default:
					// Do nothing
			}
		}
	}
	
}