package uk.co.mojaworks.norman;
import uk.co.mojaworks.norman.systems.Viewport;
import uk.co.mojaworks.norman.systems.animation.AnimationSystem;
import uk.co.mojaworks.norman.systems.audio.AudioSystem;
import uk.co.mojaworks.norman.systems.io.IOSystems;
import uk.co.mojaworks.norman.systems.juggler.Juggler;
import uk.co.mojaworks.norman.systems.model.Model;
import uk.co.mojaworks.norman.systems.renderer.Renderer;
import uk.co.mojaworks.norman.systems.script.ScriptRunner;
import uk.co.mojaworks.norman.systems.switchboard.Switchboard;

/**
 * ...
 * @author Simon
 */
class Core
{

	public static var instance( get, never ) : Core;
	
	public var animation : AnimationSystem;
	public var audio : AudioSystem;
	public var io : IOSystems;
	public var juggler : Juggler;
	public var model : Model;
	public var renderer : Renderer;
	public var switchboard : Switchboard;
	public var viewport : Viewport;
	
	/**
	 * New
	 * @return
	 */
	
	private static function get_instance( ) : Core 
	{
		if ( instance == null ) instance = new Core();
		return instance;
	}
	
	public function new() 
	{
		
	}
	
	public function init()
	{
		animation = new AnimationSystem();
		audio = new AudioSystem();
		io = new IOSystems();
		juggler = new Juggler();
		model = new Model();
		renderer = new Renderer();
		switchboard = new Switchboard();
		viewport = new Viewport();
	}
	
}