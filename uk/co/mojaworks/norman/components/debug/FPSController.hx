package uk.co.mojaworks.norman.components.debug;

import uk.co.mojaworks.norman.components.Component;
import uk.co.mojaworks.norman.components.renderer.TextRenderer;

/**
 * ...
 * @author ...
 */
class FPSController extends Component
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
		TextRenderer.getFromObject( gameObject ).fontSize = 32;
	}
	
	public function update( seconds : Float ) : Void {
		
		framesPassed++;
		timePassed += seconds;
		
		TextRenderer.getFromObject( gameObject ).text = Math.round( framesPassed / timePassed) + " fps";
		
		if ( timePassed > 2 ) {
			timePassed = 0;
			framesPassed = 0;
		}
		
	}
	
	
	
}