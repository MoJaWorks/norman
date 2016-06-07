package uk.co.mojaworks.norman.components.io;
import uk.co.mojaworks.norman.components.Component;

/**
 * ...
 * @author Simon
 */
class KeyboardDelegate extends Component implements IKeyboardDelegate
{

	public function new() 
	{
		super();
		
	}
	
	override public function onAdded():Void 
	{
		super.onAdded();
		core.io.keyboard.addKeyboardDelegate( this );
	}
	
	override public function onRemove():Void 
	{
		super.onRemove();
		core.io.keyboard.removeKeyboardDelegate( this );
	}
	
	public function onTextEntry( text : String ) : Void {}
	public function onTextEdit( text : String ) : Void {}
	public function onKeyDown( key : Int, modifier : Int ) : Void {}
	public function onKeyUp( key : Int, modifier : Int ) : Void {}
}