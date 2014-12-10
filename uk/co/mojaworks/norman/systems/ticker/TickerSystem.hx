package uk.co.mojaworks.norman.systems.ticker;

import uk.co.mojaworks.norman.core.CoreObject;
import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * A ticker systems that updates all tickable items added to it
 * CAUTION: Do not use this if expecting any kind of order of execution
 * @author Simon
 */
class TickerSystem extends CoreObject
{

	private var _tickables : LinkedList<ITickable>;
	
	public function new() 
	{
		super();
		_tickables = new LinkedList<ITickable>();
	}
	
	public function add( tickable : ITickable ) : Void {
		_tickables.push( tickable );
	}
	
	public function remove( tickable : ITickable ) : Void {
		_tickables.remove( tickable );
	}
	
	public function tick( seconds : Float ) : Void {
		for ( tickable in _tickables ) {
			tickable.onUpdate( seconds );
		}
	}
	
}