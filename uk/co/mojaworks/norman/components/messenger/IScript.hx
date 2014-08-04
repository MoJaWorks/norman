package uk.co.mojaworks.norman.components.messenger ;

/**
 * Scripts are disposable bits of code that run once and are then discarded
 * ...
 * @author Simon
 */
interface IScript
{
	
	function execute( data : MessageData ) : Void;
	
}