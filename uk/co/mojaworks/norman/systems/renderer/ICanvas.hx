package uk.co.mojaworks.norman.systems.renderer ;
import lime.graphics.RenderContext;
import lime.math.Matrix3;
import lime.math.Rectangle;
import uk.co.mojaworks.norman.core.GameObject;
import uk.co.mojaworks.norman.systems.renderer.TextureData;

/**
 * @author Simon
 */

interface ICanvas 
{
	function init( context : RenderContext ) : Void;
	function resize( width : Int, height : Int ) : Void;
	function render( root : GameObject, camera : GameObject ) : Void;
	
	// Drawing functions
	function fillRect( red : Float, green : Float, blue : Float, alpha : Float, width : Float, height : Float, transform : Matrix3 ) : Void;
	function drawImage(texture:TextureData, transform:Matrix3, alpha:Float = 1, red : Float = 255, green : Float = 255, blue : Float = 255):Void;
	function drawSubImage(texture:TextureData, sourceRect:Rectangle, transform:Matrix3, alpha:Float = 1, red : Float = 255, green : Float = 255, blue : Float = 255):Void;
	
	// Mask
	//function pushMask( rect : Rectangle, transform : Matrix ) : Void;
	//function popMask() : Void;
}