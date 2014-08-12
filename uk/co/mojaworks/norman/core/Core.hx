package uk.co.mojaworks.norman.core ;
import openfl.display.Stage;
import uk.co.mojaworks.norman.engine.NormanApp;

/**
 * ...
 * @author Simon
 */
class Core
{

	public static var instance( default, null ) : Core = null;
	
	public var app( default, null ) : NormanApp;
	public var stage( default, null ) : Stage;
	public var root( default, null ) : GameObject;
	public var gameObjectManager( default, null ) : GameObjectManager;
	
	public function new( ) 
	{
	}
	
	public static function init( app : NormanApp, stage : Stage ) : Void {
		instance = new Core( );
		instance.app = app;
		instance.stage = stage;
		instance.gameObjectManager = new GameObjectManager();
		instance.root = new GameObject();
	}
	
	
	
}