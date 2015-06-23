package uk.co.mojaworks.norman.ui;

import lime.math.Vector2;
import msignal.Signal.Signal0;
import uk.co.mojaworks.norman.display.ImageSprite;
import uk.co.mojaworks.norman.display.Sprite;
import uk.co.mojaworks.norman.systems.renderer.TextureData;
import uk.co.mojaworks.norman.systems.Systems;
import uk.co.mojaworks.norman.utils.Color;
import uk.co.mojaworks.norman.utils.MathUtils;

/**
 * ...
 * @author Simon
 */
class SimpleButton extends ImageSprite
{
	
	var _mouseDown : Bool = false;
	var _mouseOver : Bool = false;
	var _mouseDownElsewhere : Bool = false;
	
	public var clicked : Signal0;
	public var enabled : Bool;
	
	public function new( texture : TextureData ) 
	{
		super( texture );
		clicked = new Signal0();
	}
	
	public function update( seconds : Float ) : Void {
		
		var wasMouseDown : Bool = _mouseDown;
		var wasMouseOver : Bool = _mouseOver;
		var mouse : Vector2 = transform.globalToLocal( Systems.input.mousePosition );

		// Check mouse
		if ( enabled ) {
			
			alpha = 1;
			
			if ( mouse.x > 0 && mouse.x < texture.width && mouse.y > 0 && mouse.y < texture.height ) {
							
				_mouseOver = true;
				if ( !wasMouseOver ) onMouseOver();
								
				if ( !wasMouseDown && Systems.input.mouseIsDown ) {
					if ( wasMouseOver && !_mouseDownElsewhere ) {
						_mouseDown = true;
						onMouseDown();
					}else {
						_mouseDownElsewhere = true;
					}
				}else {
					_mouseDown = false;
					if ( !Systems.input.mouseIsDown ) {
						if ( wasMouseDown ) {
							onMouseUp();
							onMouseClick();
						}else {
							_mouseDownElsewhere = false;
						}
					}
				}
				
			}else {
				
				_mouseOver = false;
				_mouseDown = false;
				_mouseDownElsewhere = false;
				
				if ( wasMouseOver ) {
					onMouseOut();
				}
				
			}
		}else {
			color = Color.WHITE;
			alpha = 0.5;
		}
		
	}
	
	private function onMouseDown() : Void {
		
	}
	
	private function onMouseOver() : Void {
		
	}
	
	private function onMouseOut() : Void {
		
	}
	
	private function onMouseUp() : Void {
		
	}
	
	private function onMouseClick() : Void {
		if ( enabled ) clicked.dispatch();
	}
}