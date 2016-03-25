package uk.co.mojaworks.norman.systems.animation;
import motion.Actuate;
import uk.co.mojaworks.norman.components.animation.BaseAnimationComponent;
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

 
class AnimationSystem extends SubSystem
{

	private var _animations : LinkedList<BaseAnimationComponent>;
	private var _paused : Bool = false;
	
	public function new() 
	{
		super();
		_animations = new LinkedList<BaseAnimationComponent>();
	}
	
	public function addAnimation( anim : BaseAnimationComponent ) : Void {
		_animations.push( anim );
	}
	
	public function removeAnimation( anim : BaseAnimationComponent ) : Void {
		_animations.remove( anim );
	}
	
	
	override public function update( seconds : Float ) : Void {
		
		if ( !_paused ) {
			for ( anim in _animations ) {
				if ( anim.enabled && !anim.paused ) anim.update( seconds );
			}
		}
		
	}
	
	public function pause( ) : Void {
		_paused = true;
	}
	
	public function resume( ) : Void {
		_paused = false;
	}
		
}