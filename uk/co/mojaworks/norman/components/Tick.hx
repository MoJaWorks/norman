package uk.co.mojaworks.norman.components;

import uk.co.mojaworks.norman.core.Component;

/**
 * ...
 * @author Simon
 */
class Tick extends Component
{

	var _tickables : List<Component>;
	
	public function new() 
	{
		super();
		_tickables = new List<Component>();
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		_tickables = null;
	}
	
	public function addTarget( target : Component ) : Void {
		_tickables.add( target );
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