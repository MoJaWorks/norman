package uk.co.mojaworks.norman.core.io.pointer;
import lime.math.Vector2;
import uk.co.mojaworks.norman.core.io.pointer.PointerInput.MouseButton;

/**
 * ...
 * @author Simon
 */
class Pointer
{

	public var id : Int;
	public var position( default, null ) : Vector2;
	
	var _buttonIsDown : Array<Bool>;
	var _buttonWasDownLastFrame : Array<Bool>;
	
	
	public function new( id : Int ) 
	{
		this.id = id;
		position = new Vector2();
						
		_buttonIsDown = [];
		_buttonWasDownLastFrame = [];
		for ( i in 0...PointerInput.MAX_BUTTONS )
		{
			_buttonIsDown.push( false );
			_buttonWasDownLastFrame.push( false );
		}
	}
	
	public function buttonIsDown( button : MouseButton ) : Bool 
	{
		var button_id : Int = button;
		
		if ( button_id >= 0 && button_id < PointerInput.MAX_BUTTONS ) {
			return _buttonIsDown[button_id];
		}
		
		return false;
	}
	
	public function buttonWasDownLastFrame( button : MouseButton ) : Bool 
	{
		var button_id : Int = button;
		
		if ( button_id >= 0 && button_id < PointerInput.MAX_BUTTONS ) {
			return _buttonWasDownLastFrame[button_id];
		}
		
		return false;
	}
	
	@:allow( uk.co.mojaworks.norman.core.io.pointer.PointerInput )
	private function updateButtonState( button : MouseButton, isDown : Bool ) : Void 
	{
		_buttonIsDown[button] = isDown;
	}
	
	@:allow( uk.co.mojaworks.norman.core.io.pointer.PointerInput )
	private function endFrame() : Void 
	{
		for ( button in 0...PointerInput.MAX_BUTTONS ) 
		{
			_buttonWasDownLastFrame[button] = _buttonIsDown[button];
		}
	}
	
	
}