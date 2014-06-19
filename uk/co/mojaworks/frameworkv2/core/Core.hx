package uk.co.mojaworks.frameworkv2.core ;
import openfl.display.Stage;
import uk.co.mojaworks.frameworkv2.core.IModule;
import uk.co.mojaworks.frameworkv2.common.modules.director.Director;

/**
 * ...
 * @author Simon
 */
class Core
{

	public static var instance( default, null ) : Core = null;
	
	var _modules : Map<String, IModule>;
	
	public var stage( default, null ) : Stage;
		
	public function new( ) 
	{
		_modules = new Map<String, IModule>();
	}
	
	public static function init( stage : Stage ) : Void {
		instance = new Core( );
		instance.stage = stage;
	}
	
	@:generic public function get<T>( classType : Class<T> ) : T {
		return cast _modules.get( Type.getClassName( classType ) );
	}
	
	public function add( object : IModule ) : Void {
		_modules.set( Type.getClassName(Type.getClass(object)), object );
	}
	
}