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
	
	var _sprite : Sprite;
	
	public var anchorX( default, set ) : Float = 0;
	public var anchorY( default, set ) : Float = 0;
	
	public var x( default, set ) : Float = 0;
	public var y( default, set ) : Float = 0;
	
	public var scaleX( default, set ) : Float = 1;
	public var scaleY( default, set ) : Float = 1;
	
	public var rotation( default, set ) : Float = 0;
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
	
	public function set_anchorX( val : Float ) : Float { this.anchorX = val; invalidateMatrices( true, true ); return val; } 
	public function set_anchorY( val : Float ) : Float { this.anchorY = val; invalidateMatrices( true, true ); return val; } 
	public function set_x( val : Float ) : Float { this.x = val; invalidateMatrices( true, true ); return val; } 
	public function set_y( val : Float ) : Float { this.y = val; invalidateMatrices( true, true ); return val; } 
	public function set_scaleX( val : Float ) : Float { this.scaleX = val; invalidateMatrices( true, true ); return val; } 
	public function set_scaleY( val : Float ) : Float { this.scaleY = val; invalidateMatrices( true, true ); return val; } 
	public function set_rotation( val : Float ) : Float { this.rotation = val; invalidateMatrices( true, true ); return val; } 
	public function set_rotationDegrees( val : Float ) : Float { this.rotation = val * MathUtils.DEG2RAD; invalidateMatrices( true, true ); return val; } 
	public function get_rotationDegrees( ) : Float { return this.rotation * MathUtils.RAD2DEG; } 
	
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