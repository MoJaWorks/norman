package uk.co.mojaworks.norman.components.ui.button;
import uk.co.mojaworks.norman.components.delegates.BaseUIDelegate;
import uk.co.mojaworks.norman.components.renderer.ImageRenderer;
import uk.co.mojaworks.norman.systems.ui.PointerEvent;
import uk.co.mojaworks.norman.utils.Color;

/**
 * ...
 * @author Simon
 */
class SimpleButtonUIDelegate extends BaseUIDelegate
{

	public function new() 
	{
		super( );
	}
	
	override public function onMouseDown( e : PointerEvent ) : Void {
		var spr : ImageRenderer = cast gameObject.renderer;
		spr.color = Color.grey( 150, 1 );
		trace("OnMouseDown");
	}
	
	override public function onMouseUp( e : PointerEvent ) : Void {
		var spr : ImageRenderer = cast gameObject.renderer;
		
		if ( isMouseOver ) {
			spr.color = Color.grey( 200, 1 );
		}else {
			spr.color = Color.WHITE;
		}
		
		trace("OnMouseUp");
		
	}
	
	override public function onMouseOver( e : PointerEvent ) : Void {
		var spr : ImageRenderer = cast gameObject.renderer;
		spr.color = Color.grey( 200, 1 );
		trace("OnMouseOver");
	}
	
	override public function onMouseOut( e : PointerEvent ) : Void {
		var spr : ImageRenderer = cast gameObject.renderer;
		spr.color = Color.WHITE;
		trace("OnMouseOut");
	}
	
	
}