package uk.co.mojaworks.norman.core;
import uk.co.mojaworks.norman.core.controller.Controller;
import uk.co.mojaworks.norman.core.model.Model;
import uk.co.mojaworks.norman.core.view.GameObject;
import uk.co.mojaworks.norman.core.view.View;
import uk.co.mojaworks.norman.engine.NormanApp;

/**
 * ...
 * @author Simon
 */
class Core
{
	
	private static var _instance : Core;
	
	
	// default framework parts
	public var root( default, null ) : GameObject;
	public var messenger( default, null ) : Messenger;
	public var view( default, null ) : View;
	public var model( default, null ) : Model;
	public var controller( default, null ) : Controller;
	
	// App contains specific systems e.g. root, renderer, soundEngine etc
	public var app( default, null ) : NormanApp;
	

	private function new() {
		messenger = new Messenger();
		view = new View();
		model = new Model();
		controller = new Controller();
		
		// Messenger added to root so will report messages as coming from root
		root = new GameObject().add( messenger );
	}
	
	public static function init( app : NormanApp ) : Void {
		getInstance().app = app;
	}
	
	public static function getInstance() : Core {
		if ( _instance == null ) _instance = new Core();
		return _instance;
	}
	
}