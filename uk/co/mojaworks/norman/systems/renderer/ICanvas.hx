package uk.co.mojaworks.norman.systems.renderer;
import lime.math.Matrix3;
import lime.math.Rectangle;
import uk.co.mojaworks.norman.utils.Color;

/**
 * @author test
 */

interface ICanvas 
{

	public function begin() : Void;
	public function end() : Void;
	
	public function resize() : Void;
	public function fillRect( color : Color, transform : Matrix3, shaderId : String = "defaultFill" ) : Void;
	//public function drawTexture( textureId : String, transform : Matrix3, shaderId : String ="defaultImage", subtexture : Rectangle = null, color : Color = Color.WHITE );
	
}