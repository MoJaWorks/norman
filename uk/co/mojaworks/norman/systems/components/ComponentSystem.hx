package uk.co.mojaworks.norman.systems.components ;
import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * ...
 * @author Simon
 */
class ComponentSystem
{

	var components : LinkedList<Component>;
	
	public function new() 
	{
		components = new LinkedList<Component>();
	}
	
	public function clearEntity( entityId : String ) : Void {
		for ( component in components ) {
			if ( entityId == component.entityId ) components.remove( component );
		}
	}
	
	public function getComponent( entityId : String, type : String ) : Component {
		for ( component in components ) {
			if ( entityId == component.entityId && type == component.type ) return component;
		}
		return null;
	}
	
	public function addComponent( entityId : String, component : Component ) : Void {
		component.entityId = entityId;
		components.push( component );
	}
	
	public function removeComponent( entityId : String, type : String ) : Void {
		for ( component in components ) {
			if ( entityId == component.entityId && type == component.type ) components.remove( component );
		}
	}
	
	public function clear( ) : Void {
		components.clear();
	}
	
	public function getAllComponentsOfType( type : String ) : Array<Component> 
	{
		var result : Array<Component> = [];
		for ( component in components ) {
			if ( component.type == type ) {
				result.push( component );
			}
		}
		return result;
	}
	
}