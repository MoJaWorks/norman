package uk.co.mojaworks.frameworkv2.common.modules.director.transitions;

import motion.Actuate;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import uk.co.mojaworks.frameworkv2.common.modules.director.ITransition;

/**
 * ...
 * @author Simon
 */
class ImmediateTransition implements ITransition
{

	public function new() 
	{
		
	}
	
	/* INTERFACE uk.co.mojaworks.frameworkv2.common.modules.director.ITransition */
	
	public function transition( parentSprite : Sprite, to:IView<DisplayObject>, from:IView<DisplayObject>, allowAnimateOut:Bool = true) 
	{
		if ( from != null ) {
			
			from.onDeactivate();
			
			var time : Float = from.onHide();
			if ( time > 0 && allowAnimateOut ) {
				Actuate.timer( time ).onComplete( progressToNextScreen, [parentSprite, to, from] );
			}else {
				progressToNextScreen( parentSprite, to, from );
			}
			
		}else {
			progressToNextScreen( parentSprite, to, from );
		} 
	}
	
	private static function progressToNextScreen( parentSprite : Sprite, to:IView<DisplayObject>, from:IView<DisplayObject> ) : Void {
		
		if ( from != null ) {
			parentSprite.removeChild( from.display );
			from.destroy();
		}
		
		parentSprite.addChild( to.display );
		to.onShow();
		to.onActivate();
		
	}
	
}