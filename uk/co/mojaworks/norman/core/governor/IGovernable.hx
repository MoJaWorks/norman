package uk.co.mojaworks.norman.core.governor;

/**
 * @author Simon
 */
interface IGovernable 
{
	public var priority : Int;
	public var id : String;
	
	public function update( seconds : Float ) : Void;
}
