package uk.co.mojaworks.frameworkv2.core;
import openfl.display.Stage;
import uk.co.mojaworks.frameworkv2.view.Director;

/**
 * ...
 * @author Simon
 */
class Core
{

	public static var instance( default, null ) : Core = null;
	
	var _modules : Map<String, Module>;
	
	public var stage( default, null ) : Stage;
		
	public function new( ) 
	{
		_modules = new Map<String, Module>();
	}
	
	public static function init( stage : Stage ) : Void {
		instance = new Core( );
		
		instance.stage = stage;
		instance.add( new Director( ) );
	}
	
	@:generic function get<T>( classType : Class<T> ) : T {
		return cast ( _modules.get( Type.getClassName( classType ) ) );
	}
	
	function add( object : Module ) : Void {
		_modules.set( Type.getClassName(Type.getClass(object)), object );
	}
	
}