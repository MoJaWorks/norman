package uk.co.mojaworks.frameworkv2.renderer;
import openfl.display.DisplayObject;
import openfl.geom.Rectangle;

/**
 * @author Simon
 */

interface IRenderer 
{		
	function init( rect : Rectangle ) : Void;
	function render() : Void;
	function getCanvas() : DisplayObject;
	function resize( rect : Rectangle ) : Void;
}