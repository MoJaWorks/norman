package uk.co.mojaworks.frameworkv2.renderer;
import openfl.display.DisplayObject;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import uk.co.mojaworks.frameworkv2.core.GameObject;

/**
 * @author Simon
 */

interface ICanvas 
{
	function getDisplayObject() : DisplayObject;
	public function init( rect : Rectangle ) : Void;
	public function resize( rect : Rectangle ) : Void;
	public function render( root : GameObject) : Void;
	
	// Drawing functions
	public function fillRect( red : Float, green : Float, blue : Float, alpha : Float, width : Float, height : Float, transform : Matrix ) : Void;
	public function drawImage( textureId : String, transform : Matrix, alpha : Float ) : Void;
	public function drawSubImage( textureId : String, subImageId : String, transform : Matrix, alpha : Float ) : Void;
}