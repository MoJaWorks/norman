/****
* 
****/

package flash.display;
import flash.display3D.Context3DProfile;
import flash.display3D.Context3DRenderMode;

#if (flash || display)
@:require(flash11) extern class Stage3D extends flash.events.EventDispatcher {
	var context3D(default,null) : flash.display3D.Context3D;
	var visible : Bool;
	var x : Float;
	var y : Float;
	function requestContext3D(?context3DRenderMode : Context3DRenderMode, ?profile : Context3DProfile ) : Void;
}
#end