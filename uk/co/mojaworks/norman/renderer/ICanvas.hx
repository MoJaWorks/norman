package uk.co.mojaworks.norman.renderer;
import lime.math.Matrix3;
import lime.math.Rectangle;
import uk.co.mojaworks.norman.core.GameObject;
import uk.co.mojaworks.norman.renderer.ITextureData;

/**
 * @author Simon
 */

interface ICanvas 
{
	function init( rect : Rectangle ) : Void;
	function resize( rect : Rectangle ) : Void;
	function render( root : GameObject) : Void;
	
	// Drawing functions
	function fillRect( red : Float, green : Float, blue : Float, alpha : Float, width : Float, height : Float, transform : Matrix3 ) : Void;
	function drawImage(texture:ITextureData, transform:Matrix3, alpha:Float = 1, red : Float = 255, green : Float = 255, blue : Float = 255):Void;
	function drawSubImage(texture:ITextureData, sourceRect:Rectangle, transform:Matrix3, alpha:Float = 1, red : Float = 255, green : Float = 255, blue : Float = 255):Void;
	
	// Mask
	//function pushMask( rect : Rectangle, transform : Matrix ) : Void;
	//function popMask() : Void;
}