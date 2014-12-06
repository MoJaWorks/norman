package uk.co.mojaworks.norman.systems.renderer ;
import lime.math.Matrix3;
import lime.math.Rectangle;
import uk.co.mojaworks.norman.systems.renderer.Constants.BlendFactor;
import uk.co.mojaworks.norman.systems.renderer.ITextureData;
import uk.co.mojaworks.norman.systems.renderer.shaders.IShaderProgram;

/**
 * @author Simon
 */

interface ICanvas 
{
	
	var sourceBlendFactor( default, null ) : BlendFactor;
	var destinationBlendFactor( default, null ) : BlendFactor;
	
	// Setup
	function resize( width : Int, height : Int ) : Void;
	
	// Drawing
	function clear( r : Int = 0, g : Int = 0, b : Int = 0, a : Float = 1 ) : Void;
	function begin() : Void;
	function fillRect( r : Float, g : Float, b : Float, a : Float, width : Float, height : Float, transform : Matrix3, shader : IShaderProgram ) : Void;
	function drawImage( texture : ITextureData, transform:Matrix3, shader : IShaderProgram, r : Float = 255, g : Float = 255, b : Float = 255, a : Float = 1 ) : Void;
	function drawSubImage( texture : ITextureData, sourceRect:Rectangle, transform:Matrix3, shader : IShaderProgram, r : Float = 255, g : Float = 255, b : Float = 255, a : Float = 1 ) : Void;
	function setBlendMode( sourceFactor : BlendFactor, destinationFactor : BlendFactor ) : Void;
	function complete() : Void;
	
	// Render to texture
	function pushRenderTarget( target : ITextureData ) : Void;
	function popRenderTarget() : Void;
}