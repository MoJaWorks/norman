package uk.co.mojaworks.norman.utils;
import lime.math.Vector2;

/**
 * ...
 * @author Simon
 */

class PhysicsUtils
{

	public function new() 
	{
		
	}
	
	/**
	 * 
	 * Returns the min (0) and max (1) bounds after projecting a list of points onto an axis
	 * 
	 **/
	public static function projectShape( points : Array<Vector2>, axis : Vector2, result : Array<Float> ) : Array<Float> 
	{
		
		result[0] = Math.POSITIVE_INFINITY;
		result[1] = Math.NEGATIVE_INFINITY;
		var dot : Float = 0;
		
		for ( point in points ) 
		{
			dot = (point.x * axis.x) + ( point.y * axis.y );
			result[0] = Math.min( dot, result[0] );
			result[1] = Math.max( dot, result[1] );
		}
		
		return result;
	}
	
	
}