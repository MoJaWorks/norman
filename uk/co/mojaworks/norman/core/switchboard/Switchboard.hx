package uk.co.mojaworks.norman.core.switchboard ;


/**
 * ...
 * @author Simon
 */

typedef MessageListener = MessageData->Void; 


/**
 * 
 */
 
class Switchboard
{

	public var map : Map<String, Array<MessageListener>>;
	public var commands : Array<ICommand>;
	
	public function new() 
	{
		map = new Map<String, Array<MessageListener>>();
		commands = [];
	}
	
	public function addMessageListener( message : String, listener : MessageListener ) : Void {
		if ( !map.exists( message ) ) map.set( message, [] );
		map.get( message ).push( listener );
	}
	
	public function removeMessageListener( message : String, listener : MessageListener = null ) : Void {
		if ( map.exists( message ) ) {
			if ( listener != null ) {
				map.get( message ).remove( listener );
			}else {
				map.remove( message );
			}
		}
	}
	
	public function sendMessage( message : String, ?data : Dynamic ) : Void {
		var messageData : MessageData = new MessageData( message, data );
		if ( map.exists( messageData.message ) ) {
			for ( listener in map.get(messageData.message) ) {
				listener( messageData );
			}
		}
	}
	
	/**
	 * Commands
	 * @param	message
	 * @param	command
	 */
	
	public function addCommand( message : String, command : ICommand ) : Void {
		addMessageListener( message, command.execute );
		command.message = message;
		commands.push( command );
	}
	
	public function removeCommand( command : ICommand ) : Void {
		removeMessageListener( command.message, command.execute );
		commands.remove( command );
	}
	
	public function executeCommand( command : ICommand, ?data : Dynamic ) : Void {
		command.execute( new MessageData("", data ));
	}
	
}