package uk.co.mojaworks.norman.systems.animation;
import geoff.App;
import geoff.utils.LinkedList;
import motion.actuators.SimpleActuator;
import uk.co.mojaworks.norman.components.animation.IAnimation;
import uk.co.mojaworks.norman.systems.Systems.SubSystem;

/**
 * ...
 * @author Simon
 */

 
class AnimationSystem extends SubSystem
{

	private var _animations : LinkedList<IAnimation>;
	private var _paused : Bool = false;
	
	public function new() 
	{
		SimpleActuator.getTime = App.current.platform.getTime;
		
		super();
		_animations = new LinkedList<IAnimation>();
	}
	
	public function addAnimation( anim : IAnimation ) : Void {
		_animations.push( anim );
	}
	
	public function removeAnimation( anim : IAnimation ) : Void {
		_animations.remove( anim );
	}
	
	
	override public function update( seconds : Float ) : Void {
		
		if ( !_paused ) {
			for ( anim in _animations ) {
				if ( anim.enabled && !anim.paused ) anim.update( seconds );
			}
		}
		
		SimpleActuator.stage_onEnterFrame();
		
	}
	
	public function pause( ) : Void {
		_paused = true;
	}
	
	public function resume( ) : Void {
		_paused = false;
	}
		
}