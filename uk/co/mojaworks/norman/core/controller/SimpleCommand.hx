package uk.co.mojaworks.norman.core.controller;
import uk.co.mojaworks.norman.core.CoreObject;
import uk.co.mojaworks.norman.core.Messenger.MessageData;

/**
 * ...
 * @author Simon
 */
class SimpleCommand extends CoreObject implements ICommand
{

	public function new() 
	{
		super();
	}
	
	/* INTERFACE uk.co.mojaworks.norman.core.controller.ICommand */
	
	public function execute(data:MessageData):Void 
	{
		
	}
	
}