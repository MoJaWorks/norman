package uk.co.mojaworks.frameworkv2.components ;

import openfl.geom.Matrix;
import uk.co.mojaworks.frameworkv2.components.display.Display;
import uk.co.mojaworks.frameworkv2.core.Component;
import uk.co.mojaworks.frameworkv2.core.GameObject;

/**
 * ...
 * @author Simon
 */
class Transform extends Component
{

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
	public var localTransform( get, never ) : Matrix;
	
	var _worldTransform : Matrix;
	var _localTransform : Matrix;
	
	var _isLocalDirty : Bool = true;
	var _isWorldDirty : Bool = true;
	
	public function new() 
	{
		super();
		
		_worldTransform = new Matrix();
		_localTransform = new Matrix();
	}
	
	override public function onAdded():Void 
	{
		super.onAdded();
		trace("OnAdded", gameObject.messenger );
		gameObject.messenger.attachListener( GameObject.ADDED_AS_CHILD, onAddedToParent );
	}
	
	private function onAddedToParent( object : GameObject, ?param : Dynamic ) : Void {
		invalidateMatrices();
	}
	
	public function invalidateMatrices() : Void {
		
		var update : Bool = !_isLocalDirty && !_isWorldDirty;
		_isLocalDirty = true;
		_isWorldDirty = true;
		
		if ( update ) {
			for ( child in gameObject.children ) {
				child.transform.invalidateMatrices();
			}
		}
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
		
		recalculateLocalTransform();
		
		if ( gameObject.parent != null ) _worldTransform = gameObject.parent.transform.worldTransform;
		else _worldTransform.identity();
	
		_worldTransform = _localTransform.mult( _worldTransform );
		
		_isWorldDirty = false;
		return worldTransform;
		
	}
	
	/**
	 * Centers the pivot based on the display
	 */
	public function centerPivot() : Void {
		if ( gameObject.has(Display) ) {
			setPivot( gameObject.get(Display).getNaturalWidth() * 0.5, gameObject.get(Display).getNaturalHeight() * 0.5 );
		}else {
			setPivot(0, 0);
		}
	}
	
	/**
	 * Convenience
	 */
	
	public function setPosition( x : Float, y : Float ) {
		this.x = x;
		this.y = y;
	}
	
	public function setScale( scale : Float ) : Void {
		this.scaleX = this.scaleY = scale;
	}
	
	public function setScaleXY( scaleX : Float, scaleY : Float ) : Void {
		this.scaleX = scaleX;
		this.scaleY = scaleY;
	}
	
	public function setPivot( x : Float, y : Float ) : Void {
		pivotX = x;
		pivotY = y;
	}
	
	public function setPadding( x : Float, y : Float ) : Void {
		paddingX = x;
		paddingY = y;
	}
	
	/**
	 * Getters
	 */
	
	private function get_worldTransform( ) : Matrix {
		if ( !_isWorldDirty && !_isLocalDirty ) {
			return _worldTransform;
		}else {
			return recalculateWorldTransform();
		}
	}
	
	private function get_localTransform( ) : Matrix {
		if ( !_isLocalDirty ) {
			return _localTransform;
		}else {
			return recalculateLocalTransform();
		}
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