package flash.display;
import flash.display3D.Context3D;

#if ( flash || display ) 

import flash.events.EventDispatcher;

/**
 * ...
 * @author Simon
 */
extern class Stage3D extends EventDispatcher {
	public var context3D : Context3D;
	public var visible : Bool;
	public var x : Float;
	public var y : Float;
	
	public function requestContext3D( renderMode : String = "auto", profile : String = "baseline" ) : Void;
}

#end
