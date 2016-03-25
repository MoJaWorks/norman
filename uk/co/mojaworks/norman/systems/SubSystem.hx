package uk.co.mojaworks.norman.systems;
import uk.co.mojaworks.norman.core.governor.IGovernable;
import uk.co.mojaworks.norman.factory.CoreObject;

/**
 * ...
 * @author Simon
 */
class SubSystem extends CoreObject implements IGovernable
{
	public var priority : Int;	
	public var id : String;

	public function new( ) 
	{
		super();
	}
	
	public function update( seconds : Float ) : Void 
	{
		
	}
	
}