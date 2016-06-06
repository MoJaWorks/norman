package uk.co.mojaworks.norman.components.io;
import geoff.event.Key;

/**
 * @author Simon
 */
interface IKeyboardDelegate extends IComponent
{
	public function onTextEntry( text : String ) : Void;
	public function onTextEdit( text : String ) : Void;
	public function onKeyDown( keyCode : Int, modifier : Int ) : Void;
	public function onKeyUp( keyCode : Int, modifier : Int ) : Void;
}