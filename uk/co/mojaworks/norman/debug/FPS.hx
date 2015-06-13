package uk.co.mojaworks.norman.debug;
import lime.Assets;
import uk.co.mojaworks.norman.display.TextSprite;
import uk.co.mojaworks.norman.utils.FontUtils;

/**
 * ...
 * @author Simon
 */
class FPS extends TextSprite
{
	
	public var framesPassed : Int = 0;
	public var timePassed : Float = 0;

	public function new() 
	{
		super();
		
		setFont( FontUtils.createFontFromAsset( "default/arial.fnt" ) );
		setText( "-- fps" );
		
	}
	
	public function update( seconds : Float ) : Void {
		
		framesPassed++;
		timePassed += seconds;
		
		setText( (framesPassed / timePassed) + " fps" );
		
		if ( timePassed > 2 ) {
			timePassed = 0;
			framesPassed = 0;
		}
		
	}
	
}