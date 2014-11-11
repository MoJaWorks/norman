package uk.co.mojaworks.norman.systems.renderer ;
import lime.graphics.RenderContext;
import lime.math.Matrix4;
import lime.math.Rectangle;
import uk.co.mojaworks.norman.systems.renderer.TextureData;

/**
 * @author Simon
 */

interface ICanvas 
{
	// Gets
	function getContext() : RenderContext;
	function getRenderTarget() : TextureData;
	
	// Setup
	function init( context : RenderContext ) : Void;
	function resize( width : Int, height : Int ) : Void;
	
	// Drawing
	function clear() : Void;
	function fillRect( red : Float, green : Float, blue : Float, alpha : Float, width : Float, height : Float, transform : Matrix4 ) : Void;
	function drawImage( texture : TextureData, transform:Matrix4, alpha:Float = 1, red : Float = 255, green : Float = 255, blue : Float = 255) : Void;
	function drawSubImage( texture : TextureData, sourceRect:Rectangle, transform:Matrix4, alpha:Float = 1, red : Float = 255, green : Float = 255, blue : Float = 255) : Void;
	
}