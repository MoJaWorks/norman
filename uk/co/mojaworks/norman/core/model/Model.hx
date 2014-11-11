package uk.co.mojaworks.norman.core.model;

/**
 * ...
 * @author Simon
 */
class Model
{

	private var _models : Map<String,IDataModel>;
	
	public function new() 
	{
		_models = new Map<String,IDataModel>();
	}
	
	public function addModel( model : IDataModel ) : Void {
		#if debug 
			if ( _models.get( model.getId() ) != null ) trace("Overwriting model with ID ", model.getId() );
		#end
		
		_models.set( model.getId(), model );		
	}
	
	public function getModel( id : String ) : IDataModel {
		return _models.get( id );
	}
	
	public function removeModel( id : String ) : Void {
		_models.remove( id );
	}

}