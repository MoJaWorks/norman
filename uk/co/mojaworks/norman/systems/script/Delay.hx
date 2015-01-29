package uk.co.mojaworks.norman.systems.script;
import haxe.Timer;

/**
 * ...
 * @author Simon
 */
class Delay implements IRunnable
{

	public var id : Int;
	public var seconds : Float;
	public var unusedTime : Float = 0;
	
	public function new( seconds : Float ) 
	{
		this.seconds = seconds;
	}
	
	public function update( seconds : Float ) : Bool
	{
		// Update
		this.seconds -= seconds;
		if ( this.seconds <= 0 ) {
			// Delay complete
			unusedTime = -this.seconds;
			return true;
		}else {
			// Still going
			return false;
		}
	}
	
	public function dispose() : Void {
		
	}
	
}