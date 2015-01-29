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
		while ( _currentIndex < _runnables.length && _runnables[_currentIndex].update( seconds ) ) {
			seconds -= _runnables[_currentIndex].unusedTime;
			++_currentIndex;
		}		
		
		if ( _currentIndex >= _runnables.length ) {
			unusedTime = seconds;
			return true;
		}else {
			unusedTime = 0;
		}
		return false;
	}
	
	public function dispose():Void 
	{
		
	}
	
}