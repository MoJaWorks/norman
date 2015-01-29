package uk.co.mojaworks.norman.systems.script;
import uk.co.mojaworks.norman.systems.tick.ITickable;

/**
 * @author Simon
 */

interface IRunnable
{
	
	var id : Int;
	var unusedTime : Float;
	
	// Return true when the script is complete and can be removed
	function update( seconds : Float ) : Bool;
	
	function dispose() : Void;
}