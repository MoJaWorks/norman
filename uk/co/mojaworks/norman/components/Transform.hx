package uk.co.mojaworks.norman.components ;

import lime.math.Matrix4;
import lime.math.Vector4;
import uk.co.mojaworks.norman.components.display.Sprite;
import uk.co.mojaworks.norman.core.Component;
import uk.co.mojaworks.norman.core.view.GameObject;
import uk.co.mojaworks.norman.utils.MathUtils;

/**
 * ...
 * @author Simon
 */
class Transform extends Component
{
	
	public static inline var MATRIX_DIRTY : String = "MATRIX_DIRTY";
	
	public var x( default, set ) : Float = 0;
	public var y( default, set ) : Float = 0;
	public var z( default, set ) : Float = 0;
	
	public var anchorX( default, set ) : Float = 0;
	public var anchorY( default, set ) : Float = 0;
	public var anchorZ( default, set ) : Float = 0;
	
	public var paddingX( default, set ) : Float = 0;
	public var paddingY( default, set ) : Float = 0;
	
	public var scaleX( default, set ) : Float = 1;
	public var scaleY( default, set ) : Float = 1;
	
	public var rotation( default, set ) : Float;
	
	public var worldTransform( get, never ) : Matrix4;
	public var inverseWorldTransform( get, never ) : Matrix4;
	public var localTransform( get, never ) : Matrix4;
	
	var _worldTransform : Matrix4;
	var _inverseWorldTransform : Matrix4;
	var _localTransform : Matrix4;
	
	var _isLocalDirty : Bool = true;
	var _isWorldDirty : Bool = true;
	
	
	/**
	 * 
	 */
	
	public function new( gameObject : GameObject ) 
	{
		super( gameObject );
		
		_worldTransform = new Matrix4();
		_localTransform = new Matrix4();
		_inverseWorldTransform = new Matrix4();
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
		_localTransform.prependTranslation( paddingX, paddingY, 0 );
		_localTransform.prependTranslation( -anchorX, -anchorY, -anchorZ );
		_localTransform.prependScale( scaleX, scaleY, 1 );
		_localTransform.prependRotation( rotation * MathUtils.RAD2DEG, Vector4.Z_AXIS );
		_localTransform.prependTranslation( x, y, z );
		_isLocalDirty = false;
	}
	
	private function recalculateWorldTransform() : Void {
		
		if ( _isLocalDirty ) recalculateLocalTransform();
		_worldTransform.copyFrom( _localTransform );
				
		if ( gameObject.parent != null ) {
			_worldTransform.prepend( gameObject.parent.transform.worldTransform );
		}
			
		_inverseWorldTransform.copyFrom(_worldTransform);
		_inverseWorldTransform.invert();
		
		_isWorldDirty = false;
		
	}
	
	/**
	 * Centers the pivot based on the display
	 */
	
	public function centerPivot() : Transform {
		if ( gameObject.sprite != null ) {
			setAnchor( gameObject.sprite.getNaturalWidth() * 0.5, gameObject.sprite.getNaturalHeight() * 0.5 );
		}else {
			setAnchor(0, 0);
		}
		
		return this;
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
	
	public function setAnchor( x : Float, y : Float, z : Float = 0 ) : Transform {
		anchorX = x;
		anchorY = y;
		anchorZ = z;
		return this;
	}
	
	public function setPadding( x : Float, y : Float ) : Transform {
		paddingX = x;
		paddingY = y;
		return this;
	}
	
	/**
	 * Getters
	 */
	
	private function get_worldTransform( ) : Matrix4 {
		
		if ( _isWorldDirty || _isLocalDirty ) {
			recalculateWorldTransform();
		}
		return _worldTransform;
	}
	
	private function get_localTransform( ) : Matrix4 {
		
		if ( _isLocalDirty ) {
			recalculateLocalTransform();
		}
		return _localTransform;
	}
	
	private function get_inverseWorldTransform( ) : Matrix4 {
		
		if ( _isWorldDirty || _isLocalDirty ) {
			recalculateWorldTransform();
		}
		return _inverseWorldTransform;
	}
	
	public function localToGlobal( point : Vector4 ) : Vector4 {
		return worldTransform.transformVector( point );
	}
	
	public function globalToLocal( point : Vector4 ) : Vector4 {
		return inverseWorldTransform.transformVector( point );
	}
	
	/**
	 * Setters
	 */
		
	private function set_x( _x : Float ) : Float { x = _x; invalidateMatrices(); return x; }
	private function set_y( _y : Float ) : Float { y = _y; invalidateMatrices(); return y; }
	private function set_z( _z : Float ) : Float { z = _z; invalidateMatrices(); return z; }
	private function set_anchorX( _anchorX : Float ) : Float { anchorX = _anchorX; invalidateMatrices(); return anchorX; }
	private function set_anchorY( _anchorY : Float ) : Float { anchorY = _anchorY; invalidateMatrices(); return anchorY; }
	private function set_anchorZ( _anchorZ : Float ) : Float { anchorZ = _anchorZ; invalidateMatrices(); return anchorZ; }
	private function set_paddingX( _paddingX : Float ) : Float { paddingX = _paddingX; invalidateMatrices(); return paddingX; }
	private function set_paddingY( _paddingY : Float ) : Float { paddingY = _paddingY; invalidateMatrices(); return paddingY; }
	private function set_scaleX( _scaleX : Float ) : Float { scaleX = _scaleX; invalidateMatrices(); return scaleX; }
	private function set_scaleY( _scaleY : Float ) : Float { scaleY = _scaleY; invalidateMatrices(); return scaleY; }
	private function set_rotation( _rotation : Float ) : Float { rotation = _rotation; invalidateMatrices(); return rotation; }
	
		
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