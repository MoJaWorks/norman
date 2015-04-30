package uk.co.mojaworks.norman.systems.script;

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