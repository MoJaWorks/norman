package uk.co.mojaworks.norman.components.text;

import lime.ui.MouseCursor;
import uk.co.mojaworks.norman.components.delegates.BaseUIDelegate;
import uk.co.mojaworks.norman.systems.input.InputSystem.MouseButton;
import uk.co.mojaworks.norman.systems.Systems;
import uk.co.mojaworks.norman.systems.ui.MouseEvent;

/**
 * ...
 * @author Simon
 */
class TextInputUIDelegate extends BaseUIDelegate
{
	
	public function new() 
	{
		super();
		cursor = MouseCursor.TEXT;
	}
	
	override public function onAdded():Void
	{
		super.onAdded();
		Systems.input.mouseDown.add( onStageMouseDown );
	}
	
	override public function onRemove():Void 
	{
		super.onRemove();
		Systems.input.mouseDown.remove( onStageMouseDown );
	}
	
	override public function onClick(e:MouseEvent):Void 
	{
		super.onClick(e);
		
		var input : TextInput = TextInput.getFromObject(gameObject);
		input.hasTextFocus = true;
		input.setCursorAtPosition( Systems.input.mousePosition );
		
	}
	
	private function onStageMouseDown( button : MouseButton ) : Void {
		
		if ( !gameObject.renderer.hitTest( Systems.input.mousePosition ) ) {
			TextInput.getFromObject(gameObject).hasTextFocus = false;
		}
		
	}
}