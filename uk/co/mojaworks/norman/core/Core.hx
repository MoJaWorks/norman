package uk.co.mojaworks.norman.core ;
import openfl.display.Stage;

/**
 * ...
 * @author Simon
 */
class Core
{

	public static var instance( default, null ) : Core = null;
	
	public var stage( default, null ) : Stage;
	public var root( default, null ) : GameObject;
	
	public function new( ) 
	{
		root = new GameObject();
	}
	
	public static function init( stage : Stage ) : Void {
		instance = new Core( );
		instance.stage = stage;
	}
	
	
	
}