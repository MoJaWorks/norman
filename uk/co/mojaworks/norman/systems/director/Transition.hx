package uk.co.mojaworks.norman.systems.director;
import uk.co.mojaworks.norman.components.director.IViewDelegate;
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
	
	public function transition( to : IViewDelegate, from : Array<IViewDelegate> = null, delay : Float = 0, callback : Void->Void = null ) : Void {
		
		// Override this
		Systems.scripting.run( new Sequence([
			new Delay( delay ),
			new Call( function() {
				if ( from != null ) for ( view in from ) view.hideAndDestroy();
				to.show();
				if ( callback != null ) callback();
			})
		]));
	}
	
}