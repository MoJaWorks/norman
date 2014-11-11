package uk.co.mojaworks.norman.utils;

/**
 * ...
 * @author Simon
 */
abstract Color( Int ) to Int from Int
{
	
	public static inline var RATIO_255 = (1 / 255);
	
	public var r( get, set ) : Int;
	public var g( get, set ) : Int;
	public var b( get, set ) : Int;
	public var a( get, set ) : Float;
	
	public inline function new( i : Int ) {
		this = i;
	}
	
	private inline function get_a() : Float { return ((this & 0xFF000000) >>> 24 ) * RATIO_255; }
	private inline function get_r() : Int { return (this & 0xFF0000) >> 16; }
	private inline function get_g() : Int { return (this & 0xFF00) >> 8; }
	private inline function get_b() : Int { return (this & 0xFF); }
	
	private inline function set_a( a : Float ) : Float {
		this = (this & 0x00FFFFFF) + (Math.round(a * 255) << 24 );
		return a;
	}
	
	private inline function set_r( r : Int ) : Int {
		this = (this & 0xFF00FFFF) + (r << 16);
		return r;
	}
	
	private inline function set_g( g : Int ) : Int {
		this = (this & 0xFFFF00FF) + (g << 8);
		return g;
	}
	
	private inline function set_b( b : Int ) : Int {
		this = (this & 0xFFFFFF00) + b;
		return b;
	}
	
	
}