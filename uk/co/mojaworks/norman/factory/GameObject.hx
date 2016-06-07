package uk.co.mojaworks.norman.factory;
import geoff.utils.LinkedList;
import uk.co.mojaworks.norman.components.IComponent;
import uk.co.mojaworks.norman.components.Transform;
import uk.co.mojaworks.norman.components.renderer.BaseRenderer;

/**
 * GameObject is nothing more than a bag of components
 * ...
 * @author Simon
 */
class GameObject implements IDisposable
{
	private static var autoId : Int = 0;
	
	public var id( default, null ) : Int;
	public var name( default, default ) : String;
	public var destroyed : Bool = false;
	public var enabled( default, set ) : Bool = true;
	
	// Quick access
	public var transform( default, null ) : Transform = null;
	public var renderer( default, null ) : BaseRenderer = null;
		
	var components : LinkedList<IComponent>;
	
	@:allow( uk.co.mojaworks.norman.factory.ObjectFactory )
	private function new( name : String )
	{
		this.id = autoId++;
		this.name = name;
		components = new LinkedList<IComponent>();
	}
	
	public function get( type : String ) : IComponent
	{
		for ( component in components ) 
		{
			if ( component.is( type ) ) return component;
		}
		
		return null;
	}
		
	public function add( component : IComponent ) : IComponent {
		component.gameObject = this;
		components.push( component );
		
		// Replace quick access types
		if ( component.is( BaseRenderer.Type ) )
		{
			this.renderer = cast component;
		}
		else if ( component.is( Transform.Type ) )
		{
			this.transform = cast component;
		}
		
		component.onAdded();
		return component;
	}
	
	public function remove( component : IComponent, destroyAfter : Bool = true ) : Void {
		component.onRemove();
		components.remove( component );
		component.gameObject = null;
		
		if ( component == this.renderer )
		{
			this.renderer = BaseRenderer.getFrom( this );
		}
		else if ( component == this.transform )
		{
			this.transform = Transform.getFrom( this );
		}
		
		if ( destroyAfter ) component.destroy();
	}
		
	public function removeAllOf( type : String, destroyAfter : Bool = true ) : Void
	{
		//var existing : T = null;
	
		for ( component in components ) 
		{
			//existing = cast component;
			if ( component.is( type ) ) remove( component, destroyAfter );
		}
	}
	
	public function removeAll( destroyAfter : Bool = true ) : Void 
	{
		for ( component in components ) 
		{
			remove( component, destroyAfter );
		}
	}
	
	public function destroy( ) : Void {
						
		if ( !destroyed ) {
			
			for ( child in transform.children ) {
				child.gameObject.destroy();
			}
			
			destroyed = true;
			
			for ( component in components ) {
				remove( component, true );
			}
			
			components = null;
			transform = null;
			renderer = null;
		}
		
	}
		
	
	public function isEnabled() : Bool {
		
		if ( enabled && transform.parent != null ) {
			return transform.parent.gameObject.isEnabled();
		}else {
			return enabled;
		}
	}
	
	public function set_enabled( bool : Bool ) : Bool {
		return this.enabled = bool;
	}
	
}