package uk.co.mojaworks.norman.systems.script;

/**
 * ...
 * @author Simon
 */
class Call implements IRunnable
{

	public var id : Int;
	public var unusedTime : Float = 0;
	
	var _callback : Void->Void;
	
	public function new( callback : Void->Void )  
	{
		_callback = callback;
	}
	
	public function update(seconds:Float):Bool 
	{
		_callback();
		unusedTime = seconds;
		return true;
	}
	
	public function dispose():Void 
	{
		_callback = null;
	}
	
}