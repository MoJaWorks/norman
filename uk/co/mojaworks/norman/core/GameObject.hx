package uk.co.mojaworks.norman.core;
import uk.co.mojaworks.norman.components.display.Sprite;
//import uk.co.mojaworks.norman.components.messenger.Messenger;
//import uk.co.mojaworks.norman.components.Prefab;
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
	//public var enabledInTree( get, never ) : Bool;
	public var destroyed : Bool = false;
	
	public function new( id : String = null ) 
	{		
		// Initialise state
		this.id = (id != null) ? id : (""+(nextId++));
		_components = new Map<String, Component>();
		
		// Add default components
		messenger = new Messenger();
		//add( messenger );
		
		transform = new Transform();
		add( transform );
		
		//NormanApp.gameObjectManager.registerGameObject(this);
		
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
		//if ( component.gameObject != null ) component.gameObject.removeById( component.getComponentType() );
		
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
	 * 
	 */
		
	//public function buildFrom( prefab : Prefab ) : GameObject {
		//prefab.construct(this);
		//return this;
	//}
	
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
		
		//NormanApp.gameObjectManager.unregisterGameObject(this);
		_components = null;
		destroyed = true;
		
	}
	
	
	/**
	 * Convenience
	 */
	
	public function sendMessage( message : String, ?data : Dynamic = null ) : Void {
		messenger.sendMessage( message, data );
	}
	
	//public function get_enabledInTree( ) : Bool {
		//if ( transform.parent != null ) {
			//return enabled && transform.parent.gameObject.enabledInTree;
		//}else {
			//return enabled;
		//}
	//}
	
	//public function get_parent() : GameObject {
		//if ( transform.parent != null ) {
			//return transform.parent.gameObject;
		//}else {
			//return null;
		//}
	//}
	
	//public function addChild( obj : GameObject ) {
		//transform.addChild( obj.transform );
	//}
	//
	//public function removeChild( obj : GameObject ) {
		//transform.removeChild( obj.transform );
	//}
	
	//public function getChildren() : Array<GameObject> {
		//var results : Array<GameObject> = [];
		//
		//for ( trans in transform.children ) {
			//results.push( trans.gameObject );
		//}
		//
		//return results;
	//}
		
}