package uk.co.mojaworks.frameworkv2.core;
import uk.co.mojaworks.frameworkv2.components.messenger.Messenger;
import uk.co.mojaworks.frameworkv2.components.display.Display;
import uk.co.mojaworks.frameworkv2.components.Transform;

/**
 * ...
 * @author Simon
 */
class GameObject extends CoreObject
{
	public static inline var CHILD_ADDED : String = "CHILD_ADDED";
	public static inline var CHILD_REMOVED : String = "CHILD_REMOVED";
	
	// Children of an object are affected by their parent and are destroyed along with their parent
	public var parent( default, null ) : GameObject;
	public var children(default, null ) : Array<GameObject>;
	
	// Components
	var _components : Map<String, Component>;
	
	public var transform : Transform;
	public var messenger : Messenger;
	
	public function new() 
	{
		super();
		
		_components = new Map<String, Component>();
		children = [];
		parent = null;
		
		init();
		
	}
	
	function init() : Void {
		
		transform = new Transform();
		add( transform );
		
		messenger = new Messenger();
		add( messenger );
		
	}
	
	
	
	/**
	 * Children
	 */
	
	public function addChild( object : GameObject ) : Void {
		
		if ( object.parent != null ) object.parent.removeChild( object );
		object.parent = this;
		children.push( object );
		
		messenger.sendMessage( CHILD_ADDED, object );
	}
	
	public function removeChild( object : GameObject ) : Void {
		
		if ( object.parent == this ) {
			children.remove( object );
			object.parent = null;
			messenger.sendMessage( CHILD_REMOVED, object );
		}
	}
	
	/**
	 * Components
	 */
	
	@:generic public function get<T:(Component)>( classType : Class<T> ) : T {
		return cast _components.get( Reflect.field( classType, "TYPE" ) );
	}
	
	@:generic public function removeByType<T:(Component)>( classType : Class<T> ) : T {
		return cast _components.remove( Reflect.field( classType, "TYPE" ) );
	}
	
	@:generic public function add<T:(Component)>( component : T ) : T {
		_components.set( component.getComponentType(), component );
		component.gameObject = this;
		component.onAdded( );
		return cast component;
	}
	
	public function remove( component : Component ) : Void {
		_components.remove( component.getComponentType() );
		component.gameObject = null;
	}
	
	@:generic public function has<T:(Component)>( classType : Class<T> ) : Bool {
		return ( _components.get( Reflect.field( classType, "TYPE" ) ) != null );
	}
	
	/**
	 * 
	 */
	
	public function destroy() : Void {
		
	}
		
}