package uk.co.mojaworks.norman.systems.script;

/**
 * ...
 * @author Simon
 */
class Sequence implements IRunnable
{
	
	public var id : Int;
	
	public var paused( default, set ) : Bool;
	public var unusedTime : Float = 0;
	var _runnables : Array<IRunnable>;
	var _currentIndex : Int = 0;
	
	public function new( run : Array<IRunnable> ) 
	{
		_runnables = run;
	}
	
	public function update(seconds:Float):Bool 
	{
		
		if ( !paused ) 
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
		else
		{
			unusedTime = 0;
			return false;
		}
		
		
	}
	
	public function dispose():Void 
	{
		for ( runnable in _runnables ) {
			runnable.dispose();
		}
		
		_runnables = null;
	}
	
	public function set_paused( bool : Bool ) : Bool {
		return this.paused = bool;
	}
	
}