package uk.co.mojaworks.norman.components.display;
import uk.co.mojaworks.norman.engine.NormanApp;
import uk.co.mojaworks.norman.systems.renderer.ICanvas;
import uk.co.mojaworks.norman.systems.renderer.shaders.DefaultFillFragmentShader;
import uk.co.mojaworks.norman.systems.renderer.shaders.DefaultFillVertexShader;
import uk.co.mojaworks.norman.systems.renderer.shaders.IShaderProgram;
import uk.co.mojaworks.norman.utils.Color;

/**
 * ...
 * @author Simon
 */
class FillSprite extends Sprite
{

	public static var shaderProgram : IShaderProgram;
	
	public var color( default, default ) : Color;
	public var width( default, default ) : Float;
	public var height( default, default ) : Float;
	
	public function new( color : Int, width : Float = 100, height : Float = 100 ) 
	{
		
		super();
		isRenderable = true;
		this.color = color;
		this.width = width;
		this.height = height;
	}
	
	override public function initShader() : Void {
		if ( shaderProgram == null ) {
			shaderProgram = NormanApp.renderer.createShader( new DefaultFillVertexShader(), new DefaultFillFragmentShader() );
		}
	}
	
	override public function getShader():IShaderProgram 
	{
		return shaderProgram;
	}
	
	public function setSize( width : Float, height : Float ) : FillSprite {
		this.width = width;
		this.height = height;
		return this;
	}
	
	public function setColor( color : Int ) : FillSprite {
		this.color = color;
		return this;
	}
	
	override public function getNaturalWidth() : Float {
		return width;
	}
	
	override public function getNaturalHeight() : Float {
		return height;
	}
	
	override public function render( canvas : ICanvas ) : Void {
		canvas.fillRect( color.r, color.g, color.b, getFinalAlpha() * color.a, width, height, gameObject.transform.worldTransform );
	}
	
	
	
	
}