package uk.co.mojaworks.norman.components.text;
import lime.ui.KeyModifier;

import lime.ui.KeyCode;
import uk.co.mojaworks.norman.components.Component;
import uk.co.mojaworks.norman.components.io.KeyboardDelegate;
import uk.co.mojaworks.norman.systems.Systems;

/**
 * ...
 * @author Simon
 */
class TextInputKeyboardDelegate extends KeyboardDelegate
{

	public function new() 
	{
		super();
	}
	
	override public function onTextEntry(text:String):Void 
	{
		super.onTextEntry(text);
		
		var input : TextInput = TextInput.getFrom( gameObject );
		
		if ( input.hasTextFocus ) {
			input.addTextAtCursor( text );
		}
	}
	
	override public function onKeyDown(keyCode:KeyCode, modifier:KeyModifier):Void 
	{
		super.onKeyDown(keyCode, modifier);
		var input : TextInput = TextInput.getFrom( gameObject );
		
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
				case KeyCode.RETURN:
					input.addTextAtCursor("\n");
				case KeyCode.ESCAPE:
					input.hasTextFocus = false;
				default:
					// Do nothing
			}
		}
	}
	
}