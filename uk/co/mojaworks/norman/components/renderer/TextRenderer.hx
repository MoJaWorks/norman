package uk.co.mojaworks.norman.components.renderer;
import lime.math.Matrix3;
import lime.math.Rectangle;
import uk.co.mojaworks.norman.components.renderer.AbstractRenderer;
import uk.co.mojaworks.norman.systems.renderer.Canvas;
import uk.co.mojaworks.norman.systems.renderer.TextureData;
import uk.co.mojaworks.norman.text.BitmapFont;
import uk.co.mojaworks.norman.utils.Color;

/**
 * ...
 * @author Simon
 */

enum TextAlign {
	Left;
	Right;
	Center;
	Justify;
}

enum WrapType {
	None;
	Word;
	Letter;
	Auto;
}
 
class TextRenderer extends AbstractRenderer
{
		
	// Get access to formatting through layout
	public var text( default, set ) : String = "";
	
	// config
	public var color( default, default ) : Color;
	public var font( default, set ) : BitmapFont;
	public var align( default, set ) : TextAlign;
	public var wrapType( default, set ) : WrapType;
	public var wrapWidth( default, set ) : Float;
	public var letterSpacing( default, set ) : Float;
	public var lineSpacing( default, set ) : Float;
	public var fontSize( default, set ) : Float = 32;
	
	// results
	private var _lineStops : Array<Int>;
	private var _bounds : Rectangle;
	private var _fontMultiplier : Float = 1;
	
		
	var _layoutDirty : Bool = true;
	
	public function new( text : String, font : BitmapFont ) 
	{
		super( );
		
		_lineStops = [];
		_bounds = new Rectangle();
		
		color = Color.WHITE;
		wrapWidth = 0;
		letterSpacing = 0;
		lineSpacing = 0;
		align = TextAlign.Left;
		wrapType = WrapType.Auto;
		
		this.text = text;
		this.font = font;
		
		_layoutDirty = true;
	}
			
	
	/**
	 * Render
	 * @param	canvas
	 */
	
	private function regenerateLayout() : Void {
		
		_bounds.setEmpty();
		_lineStops = [0];
		
		var previousCharacter : CharacterData = null;
		var lineStart : Int = 0;
		var wordStart : Int = 0;
		var currentX : Float = 0; // Counts apaces	
		var lineLength : Float = 0;	// Doesn't count spaces unless there are more letters after
		var lineLengthToLastWord : Float = 0; // Counts to end of last word
		var isFirstWord : Bool = true;
		var kerning : KerningData = null;
				
		for ( i in 0...text.length ) {
			
			var char : CharacterData =  font.characters.get( text.charCodeAt(i) );
			if ( char == null ) char = new CharacterData( text.charCodeAt(i) );
			
			kerning = null;
			if ( previousCharacter != null) {
				if (font.kernings.get( previousCharacter.id ) != null ) {
					kerning = font.kernings.get( previousCharacter.id ).get( char.id );
					if ( kerning != null ) currentX -= kerning.amount * _fontMultiplier;
				}
				currentX += letterSpacing;
			}
			
			if ( char.id == 32 ) {
				// Check for a space - this marks the start of a new word
				wordStart = i + 1;
				isFirstWord = false;
				lineLengthToLastWord = lineLength;
				currentX += char.xAdvance * _fontMultiplier;
				previousCharacter = char;
			}
			else if ( char.id == 10 ) {
				// New line - make it break onto the next line
				wordStart = i + 1;
				isFirstWord = true;
				lineLengthToLastWord = 0;
				currentX = 0;
				previousCharacter = null;
				_bounds.width = Math.max( _bounds.width, lineLength );
				lineLength = 0;
				_lineStops.push( i );
			}
			else if ( wrapType == WrapType.None || (wrapType == WrapType.Auto && wrapWidth == 0 ) || (isFirstWord && wrapType == WrapType.Word) || (currentX + char.xAdvance < wrapWidth) ) {
				
				// Character fits on current line - let it be
				currentX += char.xAdvance * _fontMultiplier;
				lineLength = currentX;
				previousCharacter = char;
				
			}else {
				// Couldn't fit it on the line	
				
				if ( isFirstWord || wrapType == WrapType.Letter ) {
					// This is the first word on the line should we split it?
					wordStart = i;
					lineLengthToLastWord = lineLength;
					lineLength = char.xAdvance * _fontMultiplier;
				}else {
					// Carry letters onto next line and don't count the space between them
					lineLength -= lineLengthToLastWord - (char.xAdvance * _fontMultiplier);
				}
				
				// move to next line
				_bounds.width = Math.max( _bounds.width, lineLengthToLastWord );
				_lineStops.push( wordStart );
				currentX = lineLength;
				isFirstWord = true;
				previousCharacter = null;
				lineLengthToLastWord = 0;
				
			}
			
		}
		
		_bounds.width = Math.max( _bounds.width, lineLength );
		_bounds.height = (_lineStops.length * font.lineHeight * _fontMultiplier) + ((_lineStops.length - 1) * lineSpacing);
		_lineStops.push( text.length );
		_layoutDirty = false;
		
	}
	
