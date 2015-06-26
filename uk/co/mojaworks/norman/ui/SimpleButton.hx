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
	
	public static var updateNum : Int = 0;
	
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
			
			updateNum++;
			
			// If mouse over
			if ( mouse.x > 0 && mouse.x < texture.width && mouse.y > 0 && mouse.y < texture.height ) {
				
				_mouseOver = true;
				if ( !wasMouseOver ) {
					onMouseOver();
				}
							
				if ( Systems.input.mouseIsDown ) {
					
					_mouseDown = true;
					
					if ( !wasMouseDown ) {
						
						
						// Dont discriminate against mouseDownElsewhere if on Android
						#if !mobile
							if ( wasMouseOver ) {
								onMouseDown();
							}
							else {
								_mouseDownElsewhere = true;
							}
						#else
							onMouseDown();
						#end
						
					}
					
				}else {
					
					_mouseDown = false;
					
					if ( wasMouseDown && !_mouseDownElsewhere ) {
						onMouseUp();
						onMouseClick();
					}
					
					_mouseDownElsewhere = false;
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
			
			_mouseDown = false;
			_mouseOver = false;
			_mouseDownElsewhere = false;
			
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