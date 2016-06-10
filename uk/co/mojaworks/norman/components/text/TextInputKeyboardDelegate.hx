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
			switch( keyCode ) {
				case Key.DELETE:
					input.removeCharacterAfterCursor();
				case Key.LEFT:
					input.moveCursor( -1);
				case Key.RIGHT:
					input.moveCursor(1);
				case Key.ENTER:
					input.addTextAtCursor("\n");
				case Key.ESCAPE:
					input.hasTextFocus = false;
				
				#if !android
				case Key.BACKSPACE:
					input.removeCharacterBeforeCursor();
				#end
				
				default:
					// Do nothing
			}
		}
	}
	
}