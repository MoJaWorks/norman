package uk.co.mojaworks.norman.core ;

/**
 * A base class for everything else to extend. Gives easy access to core instance.
 * @author Simon
 */
class RootObject
{

	var root( get, never ) : Root;
	
	#if !display
	private function get_root() : Root { return Root.instance; };
	#end
	
	public function new() 
	{
		
	}
	
}