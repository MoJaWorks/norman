package uk.co.mojaworks.norman.core.view;

import sys.db.Types.SString;
import uk.co.mojaworks.norman.components.Transform;
import uk.co.mojaworks.norman.core.Component;
import uk.co.mojaworks.norman.core.CoreObject;
import uk.co.mojaworks.norman.core.Messenger;

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
	
	//TODO: Components
	
	// Each gameobject has it's own local messenger for local messages - there's nothing for non-locals here
	public var messenger : Messenger;
	
	// Default components
	private var _components : Map<String,Component>;
	public var transform : Transform;
	
	// Children
	public var parent : GameObject;
	public var children : Array<GameObject>;
	
	/**
	 * 
	 */

	public function new() 
	{
		super();
		children = [];
		_components = new Map<String,Component>();
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
		sendLocalMessage( CHILD_ADDED, child );
	}
	
	public function removeChild( child : GameObject ) : Void {
		child.sendLocalMessage( REMOVED_AS_CHILD );
		children.remove( child );
		sendLocalMessage( CHILD_REMOVED, child );
	}
	
	/**
	 * Messenger
	 */
	
	public function sendLocalMessage( message : String, data : Dynamic = null ) : Void {
		messenger.sendMessage( message, data );
	}
	
	/**
	 * Components
	 */
	
	public function add( component : Component ) : GameObject {
		
		// Make sure this component is not attached to another game object
		if ( component.gameObject != null ) component.gameObject.removeComponent( component.getComponentType() );
		
		// Remove any others of this type
		removeComponent( component.getComponentType() );
		
		// Add this one
		_components.set( component.getComponentType() );
		
		// Tell the component it has been added
		component.gameObject = this;
		component.onAdded();
		
		return this;
	}
	
	public function get( type : String ) : Component {
		return _components.get( type );
	}
	
	public function has( type : String ) : Bool {
		return Std.is( _components.get( Reflect.field( classType, "TYPE" )), classType );
	}
	
	public function removeComponent( type : String ) : Void {
		get( type ).onRemoved();
		get( type ).gameObject = null;
		_components.remove( type );
	}
	
	
}