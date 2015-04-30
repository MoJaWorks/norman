package uk.co.mojaworks.norman.systems.script;
import haxe.Timer;

/**
 * ...
 * @author Simon
 */
class Delay implements IRunnable
{

	public var id : Int;
	public var timeRemaining : Float;
	public var unusedTime : Float = 0;
	
	public function new( seconds : Float ) 
	{
		this.timeRemaining = seconds;
	}
	
	public function update( seconds : Float ) : Bool
	{
		// Update
		timeRemaining -= seconds;
		if ( timeRemaining <= 0 ) {
			// Delay complete
			unusedTime = -timeRemaining;
			return true;
		}else {
			// Still going
			unusedTime = 0;
			return false;
		}
	}
	
	public function dispose() : Void {
		
	}
	
}