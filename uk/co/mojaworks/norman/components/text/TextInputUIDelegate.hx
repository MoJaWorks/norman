package uk.co.mojaworks.norman.components.text;
import uk.co.mojaworks.norman.core.io.pointer.PointerInput;

import lime.ui.MouseCursor;
import uk.co.mojaworks.norman.components.ui.UIDelegate;
import uk.co.mojaworks.norman.core.io.pointer.PointerInput.MouseButton;
import uk.co.mojaworks.norman.systems.Systems;
import uk.co.mojaworks.norman.systems.ui.PointerEvent;

/**
 * ...
 * @author Simon
 */
class TextInputUIDelegate extends UIDelegate
{
	
	public function new() 
	{
		super();
		cursor = MouseCursor.TEXT;
	}
	
	override public function onAdded():Void
	{
		super.onAdded();
		core.io.pointer.down.add( onStageMouseDown );
	}
	
	override public function onRemove():Void 
	{
		super.onRemove();
		core.io.pointer.down.remove( onStageMouseDown );
	}
	
	override public function onClick( e : PointerEvent ):Void 
	{
		super.onClick(e);
		
		var input : TextInput = TextInput.getFrom( gameObject );
		input.hasTextFocus = true;
		input.setCursorAtPosition( core.io.pointer.get( e.pointerId ).position );
		
	}
	
	private function onStageMouseDown( pointerId : Int, button : MouseButton ) : Void {
		
		if ( !gameObject.renderer.hitTest( core.io.pointer.get( pointerId ).position ) ) {
			TextInput.getFrom( gameObject ).hasTextFocus = false;
		}
		
	}
}