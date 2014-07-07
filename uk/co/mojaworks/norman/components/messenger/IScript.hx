package uk.co.mojaworks.norman.components.messenger ;
import uk.co.mojaworks.norman.core.CoreObject;
import uk.co.mojaworks.norman.core.GameObject;

/**
 * Scripts are disposable bits of code that run once and are then discarded
 * ...
 * @author Simon
 */
interface IScript
{
	
	function execute( object : GameObject, ?param : Dynamic ) : Void;
	
}