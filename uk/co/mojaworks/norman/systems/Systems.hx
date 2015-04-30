package uk.co.mojaworks.norman.systems;
import uk.co.mojaworks.norman.systems.components.ComponentSystem;
import uk.co.mojaworks.norman.systems.director.Director;
import uk.co.mojaworks.norman.systems.input.InputSystem;
import uk.co.mojaworks.norman.systems.model.Model;
import uk.co.mojaworks.norman.systems.script.ScriptRunner;
import uk.co.mojaworks.norman.systems.switchboard.Switchboard;

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
	
	public function new()
	{
		
	}
	
	/**
	 * Start everything up
	 */
	
	public static function init() : Void {
		viewport = new Viewport();
		model = new Model();
		switchboard = new Switchboard();
		director = new Director();
		scripting = new ScriptRunner();
		input = new InputSystem();
		components = new ComponentSystem();
	}
	
}