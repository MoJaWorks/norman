package uk.co.mojaworks.norman.geom;
import lime.math.Matrix3;
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
	public var localMatrix( get, never ) : Matrix3;
	
	var _localMatrix : Matrix3;
	var _worldMatrix : Matrix3;
	
	
	public var isLocalDirty( default, null ) : Bool = true;
	public var isWorldDirty( default, null ) : Bool = true;
	
	public function new( sprite : Sprite ) 
	{
		_sprite = sprite;
		_worldMatrix = new Matrix3();
		_localMatrix = new Matrix3();
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
		
		isWorldDirty = false;
		return _worldMatrix;		
		
	}
	
	public function invalidateMatrices( world : Bool, local : Bool ) : Void {
		if ( world ) {
			isWorldDirty = true;
			for ( child in _sprite.children ) {
				child.transform.invalidateMatrices( true, false );
			}
		}
		if ( local ) isLocalDirty = true;
	}
	
	public function set_anchorX( val : Float ) : Float { _anchorX = val; invalidateMatrices( true, true ); return val; } 
	public function set_anchorY( val : Float ) : Float { _anchorY = val; invalidateMatrices( true, true ); return val; } 
	public function set_x( val : Float ) : Float { _x = val; invalidateMatrices( true, true ); return val; } 
	public function set_y( val : Float ) : Float { _y = val; invalidateMatrices( true, true ); return val; } 
	public function set_scaleX( val : Float ) : Float { _scaleX = val; invalidateMatrices( true, true ); trace("Calling setter scaleX", _scaleX); return val; } 
	public function set_scaleY( val : Float ) : Float { _scaleY = val; invalidateMatrices( true, true ); return val; } 
	public function set_rotation( val : Float ) : Float { _rotation = val; invalidateMatrices( true, true ); return val; } 
	public function set_rotationDegrees( val : Float ) : Float { _rotation = val * MathUtils.DEG2RAD; invalidateMatrices( true, true ); return val; } 
	
	public function get_rotationDegrees( ) : Float { return _rotation * MathUtils.RAD2DEG; } 
	public function get_anchorX() : Float { return _anchorX; };
	public function get_anchorY() : Float { return _anchorY; };
	public function get_x() : Float { return _x; };
	public function get_y() : Float { return _y; };
	public function get_scaleX() : Float { return _scaleX; };
	public function get_scaleY() : Float { return _scaleY; };
	public function get_rotation() : Float { return _rotation; };
	
	public function get_worldMatrix( ) : Matrix3 {
		if ( isWorldDirty || isLocalDirty ) return recalculateWorldMatrix();
		else return _worldMatrix;
	}
	public function get_localMatrix( ) : Matrix3 {
		if ( isLocalDirty ) return recalculateLocalMatrix();
		else return _localMatrix;
	}
	
	
	public function destroy() : Void {
		_worldMatrix = null;
		_localMatrix = null;
	}
	
}