package uk.co.mojaworks.norman.core;
import uk.co.mojaworks.norman.core.controller.Controller;
import uk.co.mojaworks.norman.core.model.Model;
import uk.co.mojaworks.norman.core.view.View;

/**
 * ...
 * @author Simon
 */
class Core
{
	
	private static var _instance : Core;
	
	public var messenger( default, null ) : Messenger;
	public var view( default, null ) : View;
	public var model( default, null ) : Model;
	public var controller( default, null ) : Controller;
	
	// TODO: Add root
	// TODO: Add soundEngine
	
	
	private function new() {
		messenger = new Messenger();
		view = new View();
		model = new Model();
		controller = new Controller();
	}
	
	public static function getInstance() : Core {
		if ( _instance == null ) _instance = new Core();
		return _instance;
	}
	
}