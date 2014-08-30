package uk.co.mojaworks.norman.core ;
import openfl.display.Stage;
import uk.co.mojaworks.norman.components.director.Director;
import uk.co.mojaworks.norman.components.input.Input;
import uk.co.mojaworks.norman.components.renderer.Renderer;

/**
 * ...
 * @author Simon
 */
class Root extends GameObject
{
	public static var instance( default, null ) : Root = null;
	
	public var stage( default, null ) : Stage;
	public var gameObjectManager( default, null ) : GameObjectManager;
	
	public function new( ) 
	{
		// Must make sure this exists before instantiating
		gameObjectManager = new GameObjectManager();
		super();
	}
	
	public static function init( stage : Stage ) : Void {
		instance = new Root( );
		instance.stage = stage;
	}
	
}