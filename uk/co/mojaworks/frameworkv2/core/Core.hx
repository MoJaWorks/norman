package uk.co.mojaworks.frameworkv2.core ;
import openfl.display.OpenGLView;
import openfl.display.Stage;
import uk.co.mojaworks.frameworkv2.components.director.Director;

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