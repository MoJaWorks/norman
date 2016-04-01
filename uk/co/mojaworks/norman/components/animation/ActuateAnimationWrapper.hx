package uk.co.mojaworks.norman.components.animation;
import motion.Actuate;
import motion.actuators.IGenericActuator;
import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * ...
 * @author Simon
 */
class ActuateAnimationWrapper extends Animation
{

	public static var HELLO : String = "Hello";
	
	private var _actuators : LinkedList<IGenericActuator>;
	
	public function new() 
	{
		super();
		_actuators = new LinkedList<IGenericActuator>();
	}
	
	private function addActuator( actuator : IGenericActuator, ?completeCallback : Void->Void ) : Void 
	{
		actuator.onComplete( onActuatorComplete, [actuator, completeCallback] );
		_actuators.push( actuator );
	}
	
	private function onActuatorComplete( actuator : IGenericActuator, ?callback : Void->Void ) : Void 
	{
		_actuators.remove( actuator );
		if ( callback != null ) callback();
	}
	
	override public function onRemove():Void 
	{
		super.onRemove();
		
		for ( actuator in _actuators ) {
			Actuate.stop( actuator, null, false, false );
		}
		_actuators.clear();
		
	}
	
	override public function pause():Void 
	{
		super.pause();
		
		for ( actuator in _actuators ) {
			Actuate.pause( actuator );
		}
	}
	
	override public function resume():Void 
	{
		super.resume();
		
		for ( actuator in _actuators ) {
			Actuate.resume( actuator );
		}
	}
	
}