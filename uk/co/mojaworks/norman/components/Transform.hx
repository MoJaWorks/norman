package uk.co.mojaworks.norman.components;
import lime.math.Matrix3;
import lime.math.Vector2;
import uk.co.mojaworks.norman.data.NormanMessages;
import uk.co.mojaworks.norman.components.Component;
import uk.co.mojaworks.norman.systems.director.Director.DisplayListAction;
import uk.co.mojaworks.norman.systems.Systems;
import uk.co.mojaworks.norman.utils.LinkedList;
import uk.co.mojaworks.norman.utils.MathUtils;

/**
 * ...
 * @author Simon
 */
class Transform extends Component
{
	
	public var parent( default, null ) : Transform;
	public var children( default, null ) : LinkedList<Transform>;
	public var displayOrder( default, null ) : Int = 0;
	public var isOnDisplayList( get, never ) : Bool;
	
	public var anchorX( get, set ) : Float;
	public var anchorY( get, set ) : Float;
	
	public var x( get, set ) : Float;
	public var y( get, set ) : Float;
	
	public var scaleX( get, set ) : Float;
	public var scaleY( get, set ) : Float;
	public var scale( never, set ) : Float;
	
	public var rotation( get, set ) : Float;
	public var rotationDegrees( get, set ) : Float;
	
	public var worldMatrix( get, never ) : Matrix3;
	public var inverseWorldMatrix( get, never ) : Matrix3;
	public var localMatrix( get, never ) : Matrix3;
	
	public var isLocalDirty( default, null ) : Bool = true;
	public var isWorldDirty( default, null ) : Bool = true;
	public var isRenderDirty( default, null ) : Bool = true;
	
	// A special matrix used when rendering and is concated up to nearest root parent
	// Used for render textures
	public var renderMatrix( get, never ) : Matrix3;
	
	// Separate variables so reflection works with setters
	var _anchorX : Float = 0;
	var _anchorY : Float = 0;
	var _x : Float = 0;
	var _y : Float = 0;
	var _scaleX : Float = 1;
	var _scaleY : Float = 1;
	var _rotation : Float = 0;
	var _localMatrix : Matrix3;
	var _worldMatrix : Matrix3;
	var _inverseWorldMatrix : Matrix3;
	var _renderMatrix : Matrix3;
	var _width : Float = 0;
	var _height : Float = 0;
	
	public var isRoot : Bool = false; // Defines this sprite as a root so render transforms end here
	
	public function new() 
	{
		super( );
		
		children = new LinkedList<Transform>();
		
		_worldMatrix = new Matrix3();
		_localMatrix = new Matrix3();
		_renderMatrix = new Matrix3();
		_inverseWorldMatrix = new Matrix3();
	}
	
	/**
	 * Heirarchy
	 */
	
	public function addChild( child : Transform ) : Void {
		
		// Remove from existing parent
		if ( child.parent != null ) child.parent.removeChild( child );
		
		child.parent = this;
		children.push( child );
		
		if ( isOnDisplayList ) {
			Systems.switchboard.sendMessage( NormanMessages.DISPLAY_LIST_CHANGED, DisplayListAction.Added );
		}
	}
	
	public function updateDisplayOrder( i : Int ) : Int {
			
		this.displayOrder = i++;
		
		for ( child in children ) {
			i = child.updateDisplayOrder(i);
		}
		
		return i;
	}
	
	public function removeChild( child : Transform ) : Void {
		child.parent = null;
		children.remove( child );
		
		if ( isOnDisplayList ) {
			Systems.switchboard.sendMessage( NormanMessages.DISPLAY_LIST_CHANGED, DisplayListAction.Removed );
		}
	}
		
	public function setChildIndex( index : Int ) : Void {
		if ( parent != null ) {
			
			// Make sure these are sane values
			// Negative values will loop
			if ( index >= parent.children.length ) index = parent.children.length - 1;
			while ( index < 0 ) index = parent.children.length + index;
			
			parent.children.move( parent.children.indexOf( this ), index );
			
			Systems.switchboard.sendMessage( NormanMessages.DISPLAY_LIST_CHANGED, DisplayListAction.Swapped );
		}
	}
	
	public function get_isOnDisplayList() : Bool {
		return (this == Systems.director.rootObject.transform ) || ( parent != null && parent.isOnDisplayList );
	}
	
	
	/**
	 * Transforms
	 */
	
