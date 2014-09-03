package uk.co.mojaworks.norman.components.tick;

import uk.co.mojaworks.norman.core.Component;
import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * ...
 * @author Simon
 */
class Ticker extends Component
{

	var _tickables : LinkedList<Tick>;
	
	public function new() 
	{
		super();
		_tickables = new LinkedList<Tick>();
	}
	
	public function registerTickable( tick : Tick ) : Void {
		_tickables.push( tick );
	}
	
	public function unregisterTickable( tick : Tick ) : Void {
		_tickables.remove( tick );
	}
	
	override public function onUpdate(seconds:Float):Void 
	{
		super.onUpdate(seconds);
		
		for ( tickable in _tickables ) {
			tickable.onUpdate( seconds );
		}
	}
	
}