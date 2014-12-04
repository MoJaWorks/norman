package uk.co.mojaworks.norman.components.display;
import lime.math.Matrix3;
import lime.math.Matrix4;
import uk.co.mojaworks.norman.core.Core;
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

	public static var shader(get,null) : IShaderProgram = null;
	
	public var color( default, default ) : Color;
	public var width( default, default ) : Float;
	public var height( default, default ) : Float;
	
	public function new( color : Int, width : Float = 100, height : Float = 100 ) 
	{
		
		super( );
		this.color = color;
		this.width = width;
		this.height = height;
	}
	
	/**
	 * Shader
	 * @return
	 */
	
	private static function get_shader() : IShaderProgram {
		if ( FillSprite.shader == null ) {
			#if gl_debug trace( "Compiling FillSprite shader" ); #end
			FillSprite.shader = Core.getInstance().app.renderer.createShader( new DefaultFillVertexShader(), new DefaultFillFragmentShader() );
		}
		return FillSprite.shader;
	}
	
	override public function getShader():IShaderProgram 
	{
		return shader;
	}
	
	/**
	 * 
	 * @param	width
	 * @param	height
	 * @return
	 */
	
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
		canvas.fillRect( color.r, color.g, color.b, getFinalAlpha() * color.a, width, height, renderTransform, getShader() );
	}
	
	
	
	
}