package uk.co.mojaworks.norman.systems.switchboard ;
import uk.co.mojaworks.norman.controller.Switchboard.MessageData;

/**
 * ...
 * @author Simon
 */
class SingleUseCommand extends SimpleCommand
{

	public function new() 
	{
		super();
	}
	
	override public function execute(data : MessageData):Void 
	{
		action( data );
		destroy();
		
	}
	
	private function destroy() : Void {
		core.switchboard.removeCommand( this );
	}
	
}