package uk.co.mojaworks.norman.core.view;

import uk.co.mojaworks.norman.components.display.Sprite;
import uk.co.mojaworks.norman.components.Transform;
import uk.co.mojaworks.norman.core.CoreObject;
import uk.co.mojaworks.norman.core.Messenger;
import uk.co.mojaworks.norman.utils.LinkedList;

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
	
	// Unique id
	public var id : String;
	public var autoId : Int;
	private static var _entityAutoIdCounter : Int = 0;
	
	// Each gameobject has it's own local messenger for local messages - there's nothing for non-locals here
	public var messenger : Messenger;
	public var transform : Transform;
	public var sprite : Sprite;
	
	// Default components
	private var _components : Map<String,Component>;
	
	// Children
	public var parent : GameObject;
	public var children : LinkedList<GameObject>;
	public var displayIndex( get, never ) : String;
	/**
	 * 
	 */

	public function new( id : String = null ) 
	{
		super();
		
		this.id = id;
		autoId = _entityAutoIdCounter++;
		
		children = new LinkedList<GameObject>();
		_components = new Map<String,Component>();
		
		messenger = new Messenger();
		add( messenger );
		
		transform = new Transform();
		add( transform );
		
	}
	
	/**
	 * Children
	 */
	
	public function addChild( child : GameObject ) @: Void {
		if ( child.parent != null ) {
			child.parent.removeChild( child );
		}
		children.push( child );
		child.sendLocalMessage( ADDED_AS_CHILD );
		child.parent = this;
		sendLocalMessage( CHILD_ADDED, child );
	}
	
	public function removeChild( child : GameObject ) : Void {
		if ( child.parent == this ) {
			child.sendLocalMessage( REMOVED_AS_CHILD );
			child.parent = null;
			children.remove( child );
			sendLocalMessage( CHILD_REMOVED, child );
		}
	}
	
	/**
	 * Messenger
	 */
	
	public function sendLocalMessage( message : String, data : Dynamic = null ) : Void {
		messenger.sendMessage( message, data );
	}
	
	public function addLocalMessageListener( message : String, callback : MessageCallback ) : Void {
		messenger.addMessageListener( message, callback );
	}
	
	public function removeLocalMessageListener( message : String, ?callback : MessageCallback = null ) : Void {
		messenger.removeMessageListener( message, callback );
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
	
	public function get_displayIndex( ) : String {
		if ( parent != null ) return parent.displayIndex + ":" + StringTools.lpad( Std.string( parent.children.indexOf( this ) ), "0", 5 );
		return "00000";
	}
	
}