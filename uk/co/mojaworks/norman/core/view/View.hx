package uk.co.mojaworks.norman.core.view;

/**
 * ...
 * @author Simon
 */
class View
{

	private var _gameObjects : Map<String,GameObject>;
	
	public function new() 
	{
		_gameObjects = new Map<String,GameObject>();
	}
	
	public function registerObject( object : GameObject, id : String ) : Void {
		#if debug
			if ( _gameObjects.get( id ) != null ) trace("Overwriting GameObject with Id", id, "in view");
		#end
		
		_gameObjects.set( id, object );
	}
	
	public function getObject( id : String ) : GameObject {
		return _gameObjects.get( id );
	}
	
	public function removeObject( id : String ) : Void {
		_gameObjects.remove( id );
	}
	
}