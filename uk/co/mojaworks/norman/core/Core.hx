package uk.co.mojaworks.norman.core;
import uk.co.mojaworks.norman.components.display.Sprite;
import uk.co.mojaworks.norman.core.controller.Controller;
import uk.co.mojaworks.norman.core.Messenger.MessageCallback;
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
	public var view( default, null ) : View;
	public var model( default, null ) : Model;
	public var controller( default, null ) : Controller;
	
	// App contains specific systems e.g. root, renderer, soundEngine etc
	public var app( default, null ) : NormanApp;
	

	private function new() {
		view = new View();
		model = new Model();
		controller = new Controller();
		
		// Messenger added to root so will report messages as coming from root
		root = new GameObject();
	}
	
	public static function init( app : NormanApp ) : Void {
		getInstance().app = app;
	}
	
	public static function getInstance() : Core {
		if ( _instance == null ) _instance = new Core();
		return _instance;
	}
	
	public function sendMessage( message : String, data : Dynamic = null ) : Void {
		root.sendLocalMessage( message, data );
	}
	
	public function addMessageListener( message : String, listener : MessageCallback ) : Void {
		root.addLocalMessageListener( message, listener );
	}
	
	public function removeMessageListener( message : String, ?listener : MessageCallback = null ) : Void {
		root.removeLocalMessageListener( message, listener );
	}
	
}