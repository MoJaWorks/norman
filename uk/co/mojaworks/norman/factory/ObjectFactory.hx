package uk.co.mojaworks.norman.factory;
import uk.co.mojaworks.norman.components.Transform;

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
		gameObject.add( new Transform() );
				
		return gameObject;
	}
	
}