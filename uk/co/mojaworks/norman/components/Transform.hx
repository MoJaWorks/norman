package uk.co.mojaworks.norman.components ;

import openfl.geom.Matrix;
import openfl.geom.Point;
import uk.co.mojaworks.norman.components.display.Display;
import uk.co.mojaworks.norman.core.Component;
import uk.co.mojaworks.norman.core.GameObject;

/**
 * ...
 * @author Simon
 */
class Transform extends Component
{

	public static inline var MATRIX_DIRTY : String = "MATRIX_DIRTY";
	
	public var x( default, set ) : Float = 0;
	public var y( default, set ) : Float = 0;
	
	public var pivotX( default, set ) : Float = 0;
	public var pivotY( default, set ) : Float = 0;
	
	public var paddingX( default, set ) : Float = 0;
	public var paddingY( default, set ) : Float = 0;
	
	public var scaleX( default, set ) : Float = 1;
	public var scaleY( default, set ) : Float = 1;
	
	public var rotation( default, set ) : Float = 0;
	
	public var worldTransform( get, never ) : Matrix;
	public var inverseWorldTransform( get, never ) : Matrix;
	public var localTransform( get, never ) : Matrix;
	
	var _worldTransform : Matrix;
	var _inverseWorldTransform : Matrix;
	var _localTransform : Matrix;
	
	var _isLocalDirty : Bool = true;
	var _isWorldDirty : Bool = true;
	
	public function new() 
	{
		super();
		
		_worldTransform = new Matrix();
		_localTransform = new Matrix();
		_inverseWorldTransform = new Matrix();
	}
	
	override public function onAdded():Void 
	{
		super.onAdded();
		//trace("OnAdded", gameObject.messenger );
		gameObject.messenger.attachListener( GameObject.ADDED_AS_CHILD, onAddedToParent );
	}
	
	private function onAddedToParent( object : GameObject, ?param : Dynamic ) : Void {
		invalidateMatrices();
	}
	
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
	
	private function recalculateLocalTransform() : Matrix {
		_localTransform.identity();
		_localTransform.translate( paddingX, paddingY );
		_localTransform.translate( -pivotX, -pivotY );
		_localTransform.scale( scaleX, scaleY );
		_localTransform.rotate( rotation );
		_localTransform.translate( x, y );
		_isLocalDirty = false;
		return _localTransform;
	}
	
	private function recalculateWorldTransform() : Matrix {
		
		if ( _isLocalDirty ) recalculateLocalTransform();
		_worldTransform.copyFrom( _localTransform );
		
		if ( gameObject.parent != null ) {
			_worldTransform.concat( gameObject.parent.transform.worldTransform );
		}
			
		_inverseWorldTransform.copyFrom(_worldTransform);
		_inverseWorldTransform.invert();
		
		_isWorldDirty = false;
		return worldTransform;
		
	}
	
	/**
	 * Centers the pivot based on the display
	 */
	public function centerPivot() : Transform {
		if ( gameObject.has(Display) ) {
			setPivot( gameObject.get(Display).getNaturalWidth() * 0.5, gameObject.get(Display).getNaturalHeight() * 0.5 );
		}else {
			setPivot(0, 0);
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
	
	public function setScaleXY( scaleX : Float, scaleY : Float ) : Transform {
		this.scaleX = scaleX;
		this.scaleY = scaleY;
		return this;
	}
	
	public function setPivot( x : Float, y : Float ) : Transform {
		pivotX = x;
		pivotY = y;
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
	
	private function get_worldTransform( ) : Matrix {
		
		if ( _isWorldDirty || _isLocalDirty ) {
			recalculateWorldTransform();
		}
		
		return _worldTransform;
	}
	
	private function get_localTransform( ) : Matrix {
		
		if ( _isLocalDirty ) {
			recalculateLocalTransform();
		}
		
		return _localTransform;
	}
	
	private function get_inverseWorldTransform( ) : Matrix {
		
		if ( _isWorldDirty || _isLocalDirty ) {
			recalculateWorldTransform();
		}
		
		return _inverseWorldTransform;
	}
	
	public function localToGlobal( point : Point ) : Point {
		return worldTransform.transformPoint( point );
	}
	
	public function globalToLocal( point : Point ) : Point {
		return inverseWorldTransform.transformPoint( point );
	}
	
	/**
	 * Setters
	 */
		
	private function set_x( _x : Float ) : Float { x = _x; invalidateMatrices(); return x; }
	private function set_y( _y : Float ) : Float { y = _y; invalidateMatrices(); return y; }
	private function set_pivotX( _pivotX : Float ) : Float { pivotX = _pivotX; invalidateMatrices(); return pivotX; }
	private function set_pivotY( _pivotY : Float ) : Float { pivotY = _pivotY; invalidateMatrices(); return pivotY; }
	private function set_paddingX( _paddingX : Float ) : Float { paddingX = _paddingX; invalidateMatrices(); return paddingX; }
	private function set_paddingY( _paddingY : Float ) : Float { paddingY = _paddingY; invalidateMatrices(); return paddingY; }
	private function set_scaleX( _scaleX : Float ) : Float { scaleX = _scaleX; invalidateMatrices(); return scaleX; }
	private function set_scaleY( _scaleY : Float ) : Float { scaleY = _scaleY; invalidateMatrices(); return scaleY; }
	private function set_rotation( _rotation : Float ) : Float { rotation = _rotation; invalidateMatrices(); return rotation; }
	
}