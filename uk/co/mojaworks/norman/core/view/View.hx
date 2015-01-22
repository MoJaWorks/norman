package uk.co.mojaworks.norman.core.view;

/**
 * ...
 * @author Simon
 */
class View
{

	private var _mediators : Map<String,Mediator>;
	
	public function new() 
	{
		_mediators = new Map<String,Mediator>();
	}
	
	public function registerView( object : Mediator, id : String ) : Void {
		#if debug
			if ( _mediators.get( id ) != null ) trace("Overwriting Mediator with Id", id, "in view");
		#end
		
		_mediators.set( id, object );
	}
	
	public function getView( id : String ) : Mediator {
		return _mediators.get( id );
	}
	
	public function removeView( id : String ) : Void {
		_mediators.remove( id );
	}
	
}