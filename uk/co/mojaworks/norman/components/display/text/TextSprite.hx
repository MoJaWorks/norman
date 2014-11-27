package uk.co.mojaworks.norman.components.display.text ;
import lime.math.Matrix3;
import lime.math.Matrix4;
import lime.math.Rectangle;
import uk.co.mojaworks.norman.components.display.text.BitmapFont;
import uk.co.mojaworks.norman.systems.renderer.ICanvas;
import uk.co.mojaworks.norman.systems.renderer.shaders.DefaultImageFragmentShader;
import uk.co.mojaworks.norman.systems.renderer.shaders.DefaultImageVertexShader;
import uk.co.mojaworks.norman.systems.renderer.shaders.IShaderProgram;
import uk.co.mojaworks.norman.systems.renderer.TextureData;
import uk.co.mojaworks.norman.utils.Color;

/**
 * ...
 * @author Simon
 */
 
enum TextAlign {
	Left;
	Right;
	Center;
}
 
class TextSprite extends Sprite
{
	public static var shader : IShaderProgram;
	
	// Get access to formatting through layout
	public var text( default, set ) : String = "";
	
	// config
	public var color( default, default ) : Color;
	public var font( default, default ) : BitmapFont;
	public var align( default, default ) : TextAlign;
	public var wrapWidth( default, default ) : Float;
	
	// results
	private var _lineStops : Array<Int>;
	private var _bounds : Rectangle;
		
	// Draws onto this texture constantly re-uses it
	var _textureData : TextureData;
	var _fontTextures : Array<TextureData>;
	
	var _dirty : Bool;
	
	public function new( ) 
	{
		super();
		color = 0xFFFFFFFF;
		wrapWidth = 0;
		align = TextAlign.Left;
		_bounds = new Rectangle();
	}
	
	/**
	 * 
	 */
	
	override function initShader() 
	{
		super.initShader();
		if ( TextSprite.shader == null ) {
			TextSprite.shader = core.app.renderer.createShader( new DefaultImageVertexShader(), new DefaultImageFragmentShader() );
		}
	}
	
	override public function getShader():IShaderProgram 
	{
		return TextSprite.shader;
	}
	
	/**
	 * Add/remove
	 */
	
	override public function onAdded():Void 
	{
		super.onAdded();
		
		if ( _textureData == null ) {
			_textureData = core.app.renderer.createTexture( "@norman_fonts/" + gameObject.id, 300, 300 );
		}
		
		_dirty = true;
	}
	
	override public function onRemoved():Void 
	{
		super.onRemoved();
		if ( _textureData != null ) core.app.renderer.destroyTexture( "@norman_fonts/" + gameObject.id );
	}
		
	
	/**
	 * Render
	 * @param	canvas
	 */
	
	private function regenerateLayout() : Void {
		
		_bounds.setEmpty();
		_lineStops = [0];
		
		var lineStart : Int = 0;
		var wordStart : Int = 0;
		var lineLength : Float = 0;	
		var lineLengthToLastWord : Float = 0;
		var isFirstWord : Bool = true;
				
		trace("Starting layout", text.length, text);
		
		for ( i in 0...text.length ) {
			
			var char : CharacterData =  font.characters.get( text.charCodeAt(i) );
			if ( char == null ) char = new CharacterData( text.charCodeAt(i) );
			
			if ( char.id == 32 || char.id == 10 ) {
				wordStart = i + 1;
				isFirstWord = false;
				lineLengthToLastWord = lineLength;
				trace( "Found a space, setting word start to", i );
			}
			
			//Draw characters a line at a time
			if ( i == text.length - 1 ) {
				
				if ( char.id != 10 && ( wrapWidth == 0 || lineLength + char.xAdvance < wrapWidth ) ) {
					//drawLine( canvas, text.substring( lineStart ), y );
					_bounds.width = Math.max( _bounds.width, lineLength );
					trace( "Drawing last letter on existing line" );
				}else {
					_lineStops.push( wordStart );
					_bounds.width = Math.max( _bounds.width, lineLengthToLastWord );
					_bounds.width = Math.max( _bounds.width, lineLength - lineLengthToLastWord );
					trace( "Last letter pushed last word onto new line" );
				}
				
			}else if ( char.id != 10 && ( wrapWidth == 0 || (lineLength + char.xAdvance < wrapWidth) ) ) {
				// We will draw this line all together
				
				
				lineLength += char.xAdvance;
				trace("Line length is now " + lineLength );
				
			}else {
								
				trace( "Creating new line", wordStart, text.substring( wordStart ) );
						
				if ( !isFirstWord ) {
					_bounds.width = Math.max( _bounds.width, lineLengthToLastWord );
					lineStart = wordStart;
					lineLength = lineLength - lineLengthToLastWord;
					_lineStops.push( wordStart );
				}else {
					lineStart = i;
					_bounds.width = Math.max( _bounds.width, lineLength );
					lineLength = 0;
					_lineStops.push( i );
				}
				
				if ( char.id != 10 ) {
					wordStart = i;
				}else {
					wordStart = i + 1;
				}
				isFirstWord = true;
			}
		}
		
		_bounds.height = _lineStops.length * font.lineHeight;
		_dirty = false;
		
		trace("Final calculation", _lineStops, _bounds );
		
	}
			
