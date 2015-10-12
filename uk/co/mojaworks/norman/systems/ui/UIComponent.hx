package uk.co.mojaworks.norman.systems.ui;

import msignal.Signal.Signal0;
import uk.co.mojaworks.norman.display.Sprite;
import uk.co.mojaworks.norman.systems.components.Component;
import uk.co.mojaworks.norman.systems.ui.IUISprite;

/**
 * ...
 * @author Simon
 */
class UIComponent
{
	
	public var isMouseDown : Bool = false;
	public var wasMouseDownLastFrame : Bool = false;
	public var wasMouseDownElsewhere : Bool = false;
	public var isMouseOver : Bool = false;
	public var wasMouseOverLastFrame : Bool = false;
	
	public var enabled : Bool = false;
	public var isCurrentTarget : Bool = false;
	
	public var clicked : Signal0;
	public var mouseOver : Signal0;
	public var mouseOut : Signal0;
	public var mouseDown : Signal0;
	public var mouseUp : Signal0;
	
	public var sprite( default, null ) : Sprite;
	
	public function new( sprite : Sprite ) 
	{
		clicked = new Signal0();
		mouseOver = new Signal0();
		mouseOut = new Signal0();
		mouseDown = new Signal0();
		mouseUp = new Signal0();
	}
	
	public function destroy() : Void {
		
		clicked.removeAll();
		mouseOver.removeAll();
		mouseOut.removeAll();
		mouseDown.removeAll();
		mouseUp.removeAll();
		
		clicked = null;
		mouseOver = null;
		mouseOut = null;
		mouseUp = null;
		mouseDown = null;		
		
	}
	
}