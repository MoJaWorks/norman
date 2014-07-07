package uk.co.mojaworks.frameworkv2.core;
import uk.co.mojaworks.frameworkv2.components.display.Display;
import uk.co.mojaworks.frameworkv2.components.messenger.Messenger;
import uk.co.mojaworks.frameworkv2.components.Transform;

/**
 * ...
 * @author Simon
 */
class GameObject extends CoreObject
{
	public static inline var CHILD_ADDED : String = "CHILD_ADDED";
	public static inline var CHILD_REMOVED : String = "CHILD_REMOVED";
	static public inline var ADDED_AS_CHILD : String = "ADDED_AS_CHILD";
	static public inline var REMOVED_AS_CHILD : String = "REMOVED_AS_CHILD";
	
	// Children of an object are affected by their parent and are destroyed along with their parent
	public var parent( default, null ) : GameObject;
	public var children(default, null ) : Array<GameObject>;
	
	// Components
	var _components : Map<String, Component>;
	
	public var transform( default, null ) : Transform;
	public var messenger( default, null ) : Messenger;
	
	// Display is not set by default and will be null until a display component is added
	public var display( default, null ) : Display;
	
	public function new() 
	{
		super();
		
		_components = new Map<String, Component>();
		children = [];
		parent = null;
		
		init();
		
	}
	
	function init() : Void {
				
		messenger = new Messenger();
		add( messenger );
		
		transform = new Transform();
		add( transform );
		
	}
	
	
	
	/**
	 * Children
	 */
	
	public function addChild( object : GameObject ) : Void {
		
		if ( object.parent != null ) object.parent.removeChild( object );
		object.parent = this;
		children.push( object );
		
		messenger.sendMessage( CHILD_ADDED, object );
		object.messenger.sendMessage( ADDED_AS_CHILD, object );
	}
	
	public function removeChild( object : GameObject ) : Void {
		
		if ( object.parent == this ) {
			children.remove( object );
			object.parent = null;
			messenger.sendMessage( CHILD_REMOVED, object );
			object.messenger.sendMessage(REMOVED_AS_CHILD, object );
		}
	}
	
	/**
	 * Components
	 */
	
	@:generic public function get<T:(Component)>( classType : Class<T> ) : T {
		return cast _components.get( Reflect.field( classType, "TYPE" ) );
	}
	
	@:generic public function removeByType<T:(Component)>( classType : Class<T> ) : GameObject {
		var type : String = Reflect.field( classType, "TYPE" );
		if ( type == Display.TYPE ) this.display = null;
		_components.remove( type );
		return this; 
	}
	
	@:generic public function add<T:(Component)>( component : T ) : GameObject {
		_components.set( component.getComponentType(), component );
		if ( component.getComponentType() == Display.TYPE ) this.display = cast component;
		component.gameObject = this;
		component.onAdded( );
		return this;
	}
	
	public function remove( component : Component ) : GameObject {
		_components.remove( component.getComponentType() );
		if ( component.getComponentType() == Display.TYPE ) this.display = null;
		component.gameObject = null;
		return this;
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