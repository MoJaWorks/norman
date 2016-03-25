package uk.co.mojaworks.norman;
import uk.co.mojaworks.norman.core.Viewport;
import uk.co.mojaworks.norman.factory.GameObject;
import uk.co.mojaworks.norman.factory.ObjectFactory;
import uk.co.mojaworks.norman.systems.animation.AnimationSystem;
import uk.co.mojaworks.norman.core.audio.AudioSystem;
import uk.co.mojaworks.norman.core.io.IOSystems;
import uk.co.mojaworks.norman.core.governor.Governor;
import uk.co.mojaworks.norman.core.model.Model;
import uk.co.mojaworks.norman.core.renderer.Renderer;
import uk.co.mojaworks.norman.systems.script.ScriptRunner;
import uk.co.mojaworks.norman.core.switchboard.Switchboard;

/**
 * ...
 * @author Simon
 */
class Core
{

	@:isVar public static var instance( get, null ) : Core;
	
	public var root : GameObject;
	public var audio : AudioSystem;
	public var io : IOSystems;
	public var governor : Governor;
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
		root = ObjectFactory.createGameObject("root");
		audio = new AudioSystem();
		io = new IOSystems();
		governor = new Governor();
		model = new Model();
		renderer = new Renderer();
		switchboard = new Switchboard();
		viewport = new Viewport();
	}
	
}