package uk.co.mojaworks.norman.components.debug;

import uk.co.mojaworks.norman.components.animation.Animation;
import uk.co.mojaworks.norman.components.renderer.TextRenderer;

/**
 * ...
 * @author ...
 */
class FPSUpdater extends Animation
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
		TextRenderer.getFrom( gameObject ).fontSize = 32;
	}
	
	override public function update( seconds : Float ) : Void {
		
		framesPassed++;
		timePassed += seconds;
		
		TextRenderer.getFrom( gameObject ).text = Math.round( framesPassed / timePassed) + " fps";
		
		if ( timePassed > 2 ) {
			timePassed = 0;
			framesPassed = 0;
		}
		
	}
	
	
	
}