	override public function render(canvas:Canvas):Void 
	{		
		
		if ( _layoutDirty ) regenerateLayout();
		
		var lineStart : Int = 0;
		var wordStart : Int = 0;
		var lineLength : Float = 0;	
		var y = 0;
		
		for ( i in 0..._lineStops.length - 1 ) {
			drawLine( canvas, text.substring( _lineStops[i], _lineStops[i+1] ), i * ((font.lineHeight * _fontMultiplier) + lineSpacing) );
		}
		
	}

	
	private function drawLine( canvas : Canvas, string : String, y : Float ) : Void {
	
		string = StringTools.rtrim( string );
		
		var x : Float = 0;
		var a : Float = 0;
		var padding : Float = 0;
		var prev_char : CharacterData = null;
		var m : Matrix3 = new Matrix3();
		var kerning : KerningData;
		
		// First go through and get line length
		for ( i in 0...string.length ) {
			
			var char : CharacterData =  font.characters.get( string.charCodeAt(i) );
			if ( char != null ) {
				
				kerning = null;
				if ( prev_char != null ) {
					if ( font.kernings.get( prev_char.id ) != null ) {
						kerning = font.kernings.get( prev_char.id ).get( char.id );
						if ( kerning != null ) x -= kerning.amount * _fontMultiplier;
					}
					x += letterSpacing;
				}
				x += char.xAdvance * _fontMultiplier;
			}
			prev_char = char;				 
		}
		
		
		// Put any padding at start of line for align
		switch( align ) {
			case TextAlign.Left:
				x = 0;
			case TextAlign.Center:
				x = (wrapWidth - x) * 0.5;
			case TextAlign.Right:
				x = wrapWidth - x;
			case TextAlign.Justify:
				padding = (wrapWidth - x) / (string.length - 1);
				x = 0;
		}
		
		prev_char = null;
		
		for ( i in 0...string.length ) {
			
			var char : CharacterData =  font.characters.get( string.charCodeAt(i) );
			if ( char != null ) {
				
				kerning = null;
				if ( prev_char != null ) {
					if ( font.kernings.get( prev_char.id ) != null ) {
						kerning = font.kernings.get( prev_char.id ).get( char.id );
						if ( kerning != null ) x -= kerning.amount * _fontMultiplier;
					}
					x += letterSpacing;
				}
				
				var texture : TextureData = font.pages[ char.pageId ];
				m.identity();
				m.scale( _fontMultiplier, _fontMultiplier );
				m.translate( x + (char.xOffset * _fontMultiplier), y + (char.yOffset * _fontMultiplier) );
				m.concat( gameObject.transform.renderMatrix );
				a = getCompositeAlpha() * color.a;
				
				// Dont bother drawing spaces and new lines
				if ( char.id != 10 && char.id != 32 ) {
										 
					var vertexData : Array<Float> = canvas.buildTexturedQuadVertexData(  texture, 
														 new Rectangle( 
															char.x / texture.width, 
															char.y / texture.width, 
															char.width / texture.width,
															char.height / texture.height
														 ), m, color.r, color.g, color.b, a );
					canvas.draw( [texture], ImageRenderer.defaultShader, vertexData, Canvas.QUAD_INDICES );
				}
									 
				x += (char.xAdvance * _fontMultiplier) + padding;
			}
			
			prev_char = char;
								 
		}
		
	}
	
	/**
	 * Sets the font
	 * @return
	 */
	
	public function set_font( font : BitmapFont ) : BitmapFont {
		this.font = font;
		_layoutDirty = true;
		_fontMultiplier = fontSize / font.size;
		return font;
	}
	
	public function set_fontSize( fontSize : Float ) : Float {
		this.fontSize = fontSize;
		_layoutDirty = true;
		_fontMultiplier = fontSize / font.size;
		return fontSize;
	}
	
	public function set_wrapType( wrapType : WrapType ) : WrapType {
		this.wrapType = wrapType;
		_layoutDirty = true;
		return wrapType;
	}
	
	public function set_wrapWidth( wrapWidth : Float ) : Float {
		this.wrapWidth = wrapWidth;
		_layoutDirty = true;
		return wrapWidth;
	}
	
	public function set_letterSpacing( letterSpacing : Float ) : Float {
		this.letterSpacing = letterSpacing;
		_layoutDirty = true;
		return letterSpacing;
	}
	
	public function set_lineSpacing( lineSpacing : Float ) : Float {
		this.lineSpacing = lineSpacing;
		_layoutDirty = true;
		return lineSpacing;
	}
	
	public function set_text( text : String ) : String {
		
		if ( text == null ) text = "";
		
		// Make all new lines the same
		var old_text : String = this.text;
		this.text = StringTools.replace( text, "\r\n", "\n" );
		this.text = StringTools.replace( this.text, "\r", "\n" );
		if ( old_text != text ) {
			_layoutDirty = true;
		}
		return this.text;
	}
	
	private function set_align( align : TextAlign ) : TextAlign {
		this.align = align;
		_layoutDirty = true;
		return align;
	}
	
	/**
	 * Sizes
	 * @return
	 */
	
	override public function getWidth() : Float 
	{
		if ( _layoutDirty ) regenerateLayout();
		return _bounds.width;
	}
	
	override public function getHeight() : Float 
	{
		if ( _layoutDirty ) regenerateLayout();
		return _bounds.height;
	}
	
}