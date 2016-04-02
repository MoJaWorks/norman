package uk.co.mojaworks.norman.core.switchboard ;
import uk.co.mojaworks.norman.factory.CoreObject;

/**
 * ...
 * @author Simon
 */
class SimpleCommand extends CoreObject implements ICommand
{

	public var message : String;
	
	public function new() 
	{
		super();
	}
	
	public function execute( messageData : MessageData ) : Void 
	{
		action( messageData );
	}
	
	private function action( messageData : MessageData ) : Void 
	{
		// Override this
	}
	
	
}