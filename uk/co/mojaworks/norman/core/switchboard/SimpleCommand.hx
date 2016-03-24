package uk.co.mojaworks.norman.core.switchboard ;

/**
 * ...
 * @author Simon
 */
class SimpleCommand implements ICommand
{

	public var message : String;
	
	public function new() 
	{
	}
	
	public function execute( messageData : MessageData ) : Void 
	{
		action( messageData );
	}
	
	private function action( messageData : MessageData ) : Void {
		// Override this
	}
	
	
}