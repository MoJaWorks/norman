package uk.co.mojaworks.norman.systems.script;

/**
 * Tweens a floating point value
 * ...
 * @author Simon
 */
class TweenTo implements IRunnable
{
	
	var _target : Dynamic;
	var _time : Float = 0;
	var _properties : Map<String, Dynamic>;
	var _start : Map<String, Dynamic>;
	
	var _timeRemaining : Float = 0;
	
	public function new( target : Dynamic,  time : Float, properties : Map<String, Dynamic> ) 
	{
		_target = target;
		_time = time;
		_properties = properties;
		_timeRemaining = time;
	}
	
	public function update(seconds:Float):Bool 
	{
		var progress : Float = (_time - _timeRemaining) / _time;
		
		for ( key in _properties.keys ) {
			
		}
		
		
	}
	
	public function dispose():Void 
	{
		
	}
	
}