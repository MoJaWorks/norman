package uk.co.mojaworks.norman.components;

import uk.co.mojaworks.norman.core.Component;

/**
 * ...
 * @author Simon
 */
class Tick extends Component
{

	var _tickables : Array<Component>;
	
	public function new() 
	{
		super();
		_tickables = [];
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		_tickables = null;
	}
	
	public function addTarget( target : Component ) : Void {
		_tickables.push( target );
	}
	
	public function removeTarget( target : Component ) : Void {
		_tickables.remove( target );
	}
		
	override public function onUpdate(seconds:Float):Void 
	{
		super.onUpdate(seconds);
		
		for ( tickable in _tickables ) {
			if ( tickable.enabled ) tickable.onUpdate( seconds );
		}
		
	}
	
}