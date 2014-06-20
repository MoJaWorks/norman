package uk.co.mojaworks.frameworkv2.common.engine ;
import openfl.display.DisplayObject;

/**
 * ...
 * @author Simon
 */
interface IGameObject
{

	function init() : Void;
	function destroy() : Void;
	function step( seconds : Float ) : Void;
	
}