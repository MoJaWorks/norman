package uk.co.mojaworks.norman.systems.model;

/**
 * ...
 * @author Simon
 */
class Model
{

	public var proxies( default, null ) : Map<String, Proxy>;
	
	public function new() 
	{
		proxies = new Map<String, Proxy>();
	}
	
	public function addProxy( proxy : Proxy ) : Void {
		proxies.set( proxy.id, proxy );
	}
	
	public function removeProxy( id : String ) : Void {
		proxies.remove( id );
	}
	
	public function getProxy( id : String ) : Proxy {
		return proxies.get( id );
	}
	
	
}