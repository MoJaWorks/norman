package uk.co.mojaworks.frameworkv2.core ;

/**
 * ...
 * @author Simon
 */
class CoreObject
{

	var core( get, never ) : Core;
	function get_core() : Core { return Core.instance; };
	
	public function new() 
	{
		
	}
	
}