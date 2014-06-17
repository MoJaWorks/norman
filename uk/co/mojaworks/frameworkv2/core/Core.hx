package uk.co.mojaworks.frameworkv2.core;
import openfl.display.Stage;

/**
 * ...
 * @author Simon
 */
class Core
{

	public static var instance( default, null ) : Core = null;
	
	var _modules : Map<String, Module>;
		
	public function new( stage : Stage ) 
	{
		_modules = new Map<String, Module>();
	}
	
	public static function init( stage : Stage ) : Void {
		instance = new Core( stage );
	}
	
	@:generic function get<T>( classType : Class<T> ) : T {
		return cast ( _modules.get( Type.getClassName( classType ) ) );
	}
	
	function add( object : Module ) : Void {
		_modules.set( Type.getClassName(Type.getClass(object)), object );
	}
	
}