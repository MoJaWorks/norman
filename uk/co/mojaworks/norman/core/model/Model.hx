package uk.co.mojaworks.norman.core.model;

/**
 * ...
 * @author Simon
 */
class Model
{

	private var _proxies : Map<String,Proxy>;
	
	public function new() 
	{
		_proxies = new Map<String,Proxy>();
	}
	
	public function addProxy( proxy : Proxy ) : Void {
		#if debug 
			if ( _proxies.get( proxy.getId() ) != null ) trace("Overwriting model with ID ", proxy.getId() );
		#end
		
		_proxies.set( proxy.getId(), proxy );		
	}
	
	public function getProxy( id : String ) : Proxy {
		return _proxies.get( id );
	}
	
	public function removeProxy( id : String ) : Void {
		_proxies.remove( id );
	}

}