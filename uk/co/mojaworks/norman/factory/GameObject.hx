package uk.co.mojaworks.norman.factory;
import uk.co.mojaworks.norman.components.Component;
import uk.co.mojaworks.norman.components.delegates.BaseUIDelegate;
import uk.co.mojaworks.norman.components.delegates.BaseViewDelegate;
import uk.co.mojaworks.norman.components.EventDispatcher;
import uk.co.mojaworks.norman.components.renderer.AbstractRenderer;
import uk.co.mojaworks.norman.components.Transform;
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
		
	var components : LinkedList<Component>;
	
	@:allow( uk.co.mojaworks.norman.factory.ObjectFactory )
	private function new( id : String )
	{
		this.id = id;
		components = new LinkedList<Component>();
	}
		
	public function getComponent( type : String ) : Component {
		for ( component in components ) {
			if ( component.getComponentType() == type || component.getBaseComponentType() == type ) return component;
		}
		return null;
	}
	
	public function addComponent( component : Component ) : Void {
		component.gameObject = this;
		component.onAdded();
		components.push( component );
	}
	
	public function removeComponent( component : Component ) : Void {
		component.onRemove();
		components.remove( component );
	}
		
	public function removeAllComponentsOfType( type : String ) : Void {
		for ( component in components ) {
			if ( component.getComponentType() == type || component.getBaseComponentType() == type ) {
				component.onRemove();
				components.remove( component );
			}
		}
	}
	
	public function destroy( ) : Void {
		for ( component in components ) {
			component.onRemove();
			component.destroy();
		}
		components = null;
	}
	
	public function getAllComponentsOfType( type : String ) : Array<Component> 
	{
		var result : Array<Component> = [];
		for ( component in components ) {
			if ( component.getComponentType() == type || component.getBaseComponentType() == type ) result.push( component );
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