package uk.co.mojaworks.norman.display.ui;

import uk.co.mojaworks.norman.display.ImageSprite;
import uk.co.mojaworks.norman.display.Sprite;
import uk.co.mojaworks.norman.systems.renderer.TextureData;
import uk.co.mojaworks.norman.systems.ui.MouseEvent;
import uk.co.mojaworks.norman.systems.ui.UIComponent;

/**
 * ...
 * @author Simon
 */
class SimpleButton extends Sprite
{
	//var _mouseDown : Bool = false;
	//var _mouseOver : Bool = false;
	//var _mouseDownElsewhere : Bool = false;
	
	//public static var updateNum : Int = 0;
	
	//public var clicked : Signal0;
	//public var enabled : Bool;
	
	
	public var uiComponent( default, null ) : UIComponent;
	
	var image : ImageSprite;
	
	public function new( texture : TextureData ) 
	{
		super();
		
		image = new ImageSprite( texture );
		addChild( image );
		
		/*uiComponent = new UIComponent( this, image );
		uiComponent.mouseDown.add( onMouseDown );
		uiComponent.mouseUp.add( onMouseUp );
		uiComponent.mouseOver.add( onMouseOver );
		uiComponent.mouseOut.add( onMouseOut );*/
	}

	
	private function onMouseDown( e : MouseEvent ) : Void {
		trace("On button down");
	}
	
	private function onMouseOver( e : MouseEvent ) : Void {
		trace("On button over");
	}
	
	private function onMouseOut( e : MouseEvent) : Void {
		trace("On button out");
	}
	
	private function onMouseUp( e : MouseEvent ) : Void {
		trace("On button up");
	}
	
	override function get_width():Float 
	{
		return image.width;
	}
	
	override function get_height():Float 
	{
		return image.height;
	}
	
}