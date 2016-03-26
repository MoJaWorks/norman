package uk.co.mojaworks.norman.components.debug;

import uk.co.mojaworks.norman.components.animation.BaseAnimationComponent;
import uk.co.mojaworks.norman.components.renderer.TextRenderer;

/**
 * ...
 * @author ...
 */
class FPSUpdater extends BaseAnimationComponent
{

	public var framesPassed : Int = 0;
	public var timePassed : Float = 0;
	
	public function new() 
	{
		super();
	}
	
	override public function onAdded():Void 
	{
		super.onAdded();
		gameObject.get(TextRenderer).fontSize = 32;
	}
	
	override public function update( seconds : Float ) : Void {
		
		framesPassed++;
		timePassed += seconds;
		
		gameObject.get(TextRenderer).text = Math.round( framesPassed / timePassed) + " fps";
		
		if ( timePassed > 2 ) {
			timePassed = 0;
			framesPassed = 0;
		}
		
	}
	
	
	
}