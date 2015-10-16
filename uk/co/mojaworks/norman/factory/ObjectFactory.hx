package uk.co.mojaworks.norman.factory;
import uk.co.mojaworks.norman.components.EventDispatcher;
import uk.co.mojaworks.norman.components.Transform;
import uk.co.mojaworks.norman.systems.Systems;

/**
 * ...
 * @author Simon
 */
class ObjectFactory
{
	
	private static var autoId : Int = 0;
	
	public function new() 
	{
		
	}
	
	public static function createGameObject( id : String = null ) : GameObject {
		
		if ( id == null ) id = "NormanObject" + (autoId++);
		
		// All objects need a transform and event dispastcher
		// The rest is up to individual objects
		var gameObject : GameObject = new GameObject( id );
		gameObject.addComponent( new Transform() );
		gameObject.addComponent( new EventDispatcher() );
				
		return gameObject;
	}
	
}