package uk.co.mojaworks.norman.core;

import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * Is a collection of GameObjects that gets updated when a new one is added or a component is added/removed from an entity
 * Can also be triggered manually from individual GameObjects or en-mass from the GameObjectManager
 * ...
 * @author Simon
 */
class GameObjectCollection
{
	
	private var _objects : LinkedList<GameObject>;

	public function new() 
	{
		_objects = new LinkedList<GameObject>();
	}
	
	/**
	 * A GameObject has been added to the game. It will generally be empty and have no components at this stage
	 * @param	object
	 */
	public function onGameObjectAdded( object : GameObject ) : Void {
		
	}
	
	/**
	 * A GameObject has been updated - components have been added to the GameObject
	 * @param	object
	 */
	public function onGameObjectUpdated( object : GameObject ) : Void {
		
	}
	
	/**
	 * A GameObject has been removed from the game
	 * @param	object
	 */
	public function onGameObjectRemoved( object : GameObject ) : Void {
		
	}
	
}