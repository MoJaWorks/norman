package uk.co.mojaworks.norman.components.text;

import lime.math.Vector2;
import uk.co.mojaworks.norman.components.Component;
import uk.co.mojaworks.norman.components.renderer.TextRenderer;
import uk.co.mojaworks.norman.components.text.TextInputCaretAnimation;
import uk.co.mojaworks.norman.factory.GameObject;
import uk.co.mojaworks.norman.factory.SpriteFactory;
import uk.co.mojaworks.norman.utils.MathUtils;

/**
 * ...
 * @author Simon
 */
class TextInput extends Component
{

	public var hasTextFocus( default, set ) : Bool = false;
	public var cursorPosition( default, set ) : Int = 0;
	public var placeholder( default, set ) : String;
	public var text( default, set ) : String;
	public var textDisplay( default, null ) : String;
	public var isPassword( default, set ) : Bool;
	
	public var caret : GameObject;
	
	public function new() 
	{
		super();
	}
	
	override public function onAdded():Void 
	{
		super.onAdded();
		text = TextRenderer.getFromObject( gameObject ).text;
		cursorPosition = text.length;
	}
	
	private function set_hasTextFocus( bool : Bool ) : Bool 
	{
		
		if ( !hasTextFocus && bool ) {
			
			var textRenderer : TextRenderer = cast gameObject.renderer;
			
			// Create a caret
			caret = SpriteFactory.createFilledSprite( textRenderer.color, Math.max(textRenderer.fontSize * 0.05, 2), textRenderer.fontSize );
			//caret.addComponent( new TextInputCaretAnimation() );
			
		}
		
		return this.hasTextFocus = bool;
	}
	
	private function set_placeholder( str : String ) : String 
	{
		return this.placeholder = str;
	}
	
	private function set_text( str : String ) : String 
	{
		textDisplay = str;
		TextRenderer.getFromObject( gameObject ).text = str;
		return this.text = str;
	}
	
	private function set_isPassword( bool : Bool ) : Bool 
	{
		return this.isPassword = bool;
	}
	
	private function set_cursorPosition( pos : Int ) : Int 
	{
		this.cursorPosition = Math.floor(MathUtils.clamp( 0, text.length, pos ));
		
		var pos : Vector2 = TextRenderer.getFromObject( gameObject ).getPositionOfCharacterAtIndex( cursorPosition );
		
		
		return this.cursorPosition;
	}
	
	public function addTextAtCursor( str : String ) : Void
	{
		text = text.substr( 0, cursorPosition ) + str + text.substring( cursorPosition );
		cursorPosition += str.length;
	}
	
	public function removeCharacterAfterCursor() : Void 
	{
		if ( cursorPosition < text.length ) {
			text = text.substr( 0, cursorPosition ) + text.substring( cursorPosition + 1 );
		}
	}
	
	public function removeCharacterBeforeCursor() : Void 
	{
		if ( cursorPosition > 0 ) {
			text = text.substr( 0, cursorPosition - 1 ) + text.substring( cursorPosition );
			cursorPosition--;
		}
	}
	
	public function moveCursor( amount : Int ) : Void 
	{
		cursorPosition += amount;
	}
	
}