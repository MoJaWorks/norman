package uk.co.mojaworks.norman.components.display.text;
import lime.graphics.Font;
import lime.math.Rectangle;
import uk.co.mojaworks.norman.components.display.text.TextSprite.TextAlign;

/**
 * ...
 * @author Simon
 */
class TextLayout
{
	// config
	var font : Font;
	var fontData : NativeFontData;
	var fontSize : Int;
	var align : TextAlign;
	var wrapWidth : Float;
	
	// results
	var lineLengths : Array<Float>;
	var characters : Array<TextLayoutCharacter>;
	var bounds : Rectangle;
	
	public function new() {
		
		lineLengths = [];
		characters = [];
		
	}
	
	public function rebuild( text : String ) : Void {
		
		lineLengths = [];
		characters = [];
		
		var currentLine : Int = 0;
		var currentWord : Array<TextLayoutCharacter>;
		var isFirstWord : Bool = true;
		var lastCharacter : TextLayoutCharacter;
		
		for ( pos in 0...text.length ) {
			
			var char_data : TextLayoutCharacter = new TextLayoutCharacter();
			char_data.characterId = text.charCodeAt( pos );
			char_data.line = currentLine;
			char_data.paddingLeft = font.glyphs[char_data.characterId]
			
			
		}
		
	}
}