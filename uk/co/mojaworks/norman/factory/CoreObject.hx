package uk.co.mojaworks.norman.factory;

/**
 * ...
 * @author Simon
 */
class CoreObject
{

	private var core( get, never ) : Core;
	@:noCompletion private function get_core( ) : Core
	{
		return Core.instance;
	}
	
	public function new() 
	{
		
	}
	
}