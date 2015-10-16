package uk.co.mojaworks.norman.systems.components ;
import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * ...
 * @author Simon
 */
class ComponentSystem
{

	var components : Map<String, LinkedList<Component>>;
	
	public function new() 
	{
		components = new Map<String ,LinkedList<Component>>();
	}
	
	/*public function clearEntity( entityId : String ) : Void {
		for ( componentTypeList in components ) {
			for ( component in componentTypeList ) {
				if ( entityId == component.entityId ) componentTypeList.remove( component );
			}
		}
	}
	
	public function getComponent( entityId : String, type : String ) : Component {
		if ( components.exists( type ) ) {
			for ( component in components.get(type) ) {
				if ( entityId == component.entityId ) return component;
			}
		}
		return null;
	}
	
	public function addComponent( entityId : String, component : Component ) : Void {
		component.entityId = entityId;
		
		if ( !components.exists( component.type ) ) components.set( component.type, new LinkedList<Component>() );
		components.get(component.type ).push( component );
	}
	
	public function removeComponent( entityId : String, type : String ) : Void {
		
		var list : LinkedList<Component> = components.get(type);
		if ( list != null ) {
			for ( component in list ) {
				if ( entityId == component.entityId ) list.remove( component );
			}
		}
	}
	
	public function clear( ) : Void {
		for ( componentList in components ) {
			componentList.clear();
		}
		components = null;
	}
	
	public function getAllComponentsOfType( type : String ) : Array<Component> 
	{
		var result : Array<Component> = [];
		if ( components.exists( type ) ) {
			for ( component in components.get( type ) ) {
				result.push( component );
			}
		}
		return result;
	}*/
	
}