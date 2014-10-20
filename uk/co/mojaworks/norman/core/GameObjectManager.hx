package uk.co.mojaworks.norman.core;

/**
 * ...
 * @author Simon
 */
class GameObjectManager
{

	var _objects : Array<GameObject>;
	
	public function new() 
	{
		_objects = [];
	}
	
	public function registerGameObject( object : GameObject ) : Void {
		_objects.push( object );
	}
	
	public function unregisterGameObject( object : GameObject ) : Void {
		_objects.remove( object );
	}
	
	public function findGameObjectWithId( id : String ) : GameObject {
		for ( object in _objects ) {
			if ( object.id == id ) return object;
		}
		return null;
	}
	
	public function findGameObjectThatHas( classType : Class<Component> ) : GameObject {
		for ( object in _objects ) {
			if ( object.has( classType ) ) return object;
		}
		return null;
	}
	
	public function findGameObjectsThatHave( classType : Class<Component> ) : Array<GameObject> {
		var result : Array<GameObject> = [];
		for ( object in _objects ) {
			if ( object.has( classType ) ) result.push( object );
		}
		return result;
	}
		
}