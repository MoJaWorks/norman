package uk.co.mojaworks.norman.components.animation;
import uk.co.mojaworks.norman.components.Component;
import uk.co.mojaworks.norman.systems.animation.AnimationSystem.AnimationType;
import uk.co.mojaworks.norman.systems.Systems;


/**
 * ...
 * @author Simon
 */
class BaseAnimationComponent extends Component
{

	public var paused( default, null ) : Bool = false;
	public var type( default, null ) : AnimationType;
	
	public function new() 
	{
		super();
	}
	
	override public function onAdded():Void 
	{
		super.onAdded();
		Systems.animation.addAnimation( this );
	}
	
	override public function onRemove():Void 
	{
		super.onRemove();
		Systems.animation.removeAnimation( this );
	}
	
	public function update( seconds : Float ) : Void { }
	
	public function pause( ) : Void {
		paused = true;
	}
	
	public function resume( ) : Void {
		paused = false;
	}
	
}