	private function recalculateLocalMatrix() : Matrix3 {
		
		_localMatrix.identity();
		_localMatrix.translate( -anchorX, -anchorY );
		_localMatrix.scale( scaleX, scaleY );
		_localMatrix.rotate( rotation );
		_localMatrix.translate( x, y );
		
		isLocalDirty = false;
		return _localMatrix;
		
	}
	
	private function recalculateWorldMatrix() : Matrix3 {
		
		_worldMatrix.copyFrom( localMatrix );
		
		if ( parent != null ) {
			_worldMatrix.concat( parent.worldMatrix );
		}
		
		_inverseWorldMatrix.copyFrom( _worldMatrix );
		_inverseWorldMatrix.invert();
		
		isWorldDirty = false;
		return _worldMatrix;		
		
	}
	
	private function recalculateRenderMatrix() : Matrix3 {
			
		_renderMatrix.copyFrom( localMatrix );
		
		if ( parent != null && !parent.isRoot ) {
			_renderMatrix.concat( parent.renderMatrix );
		}
		
		isRenderDirty = false;
		return _renderMatrix;		
		
	}
	
	public function invalidateMatrices( world : Bool, local : Bool ) : Void {
		if ( world ) {
			isRenderDirty = true;
			isWorldDirty = true;
			for ( child in children ) {
				child.invalidateMatrices( true, false );
			}
		}
		if ( local ) isLocalDirty = true;
	}
	
	private function set_anchorX( val : Float ) : Float { _anchorX = val; invalidateMatrices( true, true ); return val; } 
	private function set_anchorY( val : Float ) : Float { _anchorY = val; invalidateMatrices( true, true ); return val; } 
	private function set_x( val : Float ) : Float { _x = val; invalidateMatrices( true, true ); return val; } 
	private function set_y( val : Float ) : Float { _y = val; invalidateMatrices( true, true ); return val; } 
	private function set_scaleX( val : Float ) : Float { _scaleX = val; invalidateMatrices( true, true ); return val; } 
	private function set_scaleY( val : Float ) : Float { _scaleY = val; invalidateMatrices( true, true ); return val; } 
	private function set_scale( val : Float ) : Float { _scaleY = val; _scaleX = val; invalidateMatrices( true, true ); return val; } 
	private function set_rotation( val : Float ) : Float { _rotation = val; invalidateMatrices( true, true ); return val; } 
	private function set_rotationDegrees( val : Float ) : Float { _rotation = val * MathUtils.DEG2RAD; invalidateMatrices( true, true ); return val; } 

	private function get_rotationDegrees( ) : Float { return _rotation * MathUtils.RAD2DEG; } 
	private function get_anchorX() : Float { return _anchorX; };
	private function get_anchorY() : Float { return _anchorY; };
	private function get_x() : Float { return _x; };
	private function get_y() : Float { return _y; };
	private function get_scaleX() : Float { return _scaleX; };
	private function get_scaleY() : Float { return _scaleY; };
	private function get_rotation() : Float { return _rotation; };
	
	private function get_worldMatrix( ) : Matrix3 {
		if ( isWorldDirty || isLocalDirty ) return recalculateWorldMatrix();
		else return _worldMatrix;
	}
	private function get_inverseWorldMatrix( ) : Matrix3 {
		if ( isWorldDirty || isLocalDirty ) recalculateWorldMatrix();
		return _inverseWorldMatrix;
	}
	private function get_localMatrix( ) : Matrix3 {
		if ( isLocalDirty ) return recalculateLocalMatrix();
		else return _localMatrix;
	}
	private function get_renderMatrix( ) : Matrix3 {
		if ( isRenderDirty ) return recalculateRenderMatrix();
		else return _renderMatrix;
	}
	
	public function globalToLocal(p:Vector2) : Vector2
	{
		return inverseWorldMatrix.transformVector2(p);
	}
	
	public function localToGlobal(p:Vector2) : Vector2
	{
		return worldMatrix.transformVector2(p);
	}
	
	override public function destroy() : Void {
		
		if ( parent != null ) parent.removeChild( this );
		
		if ( children != null ) {
			for ( child in children ) {
				child.destroy();
			}
			children.clear();
			children = null;
		}
		
		parent = null;
		
		_worldMatrix = null;
		_localMatrix = null;
		_renderMatrix = null;
		_inverseWorldMatrix = null;
	}
	
}