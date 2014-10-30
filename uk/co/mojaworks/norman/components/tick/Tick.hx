package uk.co.mojaworks.norman.components.tick ;

import uk.co.mojaworks.norman.components.messenger.MessageData;
import uk.co.mojaworks.norman.core.Component;
import uk.co.mojaworks.norman.engine.NormanApp;

/**
 * ...
 * @author Simon
 */
class Tick extends Component
{
	static public inline var UPDATE : String = "tick_update";

	public function new() 
	{
		super();
	}
	
	override public function onAdded():Void 
	{
		super.onAdded();
		NormanApp.world.get(Ticker).registerTickable( this );
	}
	
	override public function onRemoved():Void 
	{
		super.onRemoved();
		NormanApp.world.get(Ticker).unregisterTickable( this );
	}
	
	override public function onUpdate(seconds:Float):Void 
	{
		super.onUpdate(seconds);
		gameObject.messenger.sendMessage( Tick.UPDATE, new MessageData( gameObject, Tick.UPDATE, seconds ) );
	}
	
}