package uk.co.mojaworks.norman.factory;
import uk.co.mojaworks.norman.components.EventDispatcher;
import uk.co.mojaworks.norman.components.renderer.AbstractRenderer;
import uk.co.mojaworks.norman.components.Transform;
import uk.co.mojaworks.norman.systems.components.Component;
import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * GameObject is nothing more than a bag of components
 * ...
 * @author Simon
 */
class GameObject
{
	public var id( default, null ) : String;
	
	// Quick access
	public var transform( get, never ) : Transform;
	public var eventDispatcher( get, never ) : EventDispatcher;
	public var renderer( get, never ) : AbstractRenderer;
		
	var components : Map<String, LinkedList<Component>>;
	
	@:allow( uk.co.mojaworks.norman.factory.ObjectFactory )
	private function new( id : String )
	{
		this.id = id;
		components = new Map<String, LinkedList<Component>>();
	}
		
	public function getComponent( type : String ) : Component {
		if ( components.exists( type ) ) {
			return components.get(type).get( 0 );
		}
		return null;
	}
	
	public function addComponent( component : Component ) : Void {
		
		component.gameObject = this;
		
		if ( !components.exists( component.type ) ) components.set( component.type, new LinkedList<Component>() );
		components.get( component.type ).push( component );
		
	}
	
	public function removeComponent( entityId : String, type : String ) : Void {
		
		components.remove( type );
		
	}
	
	public function destroy( ) : Void {
		for ( componentList in components ) {
			for ( component in componentList ) {
				component.destroy();
			}
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
	}
	
	
	/**
	 * Quick access
	 */
	
	private function get_transform() : Transform {
		return cast getComponent( Transform.TYPE );
	}
	
	private function get_eventDispatcher() : EventDispatcher {
		return cast getComponent( EventDispatcher.TYPE );
	}
	
	private function get_renderer() : AbstractRenderer {
		return cast getComponent( AbstractRenderer.TYPE );
	}
	
}