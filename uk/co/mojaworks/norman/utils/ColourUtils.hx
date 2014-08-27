package uk.co.mojaworks.norman.utils;

/**
 * ...
 * @author Simon
 */
class ColourUtils
{
	
	public static inline var RATIO_255 = (1 / 255);
	
	public static function makeHex( r : Int, g : Int, b : Int ) : Int {
		return ((r << 16) + (g << 8) + (b));
	}
	
	public static function makeHex32( r : Int, g : Int, b : Int, a : Float ) : Int {
		return (makeHex(r,g,b) + (Math.round(a * 255) << 24));
	}
	
	public static function a( colour : Int ) : Float {
		return ((colour & 0xFF000000) >>> 24) * RATIO_255;
	}
	
	public static function r( colour : Int ) : Int {
		return (colour & 0xFF0000) >> 16;
	}
	
	public static function g( colour : Int ) : Int {
		return (colour & 0x00FF00) >> 8;
	}
	
	public static function b( colour : Int ) : Int {
		return (colour & 0x0000FF);
	}
	
}