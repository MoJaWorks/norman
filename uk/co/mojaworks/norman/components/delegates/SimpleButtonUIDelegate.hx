package uk.co.mojaworks.norman.components.delegates;
import msignal.Signal;
import uk.co.mojaworks.norman.components.renderer.ImageRenderer;
import uk.co.mojaworks.norman.systems.ui.MouseEvent;
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
		
		clicked = new Signal1<MouseEvent>();
		
	}
	
	override public function onMouseDown( e : MouseEvent ) : Void {
		var spr : ImageRenderer = cast gameObject.renderer;
		spr.color = Color.grey( 150, 1 );
		trace("OnMouseDown");
	}
	
	override public function onMouseUp( e : MouseEvent ) : Void {
		var spr : ImageRenderer = cast gameObject.renderer;
		
		if ( isMouseOver ) {
			spr.color = Color.grey( 200, 1 );
		}else {
			spr.color = Color.WHITE;
		}
		
		trace("OnMouseUp");
		
	}
	
	override public function onMouseOver( e : MouseEvent ) : Void {
		var spr : ImageRenderer = cast gameObject.renderer;
		spr.color = Color.grey( 200, 1 );
		trace("OnMouseOver");
	}
	
	override public function onMouseOut( e : MouseEvent ) : Void {
		var spr : ImageRenderer = cast gameObject.renderer;
		spr.color = Color.WHITE;
		trace("OnMouseOut");
	}
	
	
}