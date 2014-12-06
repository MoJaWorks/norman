package uk.co.mojaworks.norman.components.display.text ;
import lime.math.Matrix3;
import lime.math.Matrix4;
import lime.math.Rectangle;
import uk.co.mojaworks.norman.components.display.text.BitmapFont;
import uk.co.mojaworks.norman.systems.renderer.ICanvas;
import uk.co.mojaworks.norman.systems.renderer.shaders.DefaultImageFragmentShader;
import uk.co.mojaworks.norman.systems.renderer.shaders.DefaultImageVertexShader;
import uk.co.mojaworks.norman.systems.renderer.shaders.IShaderProgram;
import uk.co.mojaworks.norman.systems.renderer.ITextureData;
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
 
class TextSprite extends RenderSprite
{
	// Get access to formatting through layout
	public var text( default, set ) : String = "";
	
	// config
	public var font( default, default ) : BitmapFont;
	public var align( default, default ) : TextAlign;
	public var wrapType( default, default ) : WrapType;
	public var wrapWidth( default, default ) : Float;
	public var cacheAsBitmap( default, set ) : Bool = true;
	
	// results
	private var _lineStops : Array<Int>;
	private var _bounds : Rectangle;
		
	//var _fontTextures : Array<ITextureData>;
	var _layoutDirty : Bool = true;
	
	public function new( ) 
	{
		super();
		color = 0xFFFFFFFF;
		wrapWidth = 0;
		align = TextAlign.Left;
		wrapType = WrapType.Auto;
		_bounds = new Rectangle();
	}
	
	/**
	 * 
	 */
	
	override public function getShader():IShaderProgram 
	{
		return ImageSprite.shader;
	}
	
	/**
	 * Add/remove
	 */
	
	override public function onAdded():Void 
	{
		super.onAdded();
		_layoutDirty = true;
	}
	
	override public function onRemoved():Void 
	{
		super.onRemoved();
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
			if ( previousCharacter != null && font.kernings.get( previousCharacter.id ) != null ) {
				kerning = font.kernings.get( previousCharacter.id ).get( char.id );
				if ( kerning != null ) currentX -= kerning.amount;
			}
			
			if ( char.id == 32 ) {
				// Check for a space - this marks the start of a new word
				wordStart = i + 1;
				isFirstWord = false;
				lineLengthToLastWord = lineLength;
				currentX += char.xAdvance;
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
				currentX += char.xAdvance;
				lineLength = currentX;
				previousCharacter = char;
				
			}else {
				// Couldn't fit it on the line	
				
				if ( isFirstWord || wrapType == WrapType.Letter ) {
					// This is the first word on the line should we split it?
					wordStart = i;
					lineLengthToLastWord = lineLength;
					lineLength = char.xAdvance;
				}else {
					// Carry letters onto next line and don't count the space between them
					lineLength -= lineLengthToLastWord - char.xAdvance;
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
		_bounds.height = (_lineStops.length) * font.lineHeight;
		_lineStops.push( text.length );
		_layoutDirty = false;
		setSize( Math.max(_bounds.width, 1), Math.max(_bounds.height, 1) );
		
	}
			
	
	override public function preRender(canvas:ICanvas):Bool 
	{
		
		if ( _layoutDirty ) regenerateLayout();
		if ( cacheAsBitmap ) {
			return super.preRender(canvas);
		}else {
			return visible && getFinalAlpha() > 0;
		}
		
	}
	
	override public function render(canvas:ICanvas):Void 
	{
		if ( _dirty ) {
		
			var lineStart : Int = 0;
			var wordStart : Int = 0;
			var lineLength : Float = 0;	
			var y = 0;
			
			for ( i in 0..._lineStops.length - 1 ) {
				drawLine( canvas, text.substring( _lineStops[i], _lineStops[i+1] ), i * font.lineHeight );
			}
			
		}
		
	}
	
	override public function postRender(canvas:ICanvas):Void 
	{
		if ( cacheAsBitmap ) {
			super.postRender(canvas);
		}
	}
	
	private function drawLine( canvas : ICanvas, string : String, y : Float ) : Void {
	
		string = StringTools.rtrim( string );
		
		var x : Float = 0;
		var padding : Float = 0;
		var prev_char : CharacterData = null;
		var m : Matrix3 = new Matrix3();
		var kerning : KerningData;
		
		// First go through and get line length
		for ( i in 0...string.length ) {
			
			var char : CharacterData =  font.characters.get( string.charCodeAt(i) );
			if ( char != null ) {
				
				kerning = null;
				if ( prev_char != null && font.kernings.get( prev_char.id ) != null ) {
					kerning = font.kernings.get( prev_char.id ).get( char.id );
					if ( kerning != null ) x -= kerning.amount;
				}
				x += char.xAdvance;
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
				if ( prev_char != null && font.kernings.get( prev_char.id ) != null ) {
					kerning = font.kernings.get( prev_char.id ).get( char.id );
					if ( kerning != null ) x -= kerning.amount;
				}
				
				var texture : ITextureData = font.pages[ char.pageId ];
				m.identity();
				m.translate( x + char.xOffset, y + char.yOffset );
				if ( !cacheAsBitmap ) m.concat( renderTransform );
				
				// Dont bother drawing spaces and new lines
				if ( char.id != 10 && char.id != 32 ) {
					
					canvas.drawSubImage( texture, 
										 new Rectangle( 
											char.x / texture.width, 
											char.y / texture.width, 
											char.width / texture.width,
											char.height / texture.height
										 ), m, getShader(), color.r, color.g, color.b, color.a * getFinalAlpha() );
				}
									 
				x += char.xAdvance + padding;
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
		_layoutDirty = true;
		return this;
	}
	
	public function set_text( text : String ) : String {
		// Make all new lines the same
		var old_text : String = this.text;
		this.text = StringTools.replace( text, "\r\n", "\n" );
		this.text = StringTools.replace( this.text, "\r", "\n" );
		if ( old_text != text ) {
			_dirty = true;
			_layoutDirty = true;
		}
		return this.text;
	}
	
	public function setAlign( align : TextAlign ) : TextSprite {
		this.align = align;
		_dirty = true;
		_layoutDirty = true;
		return this;
	}
	
	public function setText( text : String ) : TextSprite {
		this.text = text;
		_dirty = true;
		_layoutDirty = true;
		return this;
	}	
	
	public function set_cacheAsBitmap( bool : Bool ) : Bool {
		cacheAsBitmap = bool;
		gameObject.transform.isRoot = bool;
		return bool;
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