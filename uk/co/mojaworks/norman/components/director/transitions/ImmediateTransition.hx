package uk.co.mojaworks.norman.components.director.transitions ;

import motion.Actuate;
import openfl.display.Sprite;
import uk.co.mojaworks.norman.components.director.ITransition;
import uk.co.mojaworks.norman.components.director.View;
import uk.co.mojaworks.norman.core.GameObject;

/**
 * ...
 * @author Simon
 */
class ImmediateTransition implements ITransition
{

	public function new() 
	{
		
	}
	
	/* INTERFACE uk.co.mojaworks.norman.common.modules.director.ITransition */
	
	public function transition( parentObject : GameObject, to:GameObject, from:GameObject, allowAnimateOut:Bool = true) 
	{
		if ( from != null ) {
			
			var fromView : View = from.get(View);
			fromView.onDeactivate();
			
			var time : Float = fromView.onHide();
			if ( time > 0 && allowAnimateOut ) {
				Actuate.timer( time ).onComplete( progressToNextScreen, [parentObject, to, from] );
			}else {
				progressToNextScreen( parentObject, to, from );
			}
			
		}else {
			progressToNextScreen( parentObject, to, from );
		} 
	}
	
	private static function progressToNextScreen( parentObject : GameObject, to:GameObject, from:GameObject ) : Void {
		
		if ( from != null ) {
			parentObject.removeChild( from );
			from.destroy();
		}
		
		parentObject.addChild( to );
		var toView : View = to.get(View);
		toView.onShow();
		toView.onActivate();
		
	}
	
}