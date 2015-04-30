package uk.co.mojaworks.norman.systems.script;
import haxe.Timer;
import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * ...
 * @author Simon
 */
class ScriptRunner
{

	var _autoId : Int = 0;
	var _scripts : LinkedList<IRunnable>;
	
	public function new() 
	{
		_scripts = new LinkedList<IRunnable>();
	}
	
	
	
	public function run( script : IRunnable ) : Int {
		
		script.id = _autoId++;
		_scripts.push( script );
		return script.id;
		
	}
	
	public function update( seconds : Float ) : Void {
		
		for ( script in _scripts ) {
			
			var complete : Bool = script.update( seconds );
			
			if ( complete ) {
				script.dispose();
				_scripts.remove( script );
			}else {
				// Nothing to see here
			}
		}
		
	}
	
	public function stop( id : Int ) : Void {
		
		for ( script in _scripts ) {
			if ( script.id == id ) {
				script.dispose();
				_scripts.remove( script );
			}
		}
		
	}
	
	public function dispose():Void 
	{
		for ( item in _scripts ) {
			item.dispose();
		}
		_scripts.clear();
		_scripts = null;
	}
	
}