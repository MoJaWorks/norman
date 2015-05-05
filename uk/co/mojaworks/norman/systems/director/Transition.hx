package uk.co.mojaworks.norman.systems.director;

/**
 * ...
 * @author Simon
 */
class Transition
{

	public function new() 
	{
	}
	
	public function transition( to : Screen, from : Screen = null, delay : Float = 0, callback : Void->Void = null ) : Void {
		
		// Override this
		//core.app.scripts.run( new Sequence([
			//new Delay( delay ),
			//new Call( function() {
				if ( from != null ) from.hide();
				to.show();
				if ( callback != null ) callback();
			//})
		//]));
	}
	
}