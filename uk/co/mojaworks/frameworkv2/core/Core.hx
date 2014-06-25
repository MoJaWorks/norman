package uk.co.mojaworks.frameworkv2.core ;
import openfl.display.Stage;
import uk.co.mojaworks.frameworkv2.components.director.Director;
import uk.co.mojaworks.frameworkv2.core.Viewport;

/**
 * ...
 * @author Simon
 */
class Core
{

	public static var instance( default, null ) : Core = null;
	
	public var stage( default, null ) : Stage;
	public var root( default, null ) : GameObject;
	public var viewport( default, null ) : Viewport;
	
	public function new( ) 
	{
		root = new GameObject();
		viewport = new Viewport();
	}
	
	public static function init( stage : Stage, gameWidth : Int, gameHeight : Int ) : Void {
		instance = new Core( );
		instance.stage = stage;
		instance.viewport.init( gameWidth, gameHeight );
	}
	
	
	
}