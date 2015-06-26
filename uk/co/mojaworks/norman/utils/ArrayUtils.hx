package uk.co.mojaworks.norman.utils;

/**
 * ...
 * @author Simon
 */
class ArrayUtils
{

	public function new() 
	{
		
	}
	
	@:generic public static inline function randomFromArray<T>( array : Array<T> ) : T {
		return array[ Math.floor( Math.random() * array.length ) ];
	}
	
}