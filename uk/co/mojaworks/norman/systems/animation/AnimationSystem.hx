package uk.co.mojaworks.norman.systems.animation;
import motion.Actuate;
import uk.co.mojaworks.norman.components.animation.BaseAnimationComponent;
import uk.co.mojaworks.hopper.components.game.object.ball.Ball;
import uk.co.mojaworks.norman.components.Transform;
import uk.co.mojaworks.norman.factory.GameObject;
import uk.co.mojaworks.norman.systems.script.Call;
import uk.co.mojaworks.norman.systems.script.Sequence;
import uk.co.mojaworks.norman.systems.Systems;
import uk.co.mojaworks.norman.utils.LinkedList;

/**
 * ...
 * @author Simon
 */

@:enum abstract AnimationType(String) to String from String {
	var Game = "Game";
	var UI = "UI";
}
 
class AnimationSystem
{

	private var _animations : LinkedList<BaseAnimationComponent>;
	
	public function new() 
	{
		_animations = new LinkedList<BaseAnimationComponent>();
	}
	
	public function addAnimation( anim : BaseAnimationComponent ) : Void {
		_animations.push( anim );
	}
	
	public function removeAnimation( anim : BaseAnimationComponent ) : Void {
		_animations.remove( anim );
	}
	
	
	public function update( seconds : Float ) : Void {
		
		for ( anim in _animations ) {
			if ( anim.enabled && !anim.paused ) anim.update( seconds );
		}
		
	}
	
	public function pause( ?type : AnimationType = null ) : Void {
		
		for ( anim in _animations ) {
			if ( type == null || type == anim.type ) anim.pause( );
		}
		
	}
	
	public function resume( ?type : AnimationType = null ) : Void {
		
		for ( anim in _animations ) {
			if ( type == null || type == anim.type ) anim.resume( );
		}
		
	}
		
}