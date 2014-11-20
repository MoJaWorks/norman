package uk.co.mojaworks.norman.components.display.text.layout ;
import lime.graphics.Font;
import lime.math.Rectangle;
import uk.co.mojaworks.norman.components.display.text.font.BitmapFont;

/**
 * ...
 * @author Simon
 */

enum TextAlign {
	Left;
	Right;
	Center;
}
 
class TextLayout
{
	// config
	var font : BitmapFont;
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
		
		//lineLengths = [];
		//characters = [];
		//
		//var currentLine : Int = 0;
		//var currentWord : Array<TextLayoutCharacter>;
		//var isFirstWord : Bool = true;
		//var lastCharacter : TextLayoutCharacter;
		//
		//for ( pos in 0...text.length ) {
			//
			//var char_data : TextLayoutCharacter = new TextLayoutCharacter();
			//char_data.characterId = text.charCodeAt( pos );
			//char_data.line = currentLine;
			//char_data.paddingLeft = font.glyphs[char_data.characterId];
			//
			//
		//}
		//
	}
}