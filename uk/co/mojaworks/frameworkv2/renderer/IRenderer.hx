package uk.co.mojaworks.frameworkv2.renderer;
import openfl.display.DisplayObject;
import openfl.geom.Rectangle;
import uk.co.mojaworks.frameworkv2.core.GameObject;

/**
 * @author Simon
 */

interface IRenderer 
{		
	function init( rect : Rectangle ) : Void;
	function render( root : GameObject ) : Void;
	function getCanvas() : DisplayObject;
	function resize( rect : Rectangle ) : Void;
}