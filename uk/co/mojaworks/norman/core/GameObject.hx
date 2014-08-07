package uk.co.mojaworks.norman.core;
import uk.co.mojaworks.norman.components.display.Display;
import uk.co.mojaworks.norman.components.messenger.Messenger;
import uk.co.mojaworks.norman.components.Transform;

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
	
	private static var objectCount : Int = 0;
	
	// Children of an object are affected by their parent and are destroyed along with their parent
	public var parent( default, null ) : GameObject;
	public var children(default, null ) : Array<GameObject>;
	
	// Components
	var _components : Map<String, Component>;
	
	public var transform( default, null ) : Transform;
	public var messenger( default, null ) : Messenger;
	
	// Display is not set by default and will be null until a display component is added
	public var display( default, null ) : Display;
	public var id( default, null) : Int = 0;
	
	public var enabled : Bool = true;
	public var destroyed : Bool = false;
	
	public function new() 
	{
		super();
		
		_components = new Map<String, Component>();
		children = [];
		parent = null;
		
		id = objectCount++;
		
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
			messenger.sendMessage( CHILD_REMOVED, object );
			object.messenger.sendMessage( REMOVED_AS_CHILD, object );
			
			// Let the object remove any references/listeners before removing the parent reference
			object.parent = null;
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
		return removeById( type ); 
	}
	
	public function remove( component : Component ) : GameObject {
		return removeById( component.getComponentType() );
	}
	
	public function removeById( type : String ) : GameObject {
		
		// Check for any special types
		if ( type == Display.TYPE ) this.display = null;
		
		// remove it from the list if it exists
		var component : Component = _components.get( type );
		if ( component != null ) {
			component.onRemoved();
			component.gameObject = null;
			_components.remove( type );
		}
		
		return this; 
	}
	
	@:generic public function add<T:(Component)>( component : T ) : GameObject {
		
		// Remove any existing components of this type
		removeById( component.getComponentType() );
		
		// Add it to the list
		_components.set( component.getComponentType(), component );
		
		// Check for any special types
		if ( component.getComponentType() == Display.TYPE ) this.display = cast component;
		
		// Tell the component it has been added
		component.gameObject = this;
		component.onAdded( );
		return this;
	}
	
	@:generic public function has<T:(Component)>( classType : Class<T> ) : Bool {
		return ( _components.get( Reflect.field( classType, "TYPE" ) ) != null );
	}
	
	/**
	 * Search
	 */
	
	@:generic public function findAncestorThatHas<T:(Component)>( classType : Class<T> ) : GameObject {
		if ( parent == null || parent.has( classType ) ) {
			return parent;
		}else {
			return parent.findAncestorThatHas( classType );
		}
	}
	
	@:generic public function findChildThatHas<T:(Component)>( classType : Class<T> ) : GameObject {
		for ( child in children ) {
			if ( child.has( classType ) ) return child;
		}
		return null;
	}
	
	@:generic public function findChildrenThatHave<T:(Component)>( classType : Class<T> ) : Array<GameObject> {
		var result : Array<GameObject> = [];
		for ( child in children ) {
			if ( child.has( classType ) ) result.push(child);
		}
		return result;
	}
	
	@:generic public function findDescendantThatHas<T:(Component)>( classType : Class<T> ) : GameObject {
		
		var result : GameObject = null;
		
		for ( child in children ) {
			if ( child.has( classType ) ) {
				return child;
			}else {
				result = child.findAncestorThatHas( classType );
				if ( result != null ) return result;
			}
		}
		
		return null;
	}
	
	@:generic public function findDescendantsThatHave<T:(Component)>( classType : Class<T> ) : Array<GameObject> {
		var result : Array<GameObject> = [];
		for ( child in children ) {
			if ( child.has( classType ) ) result.push(child);
			result = result.concat( child.findDescendantsThatHave( classType ) );
		}
		return result;
	}
	
	
	/**
	 * End
	 */
	
	public function destroy() : Void {
		
		for ( child in children ) {
			child.destroy();
		}
		
		for ( cid in _components.keys() ) {
			var comp : Component = _components.get( cid );
			comp.onRemoved();
			destroy();			
		}
		
		_components = null;
		children = null;
		
	}
		
}