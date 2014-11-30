package uk.co.mojaworks.norman.systems.renderer ;
import lime.graphics.RenderContext;
import lime.math.Matrix4;
import lime.math.Rectangle;
import uk.co.mojaworks.norman.systems.renderer.shaders.IShaderProgram;
import uk.co.mojaworks.norman.systems.renderer.ITextureData;
import uk.co.mojaworks.norman.utils.Color;

/**
 * @author Simon
 */

interface ICanvas 
{
	// Setup
	function resize( width : Int, height : Int ) : Void;
	
	// Drawing
	function clear( r : Int = 0, g : Int = 0, b : Int = 0, a : Float = 1 ) : Void;
	function begin() : Void;
	function fillRect( r : Float, g : Float, b : Float, a : Float, width : Float, height : Float, transform : Matrix4, shader : IShaderProgram ) : Void;
	function drawImage( texture : ITextureData, transform:Matrix4, shader : IShaderProgram, r : Float = 255, g : Float = 255, b : Float = 255, a : Float = 1 ) : Void;
	function drawSubImage( texture : ITextureData, sourceRect:Rectangle, transform:Matrix4, shader : IShaderProgram, r : Float = 255, g : Float = 255, b : Float = 255, a : Float = 1 ) : Void;
	function complete() : Void;
	
	// Render to texture
	function pushRenderTarget( target : ITextureData ) : Void;
	function popRenderTarget() : Void;
}