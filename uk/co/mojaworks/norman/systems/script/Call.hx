package uk.co.mojaworks.norman.systems.script;

/**
 * ...
 * @author Simon
 */
class Call implements IRunnable
{

	public var id : Int;
	public var unusedTime : Float = 0;
	public var paused( default, set ) : Bool;
	
	var _callback : Void->Void;
	
	public function new( callback : Void->Void )  
	{
		_callback = callback;
	}
	
	public function update(seconds:Float):Bool 
	{
		if ( !paused ) {
			_callback();
			unusedTime = seconds;
			return true;
		}else {
			unusedTime = 0;
			return false;
		}
	}
	
	public function dispose():Void 
	{
		_callback = null;
	}
	
	private function set_paused( bool : Bool ) : Bool 
	{
		return this.paused = bool;
	}
	
}