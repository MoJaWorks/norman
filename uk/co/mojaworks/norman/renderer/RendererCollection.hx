package uk.co.mojaworks.norman.renderer;

import uk.co.mojaworks.norman.components.display.Sprite;
import uk.co.mojaworks.norman.core.GameObject;
import uk.co.mojaworks.norman.core.GameObjectCollection;

/**
 * ...
 * @author Simon
 */
class RendererCollection extends GameObjectCollection
{

	public function new() 
	{
		super();
	}
	
	override public function onGameObjectUpdated(object:GameObject):Void 
	{
		super.onGameObjectUpdated(object);
		
		if ( object.has(Sprite) && object.get(Sprite).isRenderable ) {
			if ( !_objects.contains( object ) ) _objects.push( object );
			sortObjects();
		}else {
			// No point testing if we should remove as that means going through them twice
			_objects.remove( object );
		}
	}
	
	override public function onGameObjectRemoved(object:GameObject):Void 
	{
		super.onGameObjectRemoved(object);
		if ( object.has(Sprite) && object.get(Sprite).isRenderable ) _objects.remove( object );
	}
	
	private function sortObjects() : Void {
		// TODO: Sort the display game objects
	}
	
}