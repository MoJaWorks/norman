package uk.co.mojaworks.frameworkv2.common.modules.messenger ;
import uk.co.mojaworks.frameworkv2.core.CoreObject;

/**
 * Scripts are disposable bits of code that run once and are then discarded
 * ...
 * @author Simon
 */
interface IScript
{
	
	function execute( ?param : Dynamic ) : Void;
	
}