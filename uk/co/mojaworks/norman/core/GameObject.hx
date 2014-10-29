package uk.co.mojaworks.norman.core;
import uk.co.mojaworks.norman.components.display.Sprite;
import uk.co.mojaworks.norman.components.messenger.Messenger;
import uk.co.mojaworks.norman.components.Prefab;
import uk.co.mojaworks.norman.components.Transform;
import uk.co.mojaworks.norman.engine.NormanApp;

/**
 * ...
 * @author Simon
 */
class GameObject
{
	// Used to generate automatic Ids
	private static var nextId : Int = 0;
	
	public var id( default, null) : String = "";
	
	// Components
	var _components : Map<String, Component>;
	public var transform( default, null ) : Transform;
	public var messenger( default, null ) : Messenger;
	public var sprite( default, null ) : Sprite; // Display is not set by default and will be null until a display component is added
	
	public var enabled : Bool = true;
	public var enabledInTree( get, never ) : Bool;
	public var destroyed : Bool = false;
	
	public function new( id : String = null ) 
	{		
		// Initialise state
		this.id = (id != null) ? id : (""+(nextId++));
		_components = new Map<String, Component>();
		
		// Add default components
		messenger = new Messenger();
		add( messenger );
		
		transform = new Transform();
		add( transform );
		
		// Register with system
		//if ( root != null ) {
			//root.gameObjectManager.registerGameObject( this );
			//transform.parent = root;
		//}
		NormanApp.gameObjectManager.registerGameObject(this);
		if ( NormanApp.root != null ) transform.parent = NormanApp.root.transform;
		
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
		if ( type == Sprite.TYPE ) this.sprite = null;
		
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
		if ( component.getComponentType() == Sprite.TYPE ) this.sprite = cast component;
		
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
	
	//public function findParentThatHas( classType : Class<Component> ) : GameObject {
		//
		//var current = parent;
		//
		//while ( current != null ) {
			//if ( current.has( classType ) ) return current;
			//else current = current.parent;
		//}
		//
		//return null;
		//
	//}
	 
	//public function findChildThatHas( classType : Class<Component>, depth : Int = -1 ) : GameObject {
		//
		//var current_depth = 1;
		//var children : Array<GameObject> = this.children;
		//var next_children : Array<GameObject> = [];
		//
		//while( (current_depth <= depth || depth == -1) && children.length > 0 ) {
		//
			//for ( child in children ) {
				//if ( child.has( classType ) ) return child;
				//
				//if ( current_depth < depth || depth == -1 ) {
					//next_children = next_children.concat( child.children );
				//}
			//}
			//
			//children = next_children;
			//next_children = [];
			//current_depth++;
			//
		//}
		//return null;
	//}
	
	//public function findChildrenThatHave( classType : Class<Component>, depth : Int = -1 ) : Array<GameObject> {
		//
		//var result : Array<GameObject> = [];
		//
		//var current_depth = 1;
		//var children : Array<GameObject> = this.children;
		//var next_children : Array<GameObject> = [];
		//
		//while ( (current_depth <= depth || depth == -1) && children.length > 0 ) {
					//
			//for ( child in children ) {
				//
				//trace("Checking ", child.id );
				//
				//if ( child.has( classType ) ) result.push( child );
				//
				//if ( current_depth < depth || depth == -1 ) {
					//next_children = next_children.concat( child.children );
				//}
			//}
			//
			//children = next_children;
			//next_children = [];
			//current_depth++;
			//
		//}
		//
		//trace("Quit searching", current_depth, depth, children.length );
		//
		//return result;
	//}
	
	
	/**
	 * 
	 */
		
	public function buildFrom( prefab : Prefab ) : GameObject {
		prefab.construct(this);
		return this;
	}
	
	/**
	 * End
	 */
	
	public function destroy() : Void {
		
		
		if ( destroyed ) {
			trace("Object already destroyed", id );
			return;
		}
		
		for ( cid in _components.keys() ) {
			var comp : Component = _components.get( cid );
			comp.onRemoved();
			comp.destroy();			
		}
		
		NormanApp.gameObjectManager.unregisterGameObject(this);
		//root.gameObjectManager.unregisterGameObject( this );
		_components = null;
		destroyed = true;
		
	}
	
	
	/**
	 * Convenience
	 */
	
	public function sendMessage( message : String, ?data : Dynamic = null ) : Void {
		messenger.sendMessage( message, data );
	}
	
	public function get_enabledInTree( ) : Bool {
		if ( transform.parent != null ) {
			return enabled && transform.parent.gameObject.enabledInTree;
		}else {
			return enabled;
		}
	}
		
}