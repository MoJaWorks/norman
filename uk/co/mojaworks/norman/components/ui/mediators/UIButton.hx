package uk.co.mojaworks.norman.components.ui.mediators ;
import uk.co.mojaworks.norman.components.display.Sprite;
import uk.co.mojaworks.norman.components.ui.UITouchListener;
import uk.co.mojaworks.norman.core.view.GameObject;
import uk.co.mojaworks.norman.systems.ticker.ITickable;

/**
 * ...
 * @author Simon
 */
class UIButton extends Mediator
{

	var _up : Sprite;
	var _down : Sprite;
	var _over : Sprite;
	var _hit : Sprite;
	
	var _listener : UITouchListener;
	var _mouseDownOverThis : Bool = false;
	
	public var container( default, null ) : GameObject;
	
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
		
		container = new GameObject();
		gameObject.addChild( container );
		
		_listener = new UITouchListener();
		_listener.hitSprite = _hit;
		container.add( _listener );
		
			
		if ( _hit != null ) gameObject.addChild( new GameObject().add( _hit ) );
		
		core.app.ticker.add( this );
	}
	
	override public function onRemoved():Void 
	{
		super.onRemoved();
		container.destroy();
		
		core.app.ticker.remove( this );
	}
	
	
	override public function onUpdate( seconds : Float ):Void 
	{
		
		var _isPointerDown : Bool = core.app.input.getPointerInfo(0).isDown;
		
		if ( _isPointerDown && _listener.isPointerOver ) {
			if ( container.sprite != _down ) {
				container.add( _down );
				container.transform.setPosition( 5, 5 );
			}
		}else {
			container.transform.setPosition( 0, 0 );
			if ( _listener.isPointerOver  ) {
				if ( container.sprite != _over ) container.add( _over );
			}else {
				if ( container.sprite != _up ) container.add( _up );
			}
		}
		
	}	
		
	
}