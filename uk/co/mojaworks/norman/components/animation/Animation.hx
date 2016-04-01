package uk.co.mojaworks.norman.components.animation;
import uk.co.mojaworks.norman.components.Component;
import uk.co.mojaworks.norman.systems.Systems;
import uk.co.mojaworks.norman.systems.animation.AnimationSystem;


/**
 * ...
 * @author Simon
 */
class Animation extends Component implements IAnimation
{

	public var paused( default, null ) : Bool = false;
	
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