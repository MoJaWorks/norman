package uk.co.mojaworks.norman.systems;
import haxe.io.Error;
import uk.co.mojaworks.norman.systems.components.ComponentSystem;
import uk.co.mojaworks.norman.systems.director.Director;
import uk.co.mojaworks.norman.systems.hardware.HardwareSystem;
import uk.co.mojaworks.norman.systems.input.InputSystem;
import uk.co.mojaworks.norman.systems.model.Model;
import uk.co.mojaworks.norman.systems.renderer.Renderer;
import uk.co.mojaworks.norman.systems.script.ScriptRunner;
import uk.co.mojaworks.norman.systems.switchboard.Switchboard;
import uk.co.mojaworks.norman.systems.ui.UISystem;

/**
 * ...
 * @author Simon
 */
class Systems
{

	public static var viewport( default, null ) : Viewport;
	static public var model( default, null ) : Model;
	static public var switchboard( default, null ) : Switchboard;
	static public var director( default, null ) : Director;
	static public var scripting( default, null ) : ScriptRunner;
	static public var input( default, null ) : InputSystem;
	static public var components( default, null ) : ComponentSystem;
	static public var renderer( default, null ) : Renderer;
	static public var hardware( default, null ) : HardwareSystem;
	static public var ui( default, null ) : UISystem;
	
	
	public function new()
	{
		throw "You cannot instantiate Systems: use Systems.init instead";
	}
	
	/**
	 * Start everything up
	 */
	
	public static function init() : Void {
		viewport = new Viewport();
		model = new Model();
		switchboard = new Switchboard();
		scripting = new ScriptRunner();
		input = new InputSystem();
		components = new ComponentSystem();
		renderer = new Renderer();
		director = new Director();
		hardware = new HardwareSystem();
		ui = new UISystem();
	}
	
}