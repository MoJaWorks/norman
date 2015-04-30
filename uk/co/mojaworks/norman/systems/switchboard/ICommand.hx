package uk.co.mojaworks.norman.systems.switchboard ;
import uk.co.mojaworks.norman.systems.switchboard.Switchboard.MessageData;

/**
 * @author Simon
 */

interface ICommand 
{
	var message : String;
	function execute( data : MessageData ) : Void;
}