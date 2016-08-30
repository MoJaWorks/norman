package uk.co.mojaworks.norman.utils;
import geoff.math.Vector2;

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
		var dot_val : Float = 0;
		
		for ( point in points ) 
		{
			dot_val = dot( point, axis );
			result[0] = Math.min( dot_val, result[0] );
			result[1] = Math.max( dot_val, result[1] );
		}
		
		return result;
	}
	
	public static function dot( point : Vector2, axis : Vector2 ) : Float 
	{
		return (point.x * axis.x) + ( point.y * axis.y );
	}
	
	
}