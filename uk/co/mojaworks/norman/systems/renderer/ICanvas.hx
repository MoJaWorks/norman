package uk.co.mojaworks.norman.systems.renderer ;
import lime.graphics.RenderContext;
import lime.math.Matrix4;
import lime.math.Rectangle;
import uk.co.mojaworks.norman.systems.renderer.shaders.IShaderProgram;
import uk.co.mojaworks.norman.systems.renderer.TextureData;
import uk.co.mojaworks.norman.utils.Color;

/**
 * @author Simon
 */

interface ICanvas 
{
	// Gets
	function getContext() : RenderContext;
	
	// Setup
	function init( context : RenderContext ) : Void;
	function resize( width : Int, height : Int ) : Void;
	
	// Drawing
	function clear() : Void;
	function begin() : Void;
	function fillRect( color : Color, width : Float, height : Float, transform : Matrix4, shader : IShaderProgram ) : Void;
	function drawImage( texture : TextureData, transform:Matrix4, color : Color, shader : IShaderProgram ) : Void;
	function drawSubImage( texture : TextureData, sourceRect:Rectangle, transform:Matrix4, color : Color, shader : IShaderProgram ) : Void;
	function complete() : Void;
}