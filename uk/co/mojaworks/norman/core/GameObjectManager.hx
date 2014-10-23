package uk.co.mojaworks.norman.core;
import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * ...
 * @author Simon
 */
class GameObjectManager
{

	var _objects : LinkedList<GameObject>;
	var _collections : LinkedList<GameObjectCollection>;
	
	public function new() 
	{
		_objects = new LinkedList<GameObject>();
		_collections = new LinkedList<GameObjectCollection>();
	}
	
	/**
	 * GameObjects
	 */
	
	public function registerGameObject( object : GameObject ) : Void {
		_objects.push( object );
		for ( collection in _collections ) {
			collection.onGameObjectAdded( object );
		}
	}
	
	public function gameObjectUpdated( object : GameObject ) : Void {
		for ( collection in _collections ) {
			collection.onGameObjectUpdated( object );
		}
	}
	
	public function unregisterGameObject( object : GameObject ) : Void {
		_objects.remove( object );
		for ( collection in _collections ) {
			collection.onGameObjectRemoved( object );
		}
	}
	
	/**
	 * Searching
	 */
	
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
	
	/**
	 * Collections
	 */
	
	public function addCollection( collection : GameObjectCollection ) : Void {
		_collections.push( collection );
	}
	
	public function removeCollection( collection : GameObjectCollection ) : Void {
		_collections.remove( collection );
	}
		
}