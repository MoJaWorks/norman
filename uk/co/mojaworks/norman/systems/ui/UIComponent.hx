package uk.co.mojaworks.norman.systems.ui;

import msignal.Signal.Signal0;
import msignal.Signal.Signal1;
import uk.co.mojaworks.norman.display.Sprite;
import uk.co.mojaworks.norman.systems.components.Component;

/**
 * ...
 * @author Simon
 */
class UIComponent
{
	
	public var isMouseButtonDown : Array<Bool>;
	public var wasMouseButtonDownLastFrame : Array<Bool>;
	public var wasMouseButtonDownElsewhere : Array<Bool>;
	public var isMouseOver : Bool = false;
	public var wasMouseOverLastFrame : Bool = false;
	
	public var enabled : Bool = false;
	public var isCurrentTarget : Bool = false;
	
	public var clicked : Signal1<MouseEvent>;
	public var mouseOver : Signal1<MouseEvent>;
	public var mouseOut : Signal1<MouseEvent>;
	public var mouseDown : Signal1<MouseEvent>;
	public var mouseUp : Signal1<MouseEvent>;
	
	public var ownerSprite( default, null ) : Sprite;
	public var targetSprite( default, null ) : Sprite;
	
	public function new( owner : Sprite, target : Sprite ) 
	{
		ownerSprite = owner;
		targetSprite = target;
		
		isMouseButtonDown = [false, false, false];
		wasMouseButtonDownElsewhere = [false, false, false];
		wasMouseButtonDownLastFrame = [false, false, false];
		
		clicked = new Signal1<MouseEvent>();
		mouseOver = new Signal1<MouseEvent>();
		mouseOut = new Signal1<MouseEvent>();
		mouseDown = new Signal1<MouseEvent>();
		mouseUp = new Signal1<MouseEvent>();
		
		Systems.ui.add( this );
	}
	
	public function destroy() : Void {
		
		Systems.ui.remove( this );
		
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
		
		targetSprite = null;
		ownerSprite = null;
		
	}
	
}