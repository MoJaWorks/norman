package uk.co.mojaworks.norman.core;
import uk.co.mojaworks.norman.components.display.Display;
import uk.co.mojaworks.norman.components.messenger.Messenger;
import uk.co.mojaworks.norman.components.Prefab;
import uk.co.mojaworks.norman.components.Transform;

/**
 * ...
 * @author Simon
 */
class GameObject extends RootObject
{
	public static inline var CHILD_ADDED : String = "CHILD_ADDED";
	public static inline var CHILD_REMOVED : String = "CHILD_REMOVED";
	static public inline var ADDED_AS_CHILD : String = "ADDED_AS_CHILD";
	static public inline var REMOVED_AS_CHILD : String = "REMOVED_AS_CHILD";
	
	// Used to generate automatic Ids
	private static var nextId : Int = 0;
	
	// Children of an object are affected by their parent and are destroyed along with their parent
	public var id( default, null) : String = "";
	public var parent( default, null ) : GameObject;
	public var children( default, null ) : Array<GameObject>;
	public var childIndex( default, null ) : Int;
	
	// Components
	var _components : Map<String, Component>;
	public var transform( default, null ) : Transform;
	public var messenger( default, null ) : Messenger;
	public var display( default, null ) : Display; // Display is not set by default and will be null until a display component is added
	
	public var enabled : Bool = true;
	public var destroyed : Bool = false;
	
	public function new( id : String = null ) 
	{
		super();
		
		// Initialise state
		this.id = (id != null) ? id : (""+(nextId++));
		_components = new Map<String, Component>();
		children = [];
		parent = null;
				
		// Add default components
		messenger = new Messenger();
		add( messenger );
		
		transform = new Transform();
		add( transform );
		
		// Register with system
		if ( root != null ) root.gameObjectManager.registerGameObject( this );
		
	}
	
	
	
	/**
	 * Children
	 */
	
	public function addChild( object : GameObject, at : Int = -1) : Void {
		
		if ( object.parent != null ) object.parent.removeChild( object );
		object.parent = this;
		object.childIndex = children.length;
		
		if ( at == -1 || at >= children.length ) {
			children.push( object );
		}else {
			children.insert( at, object );
			regenerateChildrenSortOrder();
		}
		
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
	
	public function setChildIndex( object : GameObject, to : Int ) : Void {
		children.remove( object );
		
		if ( to == -1 || to >= children.length ) {
			children.push( object );
		}else{
			children.insert( to, object );
		}
		
		regenerateChildrenSortOrder();
	}
	
	public function getChildSortString() : String {
		if ( parent != null ) {
			return parent.getChildSortString() + ":" + StringTools.lpad( Std.string( childIndex ), "0", Std.string(parent.children.length).length );
		}else {
			return Std.string( childIndex );
		}
	}
	
	private function regenerateChildrenSortOrder() : Void {
		var i : Int = 0;
		for ( child in children ) {
			child.childIndex = i++;
		}
	}
	
	/**
	 * Components
	 */
	
	public function get<T:(Component)>( classType : Class<T> ) : T {
		if ( has( cast classType ) ) return cast _components.get( Reflect.field( classType, "TYPE" ));
		else return null;
	}
	
	public function removeByType( classType : Class<Component> ) : GameObject {
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
	
	public function add( component : Component ) : GameObject {
		
		// Make sure to remove it from any other gameobject it's attached to
		if ( component.gameObject != null ) component.gameObject.removeById( component.getComponentType() );
		
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
	
	public function has( classType : Class<Component> ) : Bool {
		return Std.is( _components.get( Reflect.field( classType, "TYPE" )), classType );
	}
	
	/**
	 * Search
	 */
	
	public function findParentThatHas( classType : Class<Component> ) : GameObject {
		
		var current = parent;
		
		while ( current != null ) {
			if ( current.has( classType ) ) return current;
			else current = current.parent;
		}
		
		return null;
		
	}
	 
	public function findChildThatHas( classType : Class<Component>, depth : Int = -1 ) : GameObject {
		
		var current_depth = 1;
		var children : Array<GameObject> = this.children;
		var next_children : Array<GameObject> = [];
		
		while( (current_depth <= depth || depth == -1) && children.length > 0 ) {
		
			for ( child in children ) {
				if ( child.has( classType ) ) return child;
				
				if ( current_depth < depth || depth == -1 ) {
					next_children = next_children.concat( child.children );
				}
			}
			
			children = next_children;
			next_children = [];
			current_depth++;
			
		}
		return null;
	}
	
	public function findChildrenThatHave( classType : Class<Component>, depth : Int = -1 ) : Array<GameObject> {
		
		var result : Array<GameObject> = [];
		
		var current_depth = 1;
		var children : Array<GameObject> = this.children;
		var next_children : Array<GameObject> = [];
		
		while ( (current_depth <= depth || depth == -1) && children.length > 0 ) {
					
			for ( child in children ) {
				
				trace("Checking ", child.id );
				
				if ( child.has( classType ) ) result.push( child );
				
				if ( current_depth < depth || depth == -1 ) {
					next_children = next_children.concat( child.children );
				}
			}
			
			children = next_children;
			next_children = [];
			current_depth++;
			
		}
		
		trace("Quit searching", current_depth, depth, children.length );
		
		return result;
	}
	
	
	/**
	 * Does nothing special at this moment in time - just added for future use (and it looks more readable)
	 */
		
	public function buildFrom( prefab : Prefab ) : GameObject {
		add( prefab );
		return this;
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
		
		root.gameObjectManager.unregisterGameObject( this );
		_components = null;
		children = null;
		
	}
		
}