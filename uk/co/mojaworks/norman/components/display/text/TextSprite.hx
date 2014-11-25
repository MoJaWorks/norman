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
	//public var lineLengths( default, null ) : Array<Float>;
	//public var bounds( default, null ) : Rectangle;
		
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
			
	override public function render(canvas:ICanvas):Void 
	{

		// TODO: render to texture for easy caching
				
		var lineStart : Int = 0;
		var lineLength : Float = 0;	
		var y = 0;
		
		
		for ( i in 0...text.length ) {
			
			var char : CharacterData =  font.characters.get( text.charCodeAt(i) );
			if ( char == null ) char = new CharacterData( text.charCodeAt(i) );
			
			//Draw characters a line at a time
			if ( char.id != 10 && char.id != 13 && ( wrapWidth == 0 || lineLength + char.xAdvance < wrapWidth ) && i < text.length - 1 ) {
				// We will draw this line all together
				lineLength += font.characters.get( text.charCodeAt(i) ).xAdvance;
				continue;
			}else {
				// draw the line
				drawLine( canvas, text.substring( lineStart, i+1 ), y );
				lineStart = i;
				y += font.lineHeight;
			}
		}
	}
	
	private function drawLine( canvas : ICanvas, string : String, y : Float ) : Void {
	
		//trace("Drawing line of text ", string );
		
		var x : Float = 0;
		var prev_char : CharacterData = null;
		
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
	 * Gets the width of the text after layout
	 * @return
	 */
	
	override public function getNaturalWidth() : Float 
	{
		return 0;
	}
	
	/**
	 * Gets the height of the text after layout
	 * @return
	 */
	
	override public function getNaturalHeight() : Float 
	{
		return 0;
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
		this.text = StringTools.replace( text, "\r\n", "\n" );
		this.text = StringTools.replace( this.text, "\r", "\n" );
		return this.text;
	}
	//public function setAlign( align : TextAlign ) : TextSprite {
		//this.align = align;
		//_dirty = true;
		//return this;
	//}
	//
	//public function setText( text : String ) : TextSprite {
		//this.text = text;
		//_dirty = true;
		//return this;
	//}	
	
}