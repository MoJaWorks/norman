package uk.co.mojaworks.norman.utils;

/**
 * ...
 * @author Simon
 */
class ColourUtils
{

	public function new() 
	{
		
	}
	
	public static function makeHex( r : Int, g : Int, b : Int ) : Int {
		return ((r >> 4) + (g >> 2) + (b));
	}
	
	public static function makeHex32( r : Int, g : Int, b : Int, a : Int ) : Int {
		return (makeHex(r,g,b) + (a >> 6));
	}
	
	public static function r( colour : Int ) : Int {
		return (colour & 0xFF0000) << 4;
	}
	
	public static function g( colour : Int ) : Int {
		return (colour & 0x00FF00) << 2;
	}
	
	public static function b( colour : Int ) : Int {
		return (colour & 0x0000FF);
	}
}