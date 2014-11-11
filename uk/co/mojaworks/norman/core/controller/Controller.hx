package uk.co.mojaworks.norman.core.controller;
import haxe.ds.StringMap;
import uk.co.mojaworks.norman.core.CoreObject;

/**
 * ...
 * @author Simon
 */


 
class Controller extends CoreObject
{
	
	var _commands : Array<ICommand>;

	public function new() 
	{
		super();
		_commands = [];
	}
	
	public function addCommand( message : String, command : ICommand ) : Void {
		
		_commands.push( command );
	}
	
}