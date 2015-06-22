package uk.co.mojaworks.norman.ui;

import lime.math.Vector2;
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
	
	public function new( texture : TextureData ) 
	{
		super( texture );
	}
	
	public function update( seconds : Float ) : Void {
		
		var wasMouseDown : Bool = _mouseDown;
		var wasMouseOver : Bool = _mouseOver;
		var mouse : Vector2 = transform.globalToLocal( Systems.input.mousePosition );

		// Check mouse
		if ( mouse.x > 0 && mouse.x < texture.width && mouse.y > 0 && mouse.y < texture.height ) {
						
			_mouseOver = true;
			if ( !wasMouseOver ) onMouseOver();
			
			if ( wasMouseOver && Systems.input.mouseIsDown ) {
				_mouseDown = true;
				if ( !wasMouseDown ) onMouseDown();
			}else {
				_mouseDown = false;
				if ( wasMouseDown && !Systems.input.mouseIsDown ) {
					onMouseUp();
				}
			}
			
		}else {
			
			_mouseOver = false;
			_mouseDown = false;
			
			if ( wasMouseOver ) {
				onMouseOut();
			}
			
		}		
		
	}
	
	private function onMouseDown() : Void {
		_currentMultiplier = _mouseDownMultiplier;
		_tweenProgress = 0;
		_lastColor = color;
		_targetColor = Color.WHITE * _mouseDownMultiplier;
	}
	
	private function onMouseOver() : Void {
		_currentMultiplier = _hoverMultiplier;
		_tweenProgress = 0;
		_lastColor = color;
		_targetColor = Color.WHITE * _hoverMultiplier;
	}
	
	private function onMouseOut() : Void {
		_currentMultiplier = _defaultMultiplier;
		_tweenProgress = 0;
		_lastColor = color;
		_targetColor = Color.WHITE * _defaultMultiplier;
	}
	
	private function onMouseUp() : Void {
		
	}
}