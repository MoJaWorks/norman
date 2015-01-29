package uk.co.mojaworks.norman.systems.script;
import uk.co.mojaworks.norman.core.CoreObject;
import uk.co.mojaworks.norman.systems.tick.ITickable;
import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * ...
 * @author Simon
 */
class ScriptRunner extends CoreObject implements ITickable
{

	var _autoId : Int = 0;
	var _scripts : LinkedList<IRunnable>;
	
	public function new() 
	{
		super();
		_scripts = new LinkedList<IRunnable>();
		core.app.tick.add( this );
	}
	
	
	
	public function run( script : IRunnable ) : Int {
		
		script.id = _autoId++;
		_scripts.push( script );
		return script.id;
		
	}
	
	public function update( seconds : Float ) : Void {
		
		for ( script in _scripts ) {
			if ( script.update( seconds ) ) {
				script.dispose();
				_scripts.remove( script );
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
	
	override public function dispose():Void 
	{
		super.dispose();
		for ( item in _scripts ) {
			item.dispose();
		}
		_scripts.clear();
		_scripts = null;
	}
	
}