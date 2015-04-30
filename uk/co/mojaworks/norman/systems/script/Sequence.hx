package uk.co.mojaworks.norman.systems.script;

/**
 * ...
 * @author Simon
 */
class Sequence implements IRunnable
{
	
	public var id : Int;
	
	public var unusedTime : Float = 0;
	var _runnables : Array<IRunnable>;
	var _currentIndex : Int = 0;
	
	public function new( run : Array<IRunnable> ) 
	{
		_runnables = run;
	}
	
	public function update(seconds:Float):Bool 
	{
		var remainingSecondsThisRun = seconds;
		
		while ( _currentIndex < _runnables.length && remainingSecondsThisRun > 0 ) {
			var complete : Bool = _runnables[_currentIndex].update( seconds );
			remainingSecondsThisRun = _runnables[_currentIndex].unusedTime;
			if ( complete ) {
				++_currentIndex;
			}
		}		
		
		if ( _currentIndex >= _runnables.length ) {
			// Script is complete
			unusedTime = remainingSecondsThisRun;
			return true;
		}else {
			// Still going
			return false;
			unusedTime = 0;
		}
		
		
	}
	
	public function dispose():Void 
	{
		
	}
	
}