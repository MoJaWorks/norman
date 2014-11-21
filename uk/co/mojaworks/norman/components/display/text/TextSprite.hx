package uk.co.mojaworks.norman.components.display.text ;
import lime.graphics.Font;
import lime.graphics.TextFormat;
import lime.math.Rectangle;
import uk.co.mojaworks.norman.components.display.text.BitmapFont;
import uk.co.mojaworks.norman.components.display.text.layout.TextFormat;
import uk.co.mojaworks.norman.components.display.text.layout.TextFormat.TextAlign;
import uk.co.mojaworks.norman.systems.renderer.ICanvas;
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
	// Get access to formatting through layout
	public var text( default, null ) : String = "";
	
	// config
	public var color( default, default ) : Color;
	public var font( default, default ) : BitmapFont;
	public var align( default, default ) : TextAlign;
	public var wrapWidth( default, default ) : Float;
	
	// results
	public var lineLengths( default, null ) : Array<Float>;
	public var bounds( default, null ) : Rectangle;
		
	// Draws onto this texture constantly re-uses it
	var _textureData : TextureData;
	var _fontTextures : Array<TextureData>;
	
	var _dirty : Bool;
	
	public function new( ) 
	{
		super();
		color = 0xFFFFFFFF;
	}
	
	/**
	 * Add/remove
	 */
	
	override public function onAdded():Void 
	{
		super.onAdded();
		
		if ( _textureData = null ) {
			_textureData = core.app.renderer.createTexture( "@norman_fonts/" + gameObject.id, 300, 300 );
		}
		
		_dirty = true;
	}
	
	override public function onRemoved():Void 
	{
		super.onRemoved();
		if ( _textureData != null ) core.app.renderer.destroyTexture( "@norman_fonts/" + gameObject.id );
	}
	
	
	private function rebuild() : Void {
		_layout.rebuild( _fontData, text, align, wrapWidth );
	}
	
	
	/**
	 * Render
	 * @param	canvas
	 */
			
	override public function render(canvas:ICanvas):Void 
	{

		if ( _dirty ) {
		
			var lineStart : Int;
			var lineEnd : Int;
			var lineLength : Float;		
			
			for ( i in 0...text.length ) {
				//TODO: Draw characters a line at a time
				//TODO: Set render texture to textureData
			}
		
			_dirty = false;
		}
		
		canvas.drawImage( _textureData, gameObject.transform.renderTransform, color.a * getFinalAlpha(), color.r, color.g, color.b );
	}
	
	/**
	 * Gets the width of the text after layout
	 * @return
	 */
	
	override public function getNaturalWidth() : Float 
	{
		return width;
	}
	
	/**
	 * Gets the height of the text after layout
	 * @return
	 */
	
	override public function getNaturalHeight() : Float 
	{
		return height;
	}
	
	/**
	 * Sets the font color
	 * @return
	 */
	
	//public function setColor( color : Int ) : TextSprite {
		//this.color = color;
		//_dirty = true;
		//return this;
	//}
	
	/**
	 * Sets the font
	 * @return
	 */
	
	//public function setFont( font : Font ) : TextSprite {
		//this._font = font;
		//this._fontData = _font.decompose();
		//_dirty = true;
		//return this;
	//}
		//
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