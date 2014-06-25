package uk.co.mojaworks.frameworkv2.components.messenger ;
import uk.co.mojaworks.frameworkv2.core.CoreObject;
import uk.co.mojaworks.frameworkv2.core.GameObject;

/**
 * Scripts are disposable bits of code that run once and are then discarded
 * ...
 * @author Simon
 */
interface IScript
{
	
	function execute( object : GameObject, ?param : Dynamic ) : Void;
	
}