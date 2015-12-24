package uk.co.mojaworks.norman.systems;
import haxe.io.Error;
import uk.co.mojaworks.norman.systems.animation.AnimationSystem;
import uk.co.mojaworks.norman.systems.audio.AudioSystem;
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

	public static var audio( default, null ) : AudioSystem;
	public static var viewport( default, null ) : Viewport;
	static public var model( default, null ) : Model;
	static public var switchboard( default, null ) : Switchboard;
	static public var director( default, null ) : Director;
	static public var scripting( default, null ) : ScriptRunner;
	static public var input( default, null ) : InputSystem;
	static public var renderer( default, null ) : Renderer;
	static public var hardware( default, null ) : HardwareSystem;
	static public var ui( default, null ) : UISystem;
	static public var animation( default, null ) : AnimationSystem;
	
	
	
	public function new()
	{
		throw "You cannot instantiate Systems: use Systems.init instead";
	}
	
	/**
	 * Start everything up
	 */
	
	public static function init() : Void {
		audio = new AudioSystem();
		viewport = new Viewport();
		model = new Model();
		switchboard = new Switchboard();
		scripting = new ScriptRunner();
		input = new InputSystem();
		renderer = new Renderer();
		director = new Director();
		hardware = new HardwareSystem();
		ui = new UISystem();
		animation = new AnimationSystem();
	}
	
}