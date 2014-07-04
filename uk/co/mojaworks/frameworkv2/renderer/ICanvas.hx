package uk.co.mojaworks.frameworkv2.renderer;
import openfl.display.DisplayObject;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import uk.co.mojaworks.frameworkv2.core.GameObject;
import uk.co.mojaworks.frameworkv2.renderer.TextureData;

/**
 * @author Simon
 */

interface ICanvas 
{
	function getDisplayObject() : DisplayObject;
	function init( rect : Rectangle ) : Void;
	function resize( rect : Rectangle ) : Void;
	function render( root : GameObject) : Void;
	
	// Drawing functions
	function fillRect( red : Float, green : Float, blue : Float, alpha : Float, width : Float, height : Float, transform : Matrix ) : Void;
	function drawImage(texture:TextureData, transform:Matrix, alpha:Float, red:Float, green:Float, blue:Float):Void;
	function drawSubImage(texture:TextureData, sourceRect:Rectangle, transform:Matrix, alpha:Float, red:Float, green:Float, blue:Float):Void;
}