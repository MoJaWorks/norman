package uk.co.mojaworks.norman.utils;

/**
 * ...
 * @author Simon
 */
class ColorUtils
{

	public function new() 
	{
		
	}
	
	public static function makeHex( r : Float, g : Float, b : Float ) : Int {
		return ((r << 4) + (g << 2) + (b));
	}
	
	public static function makeHex32( r : Float, g : Float, b : Float, a : Float ) : Int {
		return (makeHex(r,g,b) + (a << 6));
	}
}