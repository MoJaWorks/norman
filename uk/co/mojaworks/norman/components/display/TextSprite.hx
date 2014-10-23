package uk.co.mojaworks.norman.components.display;
import openfl.display.BitmapData;
import openfl.geom.Matrix;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import uk.co.mojaworks.norman.components.renderer.ICanvas;
import uk.co.mojaworks.norman.components.renderer.Renderer;
import uk.co.mojaworks.norman.components.renderer.TextureData;
import uk.co.mojaworks.norman.utils.Color;

/**
 * ...
 * @author Simon
 */
class TextSprite extends Sprite
{

	public var textureData : TextureData;
	
	// when updated draw textfield onto canvas
	var textField : TextField;
	var canvas : BitmapData;
	
	public var width( default, null ) : Int;
	public var height( default, null ) : Int;
	public var bold( default, null ) : Bool = false;
	public var italic( default, null ) : Bool = false;
	public var underline( default, null ) : Bool = false;
	#if flash
	public var align( default, null ) : TextFormatAlign = TextFormatAlign.LEFT;
	#else
	public var align( default, null ) : String = TextFormatAlign.LEFT;
	#end
	public var fontSize( default, null ) : Int = 12;
	public var font( default, null ) : String = "Arial";
	public var text( default, null ) : String = "";
		
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
	
	public function setBold( bold : Bool ) : TextSprite {
		if ( bold != this.bold ) {
			this.bold = bold;
			updateTextFormat();
			build();
		}
		return this;
	}
	
	public function setItalic( italic : Bool ) : TextSprite {
		if ( italic != this.italic ) {
			this.italic = italic;
			updateTextFormat();
			build();
		}
		return this;
	}
	
	public function setUnderline( underline : Bool ) : TextSprite {
		if ( underline != this.underline ) {
			this.underline = underline;
			updateTextFormat();
			build();
		}
		return this;
	}
	
	public function setFontSize( fontSize : Int ) : TextSprite {
		if ( fontSize != this.fontSize ) {
			this.fontSize = fontSize;
			updateTextFormat();
			build();
		}
		return this;
	}
	
	#if flash
	public function setAlign( align : TextFormatAlign ) : TextSprite {
	#else
	public function setAlign( align : String ) : TextSprite {
	#end
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
	
	public function setWidth( width : Int ) : TextSprite {
		this.width = width;
		textField.width = width;
		canvas = new BitmapData( width, height, true, 0x00FFFFFF );
		build();
		return this;
	}
	
	public function setHeight( height : Int ) : TextSprite {
		this.height = height;
		textField.height = height;
		canvas = new BitmapData( width, height, true, 0x00FFFFFF );
		build();
		return this;
	}
	
	public function setSize( width : Int, height : Int ) : TextSprite {
		this.width = width;
		this.height = height;
		textField.width = width;
		textField.height = height;
		canvas = new BitmapData( width, height, true, 0x00FFFFFF );
		build();
		return this;
	}
	
	private function updateTextFormat() : Void {
		var format : TextFormat = new TextFormat( font, fontSize, 0xFFFFFF, bold, italic, underline, null, null, align );
		textField.defaultTextFormat = format;
		textField.setTextFormat( format );
	}
	
	
	
}