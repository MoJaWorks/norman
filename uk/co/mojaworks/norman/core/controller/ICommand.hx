package uk.co.mojaworks.norman.core.controller;
import uk.co.mojaworks.norman.core.Messenger.MessageData;

/**
 * @author Simon
 */

interface ICommand 
{
	function execute( data : MessageData ) : Void;
}