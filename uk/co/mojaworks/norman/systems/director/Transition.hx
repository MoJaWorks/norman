package uk.co.mojaworks.norman.systems.director;
import uk.co.mojaworks.norman.components.delegates.BaseUIDelegate;
import uk.co.mojaworks.norman.components.delegates.BaseViewDelegate;
import uk.co.mojaworks.norman.factory.GameObject;
import uk.co.mojaworks.norman.systems.script.Call;
import uk.co.mojaworks.norman.systems.script.Delay;
import uk.co.mojaworks.norman.systems.script.Sequence;

/**
 * ...
 * @author Simon
 */
class Transition
{

	public function new() 
	{
	}
	
	public function transition( to : GameObject, from : Array<BaseViewDelegate> = null, delay : Float = 0, callback : Void->Void = null ) : Void {
		
		// Override this
		Systems.scripting.run( new Sequence([
			new Delay( delay ),
			new Call( function() {
				if ( from != null ) for ( screen in from ) screen.hideAndDestroy();
				BaseViewDelegate.getFromObject(to).show();
				if ( callback != null ) callback();
			})
		]));
	}
	
}