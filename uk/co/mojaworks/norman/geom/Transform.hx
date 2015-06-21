package uk.co.mojaworks.norman.geom;
import lime.math.Matrix3;
import lime.math.Vector2;
import uk.co.mojaworks.norman.display.Sprite;
import uk.co.mojaworks.norman.systems.components.Component;
import uk.co.mojaworks.norman.utils.MathUtils;

/**
 * ...
 * @author Simon
 */
class Transform
{
	// Must make separate variables so reflection works with setters
	var _sprite : Sprite;
	var _anchorX : Float = 0;
	var _anchorY : Float = 0;
	var _x : Float = 0;
	var _y : Float = 0;
	var _scaleX : Float = 1;
	var _scaleY : Float = 1;
	var _rotation : Float = 0;
	
	public var anchorX( get, set ) : Float;
	public var anchorY( get, set ) : Float;
	
	public var x( get, set ) : Float;
	public var y( get, set ) : Float;
	
	public var scaleX( get, set ) : Float;
	public var scaleY( get, set ) : Float;
	
	public var rotation( get, set ) : Float;
	public var rotationDegrees( get, set ) : Float;
	
	public var worldMatrix( get, never ) : Matrix3;
	public var inverseWorldMatrix( get, never ) : Matrix3;
	public var localMatrix( get, never ) : Matrix3;
	
	// A special matrix used when rendering and is concated up to nearest root parent
	// Used for render textures
	public var renderMatrix( get, never ) : Matrix3;
	
	var _localMatrix : Matrix3;
	var _worldMatrix : Matrix3;
	var _inverseWorldMatrix : Matrix3;
	var _renderMatrix : Matrix3;
	
	
	public var isLocalDirty( default, null ) : Bool = true;
	public var isWorldDirty( default, null ) : Bool = true;
	public var isRenderDirty( default, null ) : Bool = true;
	
	public function new( sprite : Sprite ) 
	{
		_sprite = sprite;
		_worldMatrix = new Matrix3();
		_localMatrix = new Matrix3();
		_renderMatrix = new Matrix3();
		_inverseWorldMatrix = new Matrix3();
	}
	
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
		
		if ( _sprite.parent != null ) {
			_worldMatrix.concat( _sprite.parent.transform.worldMatrix );
		}
		
		_inverseWorldMatrix.copyFrom( _worldMatrix );
		_inverseWorldMatrix.invert();
		
		isWorldDirty = false;
		return _worldMatrix;		
		
	}
	
	private function recalculateRenderMatrix() : Matrix3 {
			
		_renderMatrix.copyFrom( localMatrix );
		
		if ( _sprite.parent != null && !_sprite.parent.isRoot ) {
			_renderMatrix.concat( _sprite.parent.transform.renderMatrix );
		}
		
		isRenderDirty = false;
		return _renderMatrix;		
		
	}
	
	public function invalidateMatrices( world : Bool, local : Bool ) : Void {
		if ( world ) {
			isRenderDirty = true;
			isWorldDirty = true;
			for ( child in _sprite.children ) {
				child.transform.invalidateMatrices( true, false );
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
	
	
	public function destroy() : Void {
		_worldMatrix = null;
		_localMatrix = null;
	}
	
	public function globalToLocal(p:Vector2) : Vector2
	{
		return inverseWorldMatrix.transformVector2(p);
	}
	
	public function localToGlobal(p:Vector2) : Vector2
	{
		return worldMatrix.transformVector2(p);
	}
	
}