package uk.co.mojaworks.norman.components.display.text ;
import lime.graphics.Font;
import lime.graphics.TextFormat;
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
	// Draws onto this texture constantly re-uses it
	public var align( default, null ) : TextAlign = TextAlign.Left;
	public var text( default, null ) : String = "";
	public var wrapWidth( default, null ) : Float = 0;
		
	// colour multipliers
	public var color( default, default ) : Color;
	
	var _textureData : TextureData;
	var _font : Font;
	var _fontData : NativeFontData;
	var _dirty : Bool;
	var _layout : TextLayout;
	
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
		
		if ( textureData = null ) {
			_textureData = core.app.renderer.createTexture( "norman_fonts/" + gameObject.id, 300, 300 );
		}
		
		_dirty = true;
	}
	
	override public function onRemoved():Void 
	{
		super.onRemoved();
		if ( textureData != null ) core.app.renderer.destroyTexture( "norman_fonts/" + gameObject.id );
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
		super.render(canvas);
		canvas.drawImage( textureData, gameObject.transform.renderTransform, color.a * getFinalAlpha(), color.r, color.g, color.b );
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
	
	public function setColor( color : Int ) : TextSprite {
		this.color = color;
		_dirty = true;
		return this;
	}
	
	/**
	 * Sets the font
	 * @return
	 */
	
	public function setFont( font : Font ) : TextSprite {
		this._font = font;
		this._fontData = _font.decompose();
		_dirty = true;
		return this;
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
	
}