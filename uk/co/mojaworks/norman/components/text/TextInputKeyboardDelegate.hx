package uk.co.mojaworks.norman.components.text;
import geoff.event.Key;
import uk.co.mojaworks.norman.components.io.KeyboardDelegate;

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

	override public function onKeyDown(keyCode:Int, modifier:Int):Void
	{
		super.onKeyDown(keyCode, modifier);
		var input : TextInput = TextInput.getFrom( gameObject );

		if ( input.hasTextFocus ) {

			if ( keyCode == Key.DELETE )
			{
				#if android
					input.removeCharacterBeforeCursor();
				#else
					input.removeCharacterAfterCursor();
				#end
			}
			else if ( keyCode == Key.LEFT )
			{
				input.moveCursor(-1);
			}
			else if ( keyCode == Key.RIGHT )
			{
				input.moveCursor(1);
			}
			else if ( keyCode == Key.ESCAPE || keyCode == Key.BACK )
			{
				input.hasTextFocus = false;
			}

			#if !android
			else if ( keyCode == Key.BACKSPACE )
			{
				input.removeCharacterBeforeCursor();
			}
			else if ( keyCode == Key.ENTER )
			{
				input.addTextAtCursor("\n");
			}
			#end
			
		}
	}

}
