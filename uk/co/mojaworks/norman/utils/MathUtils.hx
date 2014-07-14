package uk.co.mojaworks.norman.utils;

/**
 * ...
 * @author Simon
 */
class MathUtils
{

	public function new() 
	{
		
	}
	
	public static function roundToNextPow2( val : Float ) : Int {
		return Std.int( Math.pow( 2, Math.ceil( Math.log( val ) / Math.log(2) ) ) );
	}
	
}