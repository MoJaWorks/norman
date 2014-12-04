package uk.co.mojaworks.norman.components ;

import lime.math.Matrix3;
import lime.math.Vector2;
import uk.co.mojaworks.norman.core.Component;

/**
 * ...
 * @author Simon
 */
class Transform extends Component
{
	
	public static inline var MATRIX_DIRTY : String = "MATRIX_DIRTY";
	
	public var x( default, set ) : Float = 0;
	public var y( default, set ) : Float = 0;
	
	public var scaleX( default, set ) : Float = 1;
	public var scaleY( default, set ) : Float = 1;
	
	public var rotation( default, set ) : Float = 0;
	
	// If a transform is a root then it will ignore it's parents transform
	// This is used for render targets to set up a new root structure
	public var isRoot( default, set ) : Bool = false;
	
	public var worldTransform( get, never ) : Matrix3;
	public var inverseWorldTransform( get, never ) : Matrix3;
	public var localTransform( get, never ) : Matrix3;
	
	var _worldTransform : Matrix3;
	var _inverseWorldTransform : Matrix3;
	var _localTransform : Matrix3;
	
	var _isLocalDirty : Bool = true;
	var _isWorldDirty : Bool = true;
	
	
	/**
	 * 
	 */
	
	public function new( ) 
	{
		super( );
		
		_worldTransform = new Matrix3();
		_localTransform = new Matrix3();
		_inverseWorldTransform = new Matrix3();
	}
		
	/**
	 * 
	 * @param	local
	 * @param	world
	 */
	
	public function invalidateMatrices( local : Bool = true, world : Bool = true ) : Void {
		
		var update : Bool = !_isLocalDirty && !_isWorldDirty;
		_isLocalDirty = local;
		_isWorldDirty = world;
		
		if ( update ) {
			for ( child in gameObject.children ) {
				child.transform.invalidateMatrices( false, true );
			}
		}
		
		gameObject.messenger.sendMessage( MATRIX_DIRTY );
	}	
	
	private function recalculateLocalTransform() : Void {
		_localTransform.identity();
		_localTransform.scale( scaleX, scaleY );
		_localTransform.rotate( rotation );
		_localTransform.translate( x, y );
		_isLocalDirty = false;
	}
	
	private function recalculateWorldTransform() : Void {
		
		if ( _isLocalDirty ) recalculateLocalTransform();
		_worldTransform.copyFrom( _localTransform );
			
		if ( gameObject.parent != null && !gameObject.parent.transform.isRoot ) {
			_worldTransform.concat( gameObject.parent.transform.worldTransform );
		}
			
		_inverseWorldTransform.copyFrom(_worldTransform);
		_inverseWorldTransform.invert();
		
		_isWorldDirty = false;
		
	}
	
	
	
	/**
	 * Convenience
	 */
	
	public function setPosition( x : Float, y : Float ) : Transform {
		this.x = x;
		this.y = y;
		return this;
	}
	
	public function setScale( scale : Float ) : Transform {
		this.scaleX = this.scaleY = scale;
		return this;
	}
	
	public function setScaleXYZ( scaleX : Float, scaleY : Float ) : Transform {
		this.scaleX = scaleX;
		this.scaleY = scaleY;
		return this;
	}
	
	/**
	 * Getters
	 */
	
	private function get_worldTransform( ) : Matrix3 {
		
		if ( _isWorldDirty || _isLocalDirty ) {
			recalculateWorldTransform();
		}
		return _worldTransform;
	}
	
	private function get_localTransform( ) : Matrix3 {
		
		if ( _isLocalDirty ) {
			recalculateLocalTransform();
		}
		return _localTransform;
	}
	
	private function get_inverseWorldTransform( ) : Matrix3 {
		
		if ( _isWorldDirty || _isLocalDirty ) {
			recalculateWorldTransform();
		}
		return _inverseWorldTransform;
	}
	
	public function localToGlobal( point : Vector2 ) : Vector2 {
		return worldTransform.transformVector2( point );
	}
	
	public function globalToLocal( point : Vector2 ) : Vector2 {
		return inverseWorldTransform.transformVector2( point );
	}
	
	/**
	 * Setters
	 */
		
	private function set_x( _x : Float ) : Float { x = _x; invalidateMatrices(); return x; }
	private function set_y( _y : Float ) : Float { y = _y; invalidateMatrices(); return y; }
	private function set_scaleX( _scaleX : Float ) : Float { scaleX = _scaleX; invalidateMatrices(); return scaleX; }
	private function set_scaleY( _scaleY : Float ) : Float { scaleY = _scaleY; invalidateMatrices(); return scaleY; }
	private function set_rotation( _rotation : Float ) : Float { rotation = _rotation; invalidateMatrices(); return rotation; }
	private function set_isRoot( _isRoot : Bool ) : Bool { isRoot = _isRoot; invalidateMatrices(); return isRoot; }
	
		
	/**
	 * Destroy
	 */
	
	override public function destroy() : Void {
		
		_worldTransform = null;
		_localTransform = null;
		//_renderTransform = null;
		_inverseWorldTransform = null;
	
	}
	
}