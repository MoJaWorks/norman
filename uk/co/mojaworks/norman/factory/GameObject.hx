package uk.co.mojaworks.norman.factory;
import haxe.macro.Context;
import haxe.macro.Expr;
import uk.co.mojaworks.norman.components.IComponent;
import uk.co.mojaworks.norman.components.Transform;
import uk.co.mojaworks.norman.components.renderer.BaseRenderer;
import uk.co.mojaworks.norman.utils.LinkedList;

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
	
	public function _getComponent( type : String ) : IComponent
	{
		for ( component in components ) 
		{
			if ( component._identifiesAs( type ) ) return component;
		}
		
		return null;
	}
	
	
	#if !display @:generic #end
	public function get<T>( type : Class<T> ) : T 
	{
		//var result : T = null;
		
		for ( component in components ) 
		{
			//result = cast component;
			if ( Std.is( component, type ) ) return cast component;
		}
		
		trace("No component found for type ", type );
		
		return null;
	}
	
	#if !display @:generic #end
	public function getAll<T>( type : Class<T> ) : Array<T> 
	{
		var result : Array<T> = [];
		//var canCast : T = null;
		
		for ( component in components ) 
		{
			//canCast = cast component;
			if ( Std.is( component, type ) ) result.push( cast component );
		}
		
		return result;
	}
	
	public function add( component : IComponent ) : IComponent {
		component.gameObject = this;
		components.push( component );
		
		// Replace quick access types
		if ( Std.is( component, BaseRenderer ) )
		{
			this.renderer = cast component;
		}
		else if ( Std.is( component, Transform ) )
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
			this.renderer = cast get( BaseRenderer );
		}
		else if ( component == this.transform )
		{
			this.transform = cast get( Transform );
		}
		
		if ( destroyAfter ) component.destroy();
	}
		
	#if !display @:generic #end
	public function removeAllOf<T>( type : Class<T>, destroyAfter : Bool = true ) : Void
	{
		//var existing : T = null;
	
		for ( component in components ) 
		{
			//existing = cast component;
			if ( Std.is( component, type ) ) remove( component, destroyAfter );
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
		
	/**
	 * Finding components in children
	 */
	
	/*#if !display @:generic #end
	public function getAllOfTypeFromChildren<T:Component>( type : Class<T>, includeThisObject : Bool = true, useArray : Array<T> = null ) : Array<T> 
	{
		var result : Array<T>;
		
		if ( useArray != null ) {
			result = useArray;
		}else {
			result = [];
		}
		
		if ( includeThisObject ) {
			result.concat( getAll( type ) );
		}
		
		for ( child in transform.children ) {
			child.gameObject.getAllOfTypeFromChildren( type, true, result );
		}
		
		return result;
	}*/
	
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