	override public function render(canvas:ICanvas):Void 
	{

		// TODO: render to texture for easy caching
		if ( _dirty ) regenerateLayout();
				
		var lineStart : Int = 0;
		var wordStart : Int = 0;
		var lineLength : Float = 0;	
		var y = 0;
		
		//trace("Drawing", _lineStops, _bounds );
		
		for ( i in 0..._lineStops.length ) {
			
			if ( i == _lineStops.length - 1 ) {
				drawLine( canvas, text.substring( _lineStops[i] ), i * font.lineHeight );
			}else {
				drawLine( canvas, text.substring( _lineStops[i], _lineStops[i+1] ), i * font.lineHeight );
			}
			
			//var char : CharacterData =  font.characters.get( text.charCodeAt(i) );
			//if ( char == null ) char = new CharacterData( text.charCodeAt(i) );
			//
			//if ( char.id == 32 ) wordStart = i + 1;
			////Draw characters a line at a time
			//if ( i == text.length - 1 ) {
				//
				//if ( ( wrapWidth == 0 || lineLength + char.xAdvance < wrapWidth ) ) {
					//drawLine( canvas, text.substring( lineStart ), y );
				//}else {
					//drawLine( canvas, text.substring( lineStart, wordStart - 1 ), y );
					//drawLine( canvas, text.substring( wordStart ), y + font.lineHeight );
				//}
			//}
			//if ( char.id != 10 && char.id != 13 && ( wrapWidth == 0 || lineLength + char.xAdvance < wrapWidth ) ) {
				//// We will draw this line all together
				//lineLength += font.characters.get( text.charCodeAt(i) ).xAdvance;
				//continue;
				//
			//}else {
				//// draw the line
				//drawLine( canvas, text.substring( lineStart, wordStart - 1 ), y );
				//lineStart = wordStart;
				//lineLength = 0;
				//y += font.lineHeight;
			//}
		}
	}
	
	private function drawLine( canvas : ICanvas, string : String, y : Float ) : Void {
	
		//trace("Drawing line of text ", string );
		
		var x : Float = 0;
		var prev_char : CharacterData = null;
		
		// First go through and get line length
		for ( i in 0...string.length ) {
			
			var char : CharacterData =  font.characters.get( string.charCodeAt(i) );
			if ( char != null ) {
				
				var kerning : KerningData = null;
				if ( prev_char != null && font.kernings.get( prev_char.id ) != null ) {
					kerning = font.kernings.get( prev_char.id ).get( char.id );
					if ( kerning != null ) x -= kerning.amount;
				}
				x += char.xAdvance;
			}
			prev_char = char;				 
		}
		
		switch( align ) {
			case TextAlign.Left:
				x = 0;
			case TextAlign.Center:
				x = (wrapWidth - x) * 0.5;
			case TextAlign.Right:
				x = wrapWidth - x;
		}
		
		prev_char = null;
		
		// TODO: align this line to the left, right or center
		for ( i in 0...string.length ) {
			
			var char : CharacterData =  font.characters.get( string.charCodeAt(i) );
			if ( char != null ) {
				
				var kerning : KerningData = null;
				if ( prev_char != null && font.kernings.get( prev_char.id ) != null ) {
					kerning = font.kernings.get( prev_char.id ).get( char.id );
				}
				
				var texture : TextureData = font.pages[ char.pageId ];
				var m : Matrix4 = renderTransform.clone();
				if ( kerning != null ) {
					m.prependTranslation( x + char.xOffset + kerning.amount, y + char.yOffset, 0 );
				}else {
					m.prependTranslation( x + char.xOffset, y + char.yOffset, 0 );
				}
				
				canvas.drawSubImage( texture, 
									 new Rectangle( 
										char.x / texture.sourceImage.width, 
										char.y / texture.sourceImage.width, 
										char.width / texture.sourceImage.width,
										char.height / texture.sourceImage.height
									 ), m, getShader(), color.r, color.g, color.b, color.a * getFinalAlpha() );
									 
				x += char.xAdvance;
			}
			
			prev_char = char;
								 
		}
		
	}
	
	
	/**
	 * Sets the font color
	 * @return
	 */
	
	public function setColor( color : Int ) : TextSprite {
		this.color = color;
		_dirty = true;
		return this;
	}
	
	/**
	 * Sets the font
	 * @return
	 */
	
	public function setFont( font : BitmapFont ) : TextSprite {
		this.font = font;
		_dirty = true;
		return this;
	}
	
	public function set_text( text : String ) : String {
		// Make all new lines the same
		var old_text : String = this.text;
		this.text = StringTools.replace( text, "\r\n", "\n" );
		this.text = StringTools.replace( this.text, "\r", "\n" );
		if ( old_text != text ) _dirty = true;
		return this.text;
	}
	
	public function setAlign( align : TextAlign ) : TextSprite {
		this.align = align;
		_dirty = true;
		return this;
	}
	
	public function setText( text : String ) : TextSprite {
		this.text = text;
		_dirty = true;
		return this;
	}	
	
	/**
	 * Sizes
	 * @return
	 */
	
	override public function getNaturalWidth() : Float 
	{
		if ( _dirty ) regenerateLayout();
		return _bounds.width;
	}
	
	override public function getNaturalHeight() : Float 
	{
		if ( _dirty ) regenerateLayout();
		return _bounds.height;
	}
	
}