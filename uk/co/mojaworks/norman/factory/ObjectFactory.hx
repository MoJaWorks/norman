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
	
	
	
	public function new() 
	{
		
	}
	
	public static function createGameObject( name : String = "" ) : GameObject {
		
		// All objects need a transform and event dispastcher
		// The rest is up to individual objects
		var gameObject : GameObject = new GameObject( name );
		gameObject.addComponent( new Transform() );
		gameObject.addComponent( new EventDispatcher() );
				
		return gameObject;
	}
	
}