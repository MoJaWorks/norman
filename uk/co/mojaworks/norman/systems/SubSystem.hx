package uk.co.mojaworks.norman.systems;
import uk.co.mojaworks.norman.core.governor.IGovernable;

/**
 * ...
 * @author Simon
 */
class SubSystem implements IGovernable
{
	public var priority : Int;	
	public var id : String;

	public function new( ) 
	{
	}
	
	public function update( seconds : Float ) : Void 
	{
		
	}
	
}