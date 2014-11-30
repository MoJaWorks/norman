package uk.co.mojaworks.norman.components.debug ;

import uk.co.mojaworks.norman.components.display.text.TextSprite;
import uk.co.mojaworks.norman.core.Component;
import uk.co.mojaworks.norman.utils.FontUtils;

/**
 * ...
 * @author Simon
 */
class FPSCounter extends Component
{

	var text : TextSprite;
	var totalTime : Float = 0;
	var totalFrames : Int = 0;
	
	public function new() 
	{
		super();
	}
	
	override public function onAdded():Void 
	{
		super.onAdded();
		
		text = new TextSprite().setFont( FontUtils.createFontFromFnt( "default/arial.fnt" ) );
		gameObject.add( text );
		
		text.cacheAsBitmap = false;
	}
	
	override public function onUpdate(seconds:Float):Void 
	{
		super.onUpdate(seconds);
		
		totalFrames++;
		totalTime += seconds;
		
		text.text = Math.round( totalFrames / totalTime ) + "fps";
		
		//trace( text.text );
	}
	
}