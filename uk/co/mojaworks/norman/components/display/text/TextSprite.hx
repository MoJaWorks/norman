package uk.co.mojaworks.norman.components.display.text ;
import lime.graphics.Font;
import lime.graphics.TextFormat;
import uk.co.mojaworks.norman.components.renderer.ICanvas;
import uk.co.mojaworks.norman.components.renderer.Renderer;
import uk.co.mojaworks.norman.components.renderer.TextureData;
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
	public var textureData : TextureData;
	
	public var align( default, null ) : TextAlign = TextAlign.Left;
	public var font( default, null ) : Font = "Arial";
	public var text( default, null ) : String = "";
	public var wrapWidth( default, null ) : Float = 0;
		
	// colour multipliers
	public var color( default, default ) : Color;
	
	public function new( text : String, width : Int = 200, height : Int = 200 ) 
	{
		super();
			
		isRenderable = true;
		
		color = 0xFFFFFFFF;
		
		textField = new TextField();
		setText( text );
		setSize( width, height );
		updateTextFormat();
		canvas = new BitmapData( width, height, true, 0x00FFFFFF );
	}
	
	override public function onAdded():Void 
	{
		super.onAdded();
		build();
	}
	
	override public function onRemoved():Void 
	{
		super.onRemoved();
		if ( textureData != null ) root.get(Renderer).textureManager.unloadTexture( textureData.id );
	}
		
	private function build() : Void {
		
		if ( gameObject != null ) {
			canvas.fillRect( canvas.rect, 0x00FFFFFF );
			canvas.draw( textField, new Matrix(), null, null, null, true );
			textureData = root.get(Renderer).textureManager.loadBitmap( "text/" + gameObject.id, canvas );
		}
	
	}
	
	override public function render(canvas:ICanvas):Void 
	{
		super.render(canvas);
		canvas.drawImage( textureData, gameObject.transform.renderTransform, color.a * getFinalAlpha(), color.r, color.g, color.b );
	}
	
	override public function getNaturalWidth() : Float 
	{
		return width;
	}
	
	override public function getNaturalHeight() : Float 
	{
		return height;
	}
	
	public function setColor( color : Int ) : TextSprite {
		this.color = color;
		return this;
	}
		
	/**
	 * SETTERS
	 */
	
	public function setFontSize( fontSize : Int ) : TextSprite {
		if ( fontSize != this.fontSize ) {
			this.fontSize = fontSize;
			updateTextFormat();
			build();
		}
		return this;
	}
	
	public function setAlign( align : TextAlign ) : TextSprite {
		if ( align != this.align ) {
			this.align = align;
			updateTextFormat();
			build();
		}
		return this;
	}
	
	public function setFont( font : String ) : TextSprite {
		
		if ( font != this.font ) {
			this.font = font;
			updateTextFormat();
			build();
		}
		return this;
	}

	public function setText( text : String ) : TextSprite {
		
		if ( text != this.text ) {
			this.text = text;
			textField.text = text;
			build();
		}
		return this;
	}
	

	
	private function updateTextFormat() : Void {
		var format : TextFormat = new TextFormat( font, fontSize, 0xFFFFFF, bold, italic, underline, null, null, align );
		textField.defaultTextFormat = format;
		textField.setTextFormat( format );
	}
	
	
	
}