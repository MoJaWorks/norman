package uk.co.mojaworks.norman.components.display;
import openfl.display.BitmapData;
import openfl.geom.Matrix;
import openfl.text.TextField;
import openfl.text.TextFormat;
import uk.co.mojaworks.norman.renderer.ICanvas;
import uk.co.mojaworks.norman.renderer.TextureData;
import uk.co.mojaworks.norman.utils.ColourUtils;

/**
 * ...
 * @author Simon
 */
class Text extends Display
{

	public var width( default, null ) : Int;
	public var height( default, null ) : Int;
	
	// when updated draw textfield onto canvas
	var textField : TextField;
	var canvas : BitmapData;
	
	public var text( get, set ) : String;
	
	public var textureData : TextureData;
	
	// colour multipliers
	public var r : Float = 1;
	public var g : Float = 1;
	public var b : Float = 1;
	public var a : Float = 1;
	
	public function new( text : String, width : Int = 200, height : Int = 200 ) 
	{
		super();
		textField = new TextField();
		textField.text = text;
		textField.textColor = 0xFFFFFF;
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
		if ( textureData != null ) core.app.renderer.textureManager.unloadTexture( textureData.id );
	}
	
	private function get_text() : String {
		return textField.text;
	}
	
	private function set_text( text : String ) : String {
		textField.text = text;
		build();
		return text;
	}
	
	public function setWidth( width : Int ) : Text {
		this.width = width;
		textField.width = width;
		canvas = new BitmapData( width, height, true, 0x00FFFFFF );
		build();
		return this;
	}
	
	public function setHeight( height : Int ) : Text {
		this.height = height;
		textField.height = height;
		canvas = new BitmapData( width, height, true, 0x00FFFFFF );
		build();
		return this;
	}
	
	public function setSize( width : Int, height : Int ) : Text {
		this.width = width;
		this.height = height;
		textField.width = width;
		textField.height = height;
		canvas = new BitmapData( width, height, true, 0x00FFFFFF );
		build();
		return this;
	}
	
	public function setTextFormat( format : TextFormat ) : Text {
		textField.defaultTextFormat = format;
		textField.setTextFormat( format );
		build();
		return this;
	}
	
	private function build() : Void {
		
		canvas.fillRect( canvas.rect, 0x00FFFFFF );
		canvas.draw( textField, new Matrix(), null, null, null, true );
		
		textureData = core.app.renderer.textureManager.loadBitmap( "text/" + gameObject.id, canvas );
	
	}
	
	override public function render(canvas:ICanvas):Void 
	{
		super.render(canvas);
		canvas.drawImage( textureData, gameObject.transform.renderTransform, a * getFinalAlpha(), r, g, b );
	}
	
	override public function getNaturalWidth() : Float 
	{
		return width;
	}
	
	override public function getNaturalHeight() : Float 
	{
		return height;
	}
	
	public function setColour( colour : Int ) : Text {
		r = ColourUtils.r( colour );
		g = ColourUtils.g( colour );
		b = ColourUtils.b( colour );
		return this;
	}
	
	
	
}