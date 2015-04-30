package uk.co.mojaworks.norman.systems.switchboard ;

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
	
	public function execute( data : MessageData ) : Void 
	{
		action( data );
	}
	
	private function action( data : MessageData ) : Void {
		// Override this
	}
	
	
}