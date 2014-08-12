package uk.co.mojaworks.norman.core ;

/**
 * A base class for everything else to extend. Gives easy access to core instance.
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