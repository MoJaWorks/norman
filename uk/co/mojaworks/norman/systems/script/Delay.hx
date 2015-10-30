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
	public var paused( default, set ) : Bool;
	
	public function new( seconds : Float ) 
	{
		this.timeRemaining = seconds;
	}
	
	public function update( seconds : Float ) : Bool
	{
		
		if ( !paused ) 
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
		else 
		{
		
			unusedTime = 0;
			return false;
			
		}
	}
	
	public function dispose() : Void {
		
	}
	
	private function set_paused( bool : Bool ) : Bool 
	{
		return this.paused = bool;
	}
	
}