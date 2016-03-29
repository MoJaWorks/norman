package uk.co.mojaworks.norman.components.text;
import uk.co.mojaworks.norman.components.animation.BaseAnimation;
import uk.co.mojaworks.norman.components.Component;

/**
 * ...
 * @author Simon
 */
class TextInputCaretAnimation extends BaseAnimation
{

	var _on : Bool = true;
	var _timer : Float = 0.5;
	
	public function new() 
	{
		super();
	}
	
	override public function update(seconds:Float):Void 
	{
		super.update(seconds);
		
		if ( !paused ) {
			
			_timer -= seconds;
			if ( _timer <= 0 ) {
				_on = !_on;
				gameObject.renderer.visible = _on;
				_timer = 0.5;
			}
			
		}
	}
	
	
	
}