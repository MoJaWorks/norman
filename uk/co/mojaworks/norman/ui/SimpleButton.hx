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

	var _defaultMultiplier : Float = 0.9;
	var _currentMultiplier : Float = 0.9;
	var _targetColor : Color;
	var _lastColor : Color;
	var _tweenProgress : Float = 1;
	
	var _hoverMultiplier : Float;
	var _mouseDownMultiplier : Float;
	
	var _mouseDown : Bool = false;
	var _mouseDownElsewhere : Bool = false;
	var _mouseOver : Bool = false;
	
	public function new( texture : TextureData, defaultMultiplier : Float = #if mobile 1 #else 0.9 #end, hoverMultiplier : Float = 1 , downMultiplier : Float = 0.85 ) 
	{
		super( texture );
		
		_hoverMultiplier = hoverMultiplier;
		_mouseDownMultiplier = downMultiplier;
		_defaultMultiplier = defaultMultiplier;
		_currentMultiplier = _defaultMultiplier;
		
		color = Color.WHITE * defaultMultiplier;
	}
	
	public function update( seconds : Float ) : Void {
		
		
		var mouse : Vector2 = transform.globalToLocal( Systems.input.mousePosition );
		//trace("Updating button", mouse, Systems.input.mousePosition );
		
		// Check mouse
		if ( mouse.x > 0 && mouse.x < texture.width && mouse.y > 0 && mouse.y < texture.height ) {
			
			if ( Systems.input.mouseIsDown ) {
				if ( !_mouseDown && !_mouseOver ) _mouseDownElsewhere = true;
				_mouseDown = true;
			}else {
				_mouseDown = false;
			}
			
			_mouseOver = true;
			
		}else {
			
			_mouseOver = false;
			_mouseDown = false;
			_mouseDownElsewhere = false;
			
		}
		
		trace("Setting state ", _mouseOver, _mouseDown, _mouseDownElsewhere, _tweenProgress );
		
		
		// update display
		if ( _mouseDown && !_mouseDownElsewhere ) {
			if ( _currentMultiplier != _mouseDownMultiplier ) {
				_currentMultiplier = _mouseDownMultiplier;
				_tweenProgress = 0;
				_lastColor = color;
				_targetColor = Color.WHITE * _mouseDownMultiplier;
			}
		}else if ( _mouseOver ) {
			if ( _currentMultiplier != _hoverMultiplier ) {
				_currentMultiplier = _hoverMultiplier;
				_tweenProgress = 0;
				_lastColor = color;
				_targetColor = Color.WHITE * _hoverMultiplier;
			}
		}else if ( _currentMultiplier != _defaultMultiplier ) {
			_currentMultiplier = _defaultMultiplier;
			_tweenProgress = 0;
			_lastColor = color;
			_targetColor = Color.WHITE * _defaultMultiplier;
		}
		
		
		if ( _tweenProgress < 1 ) {
			//trace("Tweening to", _lastColor, _targetColor, _tweenProgress );
			_tweenProgress += seconds * 8;
			_tweenProgress = MathUtils.clamp01( _tweenProgress );
			color = Color.lerp( _lastColor, _targetColor, _tweenProgress );
			//trace("Set color to", color.r, color.g, color.b, "|", _targetColor.r, _targetColor.g, _targetColor.b );
		}
		
	}
	
}