package uk.co.mojaworks.norman.core.switchboard ;
import uk.co.mojaworks.norman.core.switchboard.Switchboard.MessageData;

/**
 * @author Simon
 */

interface ICommand 
{
	var message : String;
	function execute( data : MessageData ) : Void;
}