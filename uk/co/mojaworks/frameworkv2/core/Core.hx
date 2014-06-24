package uk.co.mojaworks.frameworkv2.core ;
import openfl.display.Stage;

/**
 * ...
 * @author Simon
 */
class Core
{

	public static var instance( default, null ) : Core = null;
	public var stage( default, null ) : Stage;
	
	//TODO: Add viewport as sprite
	//TODO: Add director
		
	public function new( ) 
	{
	}
	
	public static function init( stage : Stage ) : Void {
		instance = new Core( );
		instance.stage = stage;
	}
	
	
	
}