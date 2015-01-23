package uk.co.mojaworks.norman.components.ui;
import uk.co.mojaworks.norman.components.display.Sprite;
import uk.co.mojaworks.norman.core.view.GameObject;

/**
 * ...
 * @author Simon
 */
class UIButton extends UIItem
{

	var _up : Sprite;
	var _down : Sprite;
	var _over : Sprite;
	var _hit : Sprite;
	
	var _container : GameObject;
	
	public function new( up : Sprite, over : Sprite = null, down : Sprite = null, hit : Sprite = null ) 
	{
		super();
		_up = up;
		_over = (over == null) ? _up : over;
		_down = (down == null) ? _over : down;
		_hit = hit;
		
	}
	
	override public function onAdded():Void 
	{
		super.onAdded();
		
		_container = new GameObject();
		gameObject.addChild( _container );
		
		if ( _hit != null ) gameObject.addChild( new GameObject().add( _hit ) );
	}
	
	override function updateState():Void 
	{
		super.updateState();
		
		if ( isPointerDown && isPointerOver ) {
			if ( _container.sprite != _down ) _container.add( _down );
			_container.transform.setPosition( 5, 5 );
		}else {
			_container.transform.setPosition( 0, 0 );
			if ( isPointerOver  ) {
				if ( _container.sprite != _over ) _container.add( _over );
			}else {
				if ( _container.sprite != _up ) _container.add( _up );
			}
		}
	}	
		
	override public function getHitSprite() : Sprite {
		if ( _hit == null ) {
			return _container.sprite;
		}else{
			return _hit;
		}
	}
	
}