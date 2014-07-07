package uk.co.mojaworks.norman.core ;

/**
 * ...
 * @author Simon
 */
class CoreObject
{

	var core( get, never ) : Core;
	
	#if !display
	private function get_core() : Core { return Core.instance; };
	#end
	
	public function new() 
	{
		
	}
	
}